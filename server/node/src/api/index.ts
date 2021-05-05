import { Router } from "express";
import main from "./root";

export default function router() {
  const router = Router();
  router.get("/", main);

  return router;
}
