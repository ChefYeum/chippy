import crypto from "crypto";

const hash = async (data: string): Promise<string> => {
  return new Promise((resolve, reject) =>
    crypto.pbkdf2(
      data,
      data.split("").reverse().join(""),
      10000,
      64,
      "sha512",
      function (err, x) {
        if (err) return reject(err);
        resolve(x.toString("hex"));
      }
    )
  );
};

export default hash;
