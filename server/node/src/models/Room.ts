import { INTEGER, Model, Sequelize, UUID, UUIDV4 } from "sequelize";

export class Room extends Model {
  id!: string;
  turn!: number;
}

export const initRoom = function (sequelize: Sequelize) {
  return Room.init(
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
};

export default Room;
