# Chippy-server (WebSocket Server)

## Build

### Requirements

- Clone all submodules
  ```shell
  git clone --recursive [[repo-url]]
  ```
- Boost
- Sqlite3
- OpenSSL
- websocketpp (in submodule)

```shell
sudo apt install -y libboost-dev libsqlite3-dev libssl-dev
```

### How to build and run

- The server uses JWT secret from environment variable (`JWT_SECRET`), which MUST be same with Node server's.

```shell
make
# path of the database file
export DB_CONNECTION_STRING="./node/db.sqlite3"
export JWT_SECRET=super-secret-key
./bin/chippy_server
```
