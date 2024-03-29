#include <ctype.h>
#include <iostream>
#include <set>
#include <jwt-cpp/jwt.h>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>
#include "database.hpp"

#define MAXIMUM_MESSAGE_LENGTH 500
#define MAXIMUM_FRAGMENT_LENGTH 200
#define TOKENS_LENGTH 2

#define INITIAL_CHIP_VALUE 9000

using namespace std;

/**
 * The source code is loosely based on https://github.com/zaphoyd/websocketpp/blob/master/examples/broadcast_server/broadcast_server.cpp
 */

// command|payload
typedef struct {
  char* command;
  char* payload;
} chippy_message;

struct connection_data {
  int sessionid;
  std::string name;
};

struct custom_config : public websocketpp::config::asio {
  // pull default settings from our core config
  typedef websocketpp::config::asio core;

  typedef core::concurrency_type concurrency_type;
  typedef core::request_type request_type;
  typedef core::response_type response_type;
  typedef core::message_type message_type;
  typedef core::con_msg_manager_type con_msg_manager_type;
  typedef core::endpoint_msg_manager_type endpoint_msg_manager_type;
  typedef core::alog_type alog_type;
  typedef core::elog_type elog_type;
  typedef core::rng_type rng_type;
  typedef core::transport_type transport_type;
  typedef core::endpoint_base endpoint_base;

  // Set a custom connection_base class
  typedef connection_data connection_base;
};

typedef websocketpp::server<custom_config> server;
typedef server::connection_ptr connection_ptr;

using websocketpp::connection_hdl;
using websocketpp::lib::placeholders::_1;
using websocketpp::lib::placeholders::_2;
using websocketpp::lib::bind;

enum action_type {
    SUBSCRIBE,
    UNSUBSCRIBE,
    MESSAGE
};

struct action {
    action(action_type t, connection_hdl h) : type(t), hdl(h) {}
    action(action_type t, connection_hdl h, server::message_ptr m): type(t), hdl(h), msg(m) {}

    action_type type;
    websocketpp::connection_hdl hdl;
    server::message_ptr msg;
};

class broadcast_server {
  bool win_claimed = false;
public:
  broadcast_server() {
    // Initialize Asio Transport
    m_server.init_asio();

    // Register handler callbacks
    m_server.set_open_handler(bind(&broadcast_server::on_open,this,::_1));
    m_server.set_close_handler(bind(&broadcast_server::on_close,this,::_1));
    m_server.set_message_handler(bind(&broadcast_server::on_message,this,::_1,::_2));
  }

  void on_open(connection_hdl hdl) {
    {
      lock_guard<mutex> guard(m_action_lock);
      m_actions.push(action(SUBSCRIBE, hdl));
    }
    m_action_cond.notify_one();
  }

  void on_close(connection_hdl hdl) {
    {
      lock_guard<mutex> guard(m_action_lock);
      m_actions.push(action(UNSUBSCRIBE, hdl));
    }
    m_action_cond.notify_one();
  }

  void on_message(connection_hdl hdl, server::message_ptr msg) {
    // queue message up for sending by processing thread
    {
      lock_guard<mutex> guard(m_action_lock);
      m_actions.push(action(MESSAGE, hdl, msg));
    }
    m_action_cond.notify_one();
  }

  void process_messages() {

    sqlite3* db;
    if (!open_database(&db)) {
      printf("Database connection error\n");
      return;
    }

    while(1) {
      unique_lock<mutex> lock(m_action_lock);

      while(m_actions.empty()) {
        m_action_cond.wait(lock);
      }

      action a = m_actions.front();
      m_actions.pop();

      lock.unlock();

      lock_guard<mutex> guard(m_connection_lock);

      // get user uuid
      std::string user_uuid = m_server.get_con_from_hdl(a.hdl)->name;
      // get opened room id
      std::string room_id = find_opened_room(db);

      switch (a.type) {
        case SUBSCRIBE:
          m_connections.insert(a.hdl);
          m_server.send(a.hdl, "Hi. I'm Chippy. Who are you?", websocketpp::frame::opcode::text);
          break;
        case UNSUBSCRIBE:
          // leave from room
          m_connections.erase(a.hdl);
          leave_from_room(db, user_uuid, room_id);
          break;
        case MESSAGE:
          process_message(a.hdl, a.msg, db);
          break;
        default:
          break;
      }
    }

    close_database(db);
  }

  bool send_to(connection_hdl hdl, std::string content) {
    try {
      m_server.send(hdl, content, websocketpp::frame::opcode::text);
      return true;
    } catch (websocketpp::exception const & e) {
      std::cout << "Echo failed because: " << "(" << e.what() << ")" << std::endl;
      return false;
    }
  }

  void broadcast_message(std::string content) {
    con_list::iterator it;
    for (it = m_connections.begin(); it != m_connections.end(); ++it) {
      send_to(*it, content);
    }
  }

  std::string parse_jwt(std::string jwt_str) {
    const char* env_jwt_secret = std::getenv("JWT_SECRET");
    auto verifier = jwt::verify().allow_algorithm(jwt::algorithm::hs256{ env_jwt_secret });

    auto decoded_token = jwt::decode(jwt_str);

    verifier.verify(decoded_token);

    for (auto& e : decoded_token.get_payload_claims()) {
      if (e.first == "userId") {
        return e.second.as_string();
      }
    }

    return "";
  }

  std::string generate_broadcast_message(const char* what, std::string user_uuid, std::string user_name, int chip_status) {
    char buf[MAXIMUM_FRAGMENT_LENGTH];
    snprintf(buf, MAXIMUM_FRAGMENT_LENGTH, "%s|%s|%s|%d", what, user_uuid.c_str(), user_name.c_str(), chip_status);
    std::string broadcast_response(buf);
    return broadcast_response;
  }

  void process_message(connection_hdl hdl, server::message_ptr msg, sqlite3* db) {
    connection_ptr con = m_server.get_con_from_hdl(hdl);

    if (con->name.empty()) {

      try {
        std::string decoded_userid = parse_jwt(msg->get_payload());

        if (decoded_userid != "") {
          con->name = decoded_userid;
          std::cout << "Setting name of connection with sessionid "
                    << con->sessionid << " to " << con->name << std::endl;

          std::string response = "Nice to meet you " + con->name + "!";
          send_to(hdl, response);
        } else {
          throw std::exception();
        }

      } catch (const std::exception & e) {
        std::cout << e.what() << std::endl;
        std::string response = "Invalid authentication info ...";
        send_to(hdl, response);
      }

    } else {
      std::cout << "Got a message from connection " << con->name
          << " with sessionid " << con->sessionid << std::endl;

      std::string content = msg->get_payload();

      // ignore too long messages
      if (content.length() > MAXIMUM_MESSAGE_LENGTH) {
        std::cout << "Message \"" << content << "\" is too long to process." << std::endl;
        return;
      }

      if (content.length() == 0) {
        return;
      }

      // parse message from websocket content
      chippy_message message = parse_message(content);

      // valid parsed message must have command part
      if (message.command && !message.command[0]) {
        send_to(hdl, "Invalid message format.");
        return;
      }

      // convert it to lowercase
      char lowercased_command[32];
      char payload[32];
      convert_to_lowercase(message.command, lowercased_command);
      strncpy(payload, message.payload, 32);

      // get user uuid
      std::string user_uuid = con->name;
      // get opened room id
      std::string room_id = find_opened_room(db);

      // query my chip status
      chip_status my_chip_status = get_chip_status(db, user_uuid, room_id);
      // which means invalid status
      bool belongs_to_room = my_chip_status.value != -1;

      if (strncmp(lowercased_command, "join", 4) == 0) {

        // which means invalid status
        if (belongs_to_room == false) {
          join_to_room(db, user_uuid, room_id);
          add_chip(db, user_uuid, room_id, INITIAL_CHIP_VALUE);
        }

        // Send every user info joined
        std::vector<chip_status> every_chip_statuses = get_chip_statuses(db, room_id);
        for (auto & status : every_chip_statuses) {
          broadcast_message(generate_broadcast_message("joined", status.user_uuid, status.user_name, status.value));
        }

      } else if (strncmp(lowercased_command, "deposit", 7) == 0) {

        if (belongs_to_room == false) {
          send_to(hdl, "Please join room first.");
          return;
        }

        if (win_claimed == true) {
          send_to(hdl, "No deposit allowed while win is claimed.");
          return;
        }

        // query my chip status
        chip_status my_chip_status = get_chip_status(db, user_uuid, room_id);
        int value_to_deposit = atoi(payload);

        if (value_to_deposit <= 0) {
          send_to(hdl, "Invalid value for deposit.");
          return;
        }

        if (my_chip_status.value < value_to_deposit) {
          send_to(hdl, "Your chip value is to small to deposit something!");
        } else {
          // remove and add chip value to room
          remove_chip(db, user_uuid, room_id, value_to_deposit);
          add_chip_to_room(db, room_id, value_to_deposit);
          // query my chip status
          chip_status my_new_chip_status = get_chip_status(db, user_uuid, room_id);
          broadcast_message(generate_broadcast_message("deposited", user_uuid, my_new_chip_status.user_name, my_new_chip_status.value));
        }

      } else if (strncmp(lowercased_command, "claimwin", 8) == 0) {

        if (belongs_to_room == false) {
          send_to(hdl, "Please join room first.");
          return;
        }

        value_to_claim[room_id] = get_chip_value_of_room(db, room_id);
        claimer[room_id] = user_uuid;

        // query my chip status
        chip_status my_chip_status = get_chip_status(db, user_uuid, room_id);
        broadcast_message(generate_broadcast_message("claimedwin", user_uuid, my_chip_status.user_name, my_chip_status.value));

        win_claimed = true;

      } else if (strncmp(lowercased_command, "approvewin", 10) == 0) {

        if (belongs_to_room == false) {
          send_to(hdl, "Please join room first.");
          return;
        }

        auto claim_i = value_to_claim.find(room_id);
        auto claim_who = claimer.find(room_id);

        if (claim_i == value_to_claim.end() || claim_who == claimer.end()) {
          send_to(hdl, "Please call claim first.");
        } else {

          std::string _claimer = claim_who->second;
          int _claim_value = claim_i->second;

          if (_claimer == user_uuid) {
            send_to(hdl, "Claimer can't approve one's claim!");
          } else {
            // remove and add chip value to room
            add_chip(db, _claimer, room_id, _claim_value);
            add_chip_to_room(db, room_id, _claim_value * -1);

            // remove from map
            value_to_claim.erase(room_id);
            claimer.erase(room_id);

            // Send every user info (after claiming chips)
            std::vector<chip_status> every_chip_statuses = get_chip_statuses(db, room_id);
            for (auto & status : every_chip_statuses) {
              broadcast_message(generate_broadcast_message("approvedwin", status.user_uuid, status.user_name, status.value));
            }

            win_claimed = false;
          }
        }

      } else {
        char response_b[MAXIMUM_FRAGMENT_LENGTH];
        snprintf(response_b, MAXIMUM_FRAGMENT_LENGTH, "%s", message.payload);

        std::string response(response_b);
        send_to(hdl, response);

        std::string broadcast_response = "They said " + content;
        broadcast_message(broadcast_response);
      }
    }
  }

  void convert_to_lowercase(const char* input_str, char* output_str) {
    strncpy(output_str, input_str, MAXIMUM_MESSAGE_LENGTH);
    for (unsigned int i = 0; i < strlen(output_str); i++) {
      output_str[i] = tolower(output_str[i]);
    }
  }

  int split_string(char* input_str, const char* delim, char pToken[TOKENS_LENGTH][MAXIMUM_FRAGMENT_LENGTH]) {
    int i = 0;
    char* pos = strtok(input_str, delim);

    strncpy(pToken[i++], pos, MAXIMUM_FRAGMENT_LENGTH);

    while ((pos = strtok(NULL, delim)) != NULL) {
      if (i > TOKENS_LENGTH) return i;
      strncpy(pToken[i++], pos, MAXIMUM_FRAGMENT_LENGTH);
    }
    return i;
  }

  chippy_message parse_message(std::string message) {
    const char* delim = "|";

    // valid message format must have delimiter count of TOKENS_LENGTH - 1 or zero
    int delimiterCount = std::count(message.begin(), message.end(), delim[0]);
    if (delimiterCount > TOKENS_LENGTH - 1) {
      chippy_message empty_message = { .command = "", .payload = "" };
      return empty_message;
    }

    char ibuf[MAXIMUM_MESSAGE_LENGTH];
    char obuf[TOKENS_LENGTH][MAXIMUM_FRAGMENT_LENGTH];
    strncpy(ibuf, message.c_str(), MAXIMUM_MESSAGE_LENGTH);

    split_string(ibuf, delim, obuf);

    chippy_message parsed_message = {
      .command = obuf[0],
      .payload = delimiterCount == 0 ? (char*)"" : obuf[1],
    };

    return parsed_message;
  }

  void run(uint16_t port) {
    try {
      // listen on specified port
      m_server.listen(port);

      // Start the server accept loop
      m_server.start_accept();

      // Start the ASIO io_service run loop
      m_server.run();

    } catch (const std::exception & e) {
      std::cout << e.what() << std::endl;
    }
  }
private:
  typedef std::set<connection_hdl,std::owner_less<connection_hdl> > con_list;

  server m_server;
  con_list m_connections;
  std::queue<action> m_actions;
  std::unordered_map<std::string, int> value_to_claim;
  std::unordered_map<std::string, std::string> claimer;

  mutex m_action_lock;
  mutex m_connection_lock;
  condition_variable m_action_cond;
};

int main() {
  try {
    broadcast_server server;

    // Start a thread to run the processing loop
    thread server_thread(bind(&broadcast_server::process_messages,&server));

    // Run the asio loop with the main thread
    server.run(9002);

    server_thread.join();
    return 0;

  } catch (websocketpp::exception const & e) {
    std::cout << e.what() << std::endl;
    return 1;
  }
}

// Function format
int exploit(){
	printf("[Team 4] Dummy Function for PoC\n");
}
