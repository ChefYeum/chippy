import { RequestHandler } from "express";

export const main: RequestHandler = (req, res, next) => {
  res.send("test");
  return next();
};

export default main;
