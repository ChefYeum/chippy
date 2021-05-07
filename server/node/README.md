# Chippy-server (Node Server)

## Build

### Requirements

```shell
npm install
```

### How to build and run

- The server uses JWT secret from environment variable (`JWT_SECRET`), which MUST be same with WebSocket server's.

```shell
export JWT_SECRET=super-secret-key
npm start
```
