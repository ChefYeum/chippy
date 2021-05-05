import { INTEGER, Sequelize, UUID, UUIDV4 } from "sequelize";

export const User = function (sequelize: Sequelize) {
  return sequelize.define("users", {
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

export default User;
