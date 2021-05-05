import { Response, Router } from "express";
import { ADMIN_TOKEN } from "../lib/token";
import main from "./root";
import { login, logout, createUser } from "./user";

export interface APIResponse<T extends any> {
  success: boolean;
  data?: T;
}

export interface WithAdminCredentials {
  token?: string;
}

export const checkAdminCredentials = function checkAdminCredentials(
  body: WithAdminCredentials,
  res: Response
) {
  if (body.token !== ADMIN_TOKEN) {
    res.sendStatus(401);
    return false;
  } else {
    return true;
  }
};

export default function router() {
  const router = Router();
  router.get("/", main);

  router.get("/user/login", login);
  router.get("/user/logout", logout);
  router.post("/user", createUser);

  return router;
}
