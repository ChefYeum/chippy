import { INTEGER, Model, Sequelize, UUID, UUIDV4 } from "sequelize";
import { User } from "./User";

export class Room extends Model {
  id!: string;
  turn!: number;
  // host of the room(user id)
  host!: string;
}

export const initRoom = async function (sequelize: Sequelize) {
  const room = await Room.init(
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
    { sequelize, modelName: "rooms", timestamps: false }
  );

  // Host
  User.hasOne(Room, { foreignKey: "id", as: "host" });
  return room;
};

export default initRoom;
