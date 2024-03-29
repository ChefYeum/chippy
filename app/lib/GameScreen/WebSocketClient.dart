class WebSocketClient {
  final channel, myToken;
  var stream;
  WebSocketClient(this.channel, this.myToken) {
    this.stream = channel.stream;
  }

  void send(String msg) {
    channel.sink.add(msg);
  }

  void dispose() {
    channel.sink.close();
  }

  void join() {
    send('$myToken');
    send('join');
  }
}
