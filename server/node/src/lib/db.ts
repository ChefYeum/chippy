import { Sequelize } from "sequelize";

const initConnection = async () => {
  const sequelize = new Sequelize("sqlite:./db.sqlite3");
  return sequelize;
};

export default initConnection;
