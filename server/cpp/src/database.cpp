#include "database.hpp"

bool open_database(sqlite3** db) {
  const char* env_db_connection_str = std::getenv("DB_CONNECTION_STRING");

  int rc = sqlite3_open(env_db_connection_str, db);
  if(rc != SQLITE_OK) {
    printf("%s\n", sqlite3_errmsg(*db));
    sqlite3_close(*db);
    return false;
  }

  return true;
}

bool close_database(sqlite3* db) {
  return sqlite3_close(db) == SQLITE_OK;
}

std::string find_opened_room(sqlite3 *db) {

  std::string result = "";
  sqlite3_stmt* statement;

  sqlite3_prepare_v2(db, FIND_ROOM_QUERY.c_str(), -1, &statement, NULL);

  while(sqlite3_step(statement) == SQLITE_ROW) {
    int type = sqlite3_column_type(statement, 0);
    if (type != SQLITE_TEXT) {
      continue;
    }
    result = std::string(reinterpret_cast<const char*>(sqlite3_column_text(statement, 0)));
    // limit 1
    break;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return result;
}

chip_status get_chip_status(sqlite3 *db, std::string user_uuid, std::string room_id) {

  sqlite3_stmt* statement;
  chip_status status = {
    .user_uuid = user_uuid,
    .user_name = std::string(""),
    .value = -1,
  };

  sqlite3_prepare_v2(db, GET_ONE_CHIP_STATUS_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_text(statement, 1, user_uuid.c_str(), -1, SQLITE_STATIC);
  sqlite3_bind_text(statement, 2, room_id.c_str(), -1, SQLITE_STATIC);

  while(sqlite3_step(statement) == SQLITE_ROW) {

    status.user_name = std::string((char*)sqlite3_column_text(statement, 0));
    status.value = (int)sqlite3_column_int(statement, 1);
    // limit 1
    break;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return status;
}

bool join_to_room(sqlite3 *db, std::string user_uuid, std::string room_id) {

  bool result = true;
  sqlite3_stmt* statement;
  sqlite3_prepare_v2(db, JOIN_ROOM_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_text(statement, 1, user_uuid.c_str(), -1, SQLITE_STATIC);
  sqlite3_bind_text(statement, 2, room_id.c_str(), -1, SQLITE_STATIC);

  if (sqlite3_step(statement) != SQLITE_DONE) {
    printf("line %d: %s\n", __LINE__, sqlite3_errmsg(db));
    result = false;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);
}

bool leave_from_room(sqlite3 *db, std::string user_uuid, std::string room_id) {

  bool result = true;
  sqlite3_stmt* statement;
  sqlite3_prepare_v2(db, LEAVE_ROOM_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_text(statement, 1, user_uuid.c_str(), -1, SQLITE_STATIC);
  sqlite3_bind_text(statement, 2, room_id.c_str(), -1, SQLITE_STATIC);

  if (sqlite3_step(statement) != SQLITE_DONE) {
    printf("line %d: %s\n", __LINE__, sqlite3_errmsg(db));
    result = false;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);
}

bool close_my_room(sqlite3 *db, std::string user_uuid) {

  bool result = true;
  return result;

}

bool add_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value) {

  bool result = true;
  sqlite3_stmt* statement;
  sqlite3_prepare_v2(db, ADD_CHIP_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_int(statement, 1, value);
  sqlite3_bind_text(statement, 2, user_uuid.c_str(), -1, SQLITE_STATIC);
  sqlite3_bind_text(statement, 3, room_id.c_str(), -1, SQLITE_STATIC);

  if (sqlite3_step(statement) != SQLITE_DONE) {
    printf("line %d: %s\n", __LINE__, sqlite3_errmsg(db));
    result = false;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return result;
}

bool remove_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value) {

  bool result = true;
  sqlite3_stmt* statement;
  sqlite3_prepare_v2(db, REMOVE_CHIP_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_int(statement, 1, value);
  sqlite3_bind_text(statement, 2, user_uuid.c_str(), -1, SQLITE_STATIC);
  sqlite3_bind_text(statement, 3, room_id.c_str(), -1, SQLITE_STATIC);

  if (sqlite3_step(statement) != SQLITE_DONE) {
    printf("line %d: %s\n", __LINE__, sqlite3_errmsg(db));
    result = false;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return result;
}

bool add_chip_to_room(sqlite3 *db, std::string room_id, int value) {

  bool result = true;
  sqlite3_stmt* statement;
  sqlite3_prepare_v2(db, ADD_CHIP_TO_ROOM_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_int(statement, 1, value);
  sqlite3_bind_text(statement, 2, room_id.c_str(), -1, SQLITE_STATIC);

  if (sqlite3_step(statement) != SQLITE_DONE) {
    printf("line %d: %s\n", __LINE__, sqlite3_errmsg(db));
    result = false;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return result;
}

int get_chip_value_of_room(sqlite3 *db, std::string room_id) {

  int result = 0;
  sqlite3_stmt* statement;

  sqlite3_prepare_v2(db, GET_CHIP_VALUE_OF_ROOM_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_text(statement, 1, room_id.c_str(), -1, SQLITE_STATIC);

  while(sqlite3_step(statement) == SQLITE_ROW) {
    result = sqlite3_column_int(statement, 0);
    // limit 1
    break;
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return result;
}

std::vector<chip_status> get_chip_statuses(sqlite3 *db, std::string room_id) {

  std::vector<chip_status> statuses;
  sqlite3_stmt* statement;

  sqlite3_prepare_v2(db, GET_CHIP_STATUS_QUERY.c_str(), -1, &statement, NULL);
  sqlite3_bind_text(statement, 1, room_id.c_str(), -1, SQLITE_STATIC);

  while(sqlite3_step(statement) == SQLITE_ROW) {

    chip_status status = {
      .user_uuid = std::string((char*)sqlite3_column_text(statement, 0)),
      .user_name = std::string((char*)sqlite3_column_text(statement, 1)),
      .value = (int)sqlite3_column_int(statement, 2),
    };

    statuses.push_back(status);
  }

  sqlite3_reset(statement);
  sqlite3_finalize(statement);

  return statuses;
}
