#include <iostream>
#include <set>
#include <websocketpp/config/asio_no_tls.hpp>
#include <websocketpp/server.hpp>

using namespace std;

/**
 * The source code is loosely based on https://github.com/zaphoyd/websocketpp/blob/master/examples/broadcast_server/broadcast_server.cpp
 */

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
    while(1) {
      unique_lock<mutex> lock(m_action_lock);

      while(m_actions.empty()) {
        m_action_cond.wait(lock);
      }

      action a = m_actions.front();
      m_actions.pop();

      lock.unlock();

      lock_guard<mutex> guard(m_connection_lock);

      switch (a.type) {
        case SUBSCRIBE:
          m_connections.insert(a.hdl);
          m_server.send(a.hdl, "Hi. I'm Chippy. Who are you?", websocketpp::frame::opcode::text);
          break;
        case UNSUBSCRIBE:
          m_connections.erase(a.hdl);
          break;
        case MESSAGE:
          process_message(a.hdl, a.msg);
          break;
        default:
          break;
      }
    }
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

  void process_message(connection_hdl hdl, server::message_ptr msg) {
    connection_ptr con = m_server.get_con_from_hdl(hdl);
    if (con->name.empty()) {
      con->name = msg->get_payload();
      std::cout << "Setting name of connection with sessionid "
                << con->sessionid << " to " << con->name << std::endl;

      std::string response = "Nice to meet you " + msg->get_payload() + "!";
      send_to(hdl, response);

    } else {
      std::cout << "Got a message from connection " << con->name
          << " with sessionid " << con->sessionid << std::endl;

      std::string response = "You said " + msg->get_payload();
      send_to(hdl, response);

      std::string broadcast_response = "They said " + msg->get_payload();
      broadcast_message(broadcast_response);
    }
  }

  void run(uint16_t port) {
    // listen on specified port
    m_server.listen(port);

    // Start the server accept loop
    m_server.start_accept();

    // Start the ASIO io_service run loop
    try {
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

  } catch (websocketpp::exception const & e) {
    std::cout << e.what() << std::endl;
  }
}
