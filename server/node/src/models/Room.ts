import { INTEGER, Model, Sequelize, UUID, UUIDV4 } from "sequelize";
import { User } from "./User";

export class Room extends Model {
  id!: string;
  // 'pot' chip value of the room
  potValue!: number;
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
      potValue: {
        type: INTEGER,
      },
    },
    { sequelize, modelName: "rooms", timestamps: false }
  );

  // Host
  User.hasOne(Room, { foreignKey: "host" });
  return room;
};

export default initRoom;
