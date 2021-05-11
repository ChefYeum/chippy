# Alternative client
This document shows an alternative ways of interacting with the backend. 

## Requirements
- Web browser
- WebSocket server to be running on `ws://localhost:9002` (Follow `server/node/README.md`)
- Node server to be running on `http://localhost:8081` (Follow `server/cpp/README.md`)

## Authentication with Node server
To access all endpoints:
1. Go to [hoppscotch.io](https://hoppscotch.io) on a browser of your choice
2. Go to: **Home > Collections > Import/Export > Import from JSON**
3. Select `chippyEndpoints.json` in this directory
4. Notice all endpoints added under **Collections**

Now to Sign Up:
1. Under **Colletions**, select **Chippy > POST Sign Up**
2. Under **Request Body**, add `id`, `name`, and `password` by replacing the default value
3. Click on Send button
4. Notice a response body containing `token`.

This token is then used to authenticate to the WebSocket.

Signed up user information can be used to request **POST Login** endpoint to obtain the token as an alternative.

## In-game interaction with WebSocket server
1. Go to [hoppscotch.io/realtime](https://hoppscotch.io/realtime)
2. At URL, insert `ws://localhost:9002`
3. Click on Connect button
4. Notice receiving "Hi. I'm Chippy. Who are you?" from the server. Send the token received from above to authenticate.
5. Notice receiving "Nice to meet you" followed by your UUID. Send "join" to join the game

Once successfully authenticated, you will receive messages to indicate who is already in the game. These messages are in the following format:
```
joined|{User UUID}|{User display name}|{User chip count}
```

Then to deposit chips into the pot, send a message of the following format:
```
deposit|{Amount of chip to call}
```

After a series of deposits from users, the winning player may claim the pot by sending a following message:
```
claimWin
```

This is then must be approved by other players by sending the following Message:
```
approveWin
```