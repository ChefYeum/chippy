enum SignalType {
  JOINED,
  DEPOSITED,
  CLAIMED_WIN,
}

class WebSocketSignal {
  SignalType signalType;
  Map<String, String> props = {};

  WebSocketSignal(String signal) {
    var parts = signal.split('|');
    switch (parts[0]) {
      case "joined":
        signalType = SignalType.JOINED;
        props.addAll({
          "uuid": parts[1],
          "displayedName": parts[2],
          "playerChipCount": parts[3]
        });
        break;
      case "deposited":
        signalType = SignalType.DEPOSITED;
        props.addAll({"uuid": parts[1], "chipCount": parts[2]});
        break;
      default:
    }
  }
}
