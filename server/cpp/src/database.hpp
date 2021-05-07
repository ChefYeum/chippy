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
bool open_database(sqlite3** db);
bool close_database(sqlite3* db);

// Find room_id of currently opened room
const std::string FIND_ROOM_QUERY = "SELECT `id` FROM `rooms` LIMIT 1;";
std::string find_opened_room(sqlite3 *db);

const std::string GET_ONE_CHIP_STATUS_QUERY = "SELECT `users`.`name`, `chipstatuses`.`value` FROM `chipstatuses` JOIN `users` ON `users`.`uuid` = `chipstatuses`.`userUuid` WHERE `users`.`uuid` = ? AND  `chipstatuses`.`roomId` = ?;";
chip_status get_chip_status(sqlite3 *db, std::string user_uuid, std::string room_id);

// Join to the room currently opened
const std::string JOIN_ROOM_QUERY = "INSERT INTO `chipstatuses`(`userUuid`, `roomId`, `value`) VALUES(?, ?, 0);";
bool join_to_room(sqlite3 *db, std::string user_uuid, std::string room_id);

// Join to the room currently opened
const std::string LEAVE_ROOM_QUERY = "DELETE FROM `chipstatuses` WHERE `userUuid` = ? AND `roomId` = ?";
bool leave_from_room(sqlite3 *db, std::string user_uuid, std::string room_id);

// Close and delete the room, if user is host of any room
const std::string CLOSE_ROOM_QUERY = "DELETE FROM `rooms` WHERE `host` = ?;";
bool close_my_room(sqlite3 *db, std::string user_uuid);

// Add or remove chip value of the room
const std::string ADD_CHIP_QUERY = "UPDATE `chipstatuses` SET `value` = `value` + ? WHERE `userUuid` = ? AND `roomId` = ?";
const std::string REMOVE_CHIP_QUERY = "UPDATE `chipstatuses` SET `value` = `value` - ? WHERE `userUuid` = ? AND `roomId` = ?";
bool add_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value);

bool remove_chip(sqlite3 *db, std::string user_uuid, std::string room_id, int value);

// Add chip to 'pot' of the room
const std::string ADD_CHIP_TO_ROOM_QUERY = "UPDATE `rooms` SET `potValue` = `potValue` + ? WHERE `roomId` = ?";
bool add_chip_to_room(sqlite3 *db, std::string room_id, int value);

// Get value of the 'pot'
const std::string GET_CHIP_VALUE_OF_ROOM_QUERY = "SELECT `potValue` FROM `rooms` WHERE `roomId` = ?";
int get_chip_value_of_room(sqlite3 *db, std::string room_id);

// Get chip statuses of the room
const std::string GET_CHIP_STATUS_QUERY = "SELECT `users`.`name`, `chipstatuses`.`value` FROM `chipstatuses` JOIN `users` ON `users`.`uuid` = `chipstatuses`.`userUuid` WHERE `chipstatuses`.`roomId` = ?";
std::vector<chip_status> get_chip_statuses(sqlite3 *db, std::string room_id);

#endif
