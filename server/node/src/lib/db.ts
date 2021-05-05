import { Sequelize } from "sequelize";

const initConnection = async () => {
  const sequelize = new Sequelize("sqlite::memory:");
  return sequelize;
};

export default initConnection;
