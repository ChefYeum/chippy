import { Response, Router } from "express";
import main from "./root";
import { login, logout, createUser } from "./user";

export interface APIResponse<T extends any> {
  success: boolean;
  data?: T;
}

export default function router() {
  const router = Router();
  router.get("/", main);

  router.post("/user/login", login);
  router.get("/user/logout", logout);
  router.post("/user", createUser);

  return router;
}
