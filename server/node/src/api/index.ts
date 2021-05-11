import { Router } from "express";
import main from "./root";
import { login, logout, createUser } from "./user";
import cors from "cors";

export interface APIResponse<T extends any> {
  success: boolean;
  data?: T;
}

export default function router() {
  const r = Router();
  r.use(cors({ origin: '*'}))
  r.get("/", main);

  r.post("/user/login", login);
  r.get("/user/logout", logout);
  r.post("/user", createUser);

  return r;
}
