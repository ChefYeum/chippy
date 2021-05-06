import { Model, NUMBER, Sequelize } from "sequelize";
import { Room } from "./Room";
import { User } from "./User";

export class ChipStatus extends Model {
  value!: number;
}

export const initChipStatus = async function (sequelize: Sequelize) {
  const chipStatus = await ChipStatus.init(
    {
      value: {
        type: NUMBER,
      },
    },
    { sequelize, modelName: "chipstatus" }
  );
  Room.belongsToMany(User, { through: "chipstatus" });
  User.belongsToMany(Room, { through: "chipstatus" });
  return chipStatus;
};

export default initChipStatus;
