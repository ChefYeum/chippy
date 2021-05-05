export const getEnv = function (
  key: string,
  required: boolean = false
): string | undefined {
  const data = process.env[key];
  if (!data && required) {
    throw new Error(`${key} is mandatory environment variable`);
  } else {
    return data;
  }
};
