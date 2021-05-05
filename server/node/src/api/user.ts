import {
  APIResponse,
  checkAdminCredentials,
  WithAdminCredentials,
} from "./index";
import { RequestHandler } from "express";
import hash from "../lib/hasher";
import generateToken from "../lib/token";
import { User } from "../models/User";
import { Op } from "sequelize";

export const login: RequestHandler<
  {},
  APIResponse<{ uuid: string; token: string }>,
  { id: string; password: string }
> = async (req, res, next) => {
  try {
    if (!req.body.id || !req.body.password) {
      return res.status(400).json({ success: false });
    }

    const user = await User.findOne({
      where: {
        [Op.and]: [
          { id: req.body.id },
          { password: await hash(req.body.password) },
        ],
      },
    });

    if (user === null) {
      return res.status(404).json({ success: false });
    }

    return res.json({
      success: true,
      data: {
        token: await generateToken(user),
        uuid: user.uuid,
      },
    });
  } catch (err) {
    console.error(err);
    return res.sendStatus(500);
  }
};

export const logout: RequestHandler = async (req, res, next) => {
  res.send("logout");
  return next();
};

export const createUser: RequestHandler<
  {},
  APIResponse<{ uuid: string; token: string }>,
  { id: string; name: string; password: string }
> = async (req, res, next) => {
  try {
    if (!req.body.name || !req.body.id || !req.body.password) {
      return res.status(400).json({ success: false });
    }

    const user = await User.create({
      id: req.body.id,
      name: req.body.name,
      password: hash(req.body.password),
    });

    return res.json({
      success: true,
      data: {
        token: await generateToken(user),
        uuid: user.uuid,
      },
    });
  } catch (err) {
    console.error(err);
    return res.sendStatus(500);
  }
};
