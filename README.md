# Chippy
Multiplatform Poker Chip Simulator

## Features
### Login and Register
- Straightforward and (Conceptually) secure authentication to access the game. 
- Registration requires: username, ID, and password.

### Poker rule
- There is no specific betting rules built into the game.
- Players are expected to be playing poker offline, with an agreed betting rule.
- As a result, it can support any form of pokers listed below.

#### Supported Poker Rules 
Including, but not limited to:
- Texas Hold'em (all variants)
- Omaha Hold'em
- 7-Card Stud
- ... 

### In-game
- Each player is given 9000 chips to start.
- All players are able to bet by sliding chips into the pot.
- When a player wins, they can claim the pot. This is then approved by other players in the game
- When approved, the player obtains the chips in the pot and the round restarts.

# How to Setup
## Client `app/`
For an alternative client, see [alt-client/ALT-CLIENT.md](./alt-client/ALT-CLIENT.md).

The client follows the standard format of flutter project. Go to [Flutter - Get Started - Install](https://flutter.dev/docs/get-started/install), select the relevant operating system you'd like to run it on, and then follow the instruction 

## Server `server/`
The applicaiton requires two servers to be running simultaneously. Please follow the relevant README in `server/cpp/` and `server/node`.
