import Express from "express";
import initConnection from "./lib/db";
import router from "./api";

import * as models from "./models";

const port = process.env.PORT ?? 8081;

async function run() {
  const app = Express();
  app.use(Express.json());
  app.use(Express.urlencoded({ extended: true }));
  app.use("/", router());

  const sequelize = await initConnection();

  for (const initModel of Object.values(models)) {
    await initModel(sequelize);
  }
  await sequelize.sync({ force: true });

  app.listen(port, () =>
    console.log(`Chippy server is listening at port ${port}`)
  );
}

run();
