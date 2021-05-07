import jwt from "jsonwebtoken";
import { getEnv } from "./env";
import { User } from "models/User";

export const JWT_SECRET = getEnv("JWT_SECRET", true) ?? "";

const generateToken = async (user: User) => {
  return jwt.sign({ userId: user.uuid }, JWT_SECRET);
};

export default generateToken;
