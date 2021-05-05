import { INTEGER, Model, Sequelize, STRING, UUID, UUIDV4 } from "sequelize";

export class User extends Model {
  id!: string;
  name!: string;
  password!: string;
}

export const initUser = function (sequelize: Sequelize) {
  return User.init(
    {
      id: {
        type: UUID,
        defaultValue: UUIDV4,
        primaryKey: true,
      },
      password: {
        type: STRING,
      },
      name: {
        type: STRING,
      },
    },
    { sequelize, modelName: "users" }
  );
};

export default User;
