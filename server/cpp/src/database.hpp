#ifndef __DATABASE
#define __DATABASE

#include <sqlite3.h>
#include <string>
#include <vector>

typedef struct {
  std::string user_name;
  int value;
} chip_status;

// Open and close database instance
bool open_database(sqlite3 *db);
bool close_database(sqlite3 *db);

// Find room_id of currently opened room
const std::string FIND_ROOM_QUERY = "SELECT `id` FROM `rooms` LIMIT 1;";
std::string find_opened_room(sqlite3 *db);

// Make a new room, and assign myself to the host
const std::string CREATE_ROOM_QUERY = "INSERT INTO `rooms`(`host`, `turn`) VALUES(?, 1);";
bool create_new_room(sqlite3 *db, std::string user_uuid);

// Join to the room currently opened
const std::string JOIN_ROOM_QUERY = "INSERT INTO `chipstatuses`(`userUuid`, `roomId`) VALUES(?, ?);";
bool join_to_room(sqlite3 *db, std::string user_uuid, std::string room_id);

// Close and delete the room, if user is host of any room
const std::string CLOSE_ROOM_QUERY = "DELETE FROM `rooms` WHERE `host` = ?;";
bool close_my_room(sqlite3 *db, std::string user_uuid);

// Add or remove chip value of the room
const std::string ADD_CHIP_QUERY = "UPDATE `chipstatuses` SET `value` = `value` + ? WHERE `userUuid` = ? AND `roomId` = ?";
const std::string REMOVE_CHIP_QUERY = "UPDATE `chipstatuses` SET `value` = `value` - ? WHERE `userUuid` = ? AND `roomId` = ?";
bool add_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value);

bool remove_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value);

// Get chip statuses of the room
const std::string GET_CHIP_STATUS_QUERY = "SELECT `userUuid`, `users`.`name` FROM `chipstatuses` JOIN `users` ON `users`.`uuid` = `chipstatuses`.`userUuid` WHERE `chipstatuses`.`roomId` = ?";
std::vector<chip_status> get_chip_statuses(sqlite3 *db, std::string room_id);

#endif
