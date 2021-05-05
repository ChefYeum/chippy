import { INTEGER, Model, Sequelize, STRING, UUID, UUIDV4 } from "sequelize";

export class User extends Model {
  uuid!: string;
  id!: string;
  name!: string;
  password!: string;
}

export const initUser = function (sequelize: Sequelize) {
  return User.init(
    {
      uuid: {
        type: UUID,
        defaultValue: UUIDV4,
        primaryKey: true,
      },
      id: {
        type: STRING,
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

export default initUser;
