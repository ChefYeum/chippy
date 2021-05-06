import { INTEGER, Model, Sequelize, UUID, UUIDV4 } from "sequelize";
import { User } from "./User";

export class Room extends Model {
  id!: string;
  turn!: number;
}

export const initRoom = function (sequelize: Sequelize) {
  const room = Room.init(
    {
      id: {
        type: UUID,
        defaultValue: UUIDV4,
        primaryKey: true,
      },
      turn: {
        type: INTEGER,
      },
    },
    { sequelize, modelName: "rooms" }
  );

  // Host
  Room.hasOne(User);
  return room;
};

export default initRoom;
