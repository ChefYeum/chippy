# Chippy-server (WebSocket Server)

The game play part of Chippy server is made with C++(using ebsocketpp).

## How to build and run

### 1-1. Cloning the repository properly

C++ part of the repository consists of two submodules. The submodule must be cloned and initialized to compile the program.

```shell
git clone --recursive [[repo-url]]
```

If you accidently clone the program without `--recursive` option, you can init the submodule later.

```shell
git submodule sync
git submodule update --init --recursive --remote
```

### 1-2. Build Requirements

These are build requirements (both headers and libraries) for building the program.

- Boost
- Sqlite3
- OpenSSL
- websocketpp (in submodule)
- jwt-cpp (in submodule)

```shell
sudo apt install -y libboost-dev libsqlite3-dev libssl-dev
```

### 1-3. Required environment variables to run the program

- The server uses JWT secret from environment variable (`JWT_SECRET`), which MUST be same with Node server's.

- Moreover, the SQLite database path (`DB_CONNECTION_STRING`) must be provided. The database path (which is a file path) should be the one which is initialized with Node server.
  - The file path should be absolute.
  - Because of this, before running WebSocket part of the program, the Node part of the server should be initialized firstly.

```shell
make
# path of the database file
export DB_CONNECTION_STRING="/path/to/repository/server/node/db.sqlite3"
export JWT_SECRET=super-secret-key
./bin/chippy_server
```
