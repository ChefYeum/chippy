# Chippy-server (Node Server)

The authentication part of Chippy server is made with Node.js and TypeScript.

## How to build and run

### 1-1. Installing Node.js

The Node.js must be installed before installing other dependencies and running the server.

The version of Node.js we used for development is 15(`15.5.1`). The server code should be independent to the node version.

We used [nvm](https://github.com/nvm-sh/nvm) for installing Node.js. Alternatively, using `apt` can install Node.js, however, the version of Node.js is different from what we've used.

After installing nvm using the link above, we can invoke nvm's command to install Node version 15.

```shell
nvm install 15
nvm use 15
```

### 1-2. Installing dependencies

Other dependencies can be installed with npm command.

```shell
npm install
```

The server uses [`ts-node`](https://github.com/TypeStrong/ts-node) runtime in order to run TypeScript code without any code conversion. The `npx` command should invoke relative command, however, you can explicitly install `ts-node` runtime as shown.

```shell
npm install -g ts-node
```

### 1-3. Required environment variables

- The server uses JWT secret from environment variable (`JWT_SECRET`), which MUST be same with WebSocket server's.

```shell
export JWT_SECRET=super-secret-key
npm start
```
