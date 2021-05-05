import { INTEGER, Sequelize, UUID, UUIDV4 } from "sequelize";

export const Room = function (sequelize: Sequelize) {
  return sequelize.define("rooms", {
    id: {
      type: UUID,
      defaultValue: UUIDV4,
      primaryKey: true,
    },
    turn: {
      type: INTEGER,
    },
  });
};

export default Room;
