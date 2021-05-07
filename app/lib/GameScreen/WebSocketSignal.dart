enum SignalType { JOINED }

class WebSocketSignal {
  SignalType signalType;
  Map<String, String> props;

  WebSocketSignal(String signal) {
    var parts = signal.split('|');
    switch (parts[0]) {
      case "joined":
        signalType = SignalType.JOINED;
        props.addAll({
          "uuid": parts[1],
          "displayedName": parts[2],
          "chipCount": parts[3]
        });
        break;
      // case "...":
      default:
    }
  }
}
