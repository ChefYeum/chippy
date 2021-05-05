import jwt from "jsonwebtoken";
import { User } from "models";
import { getEnv } from "./env";

export const ADMIN_TOKEN = getEnv("ADMIN_TOKEN", true) ?? "";
export const JWT_SECRET = getEnv("JWT_SECRET", true) ?? "";

const generateToken = async (user: User) => {
  return jwt.sign({ userId: user.id }, JWT_SECRET);
};

export default generateToken;
