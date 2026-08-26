class AiChatAppSession {
  bool _hasOpenedChat = false;

  /// Returns `true` only for the first AI chat bloc created in this app
  /// process. The value naturally resets after the app process is terminated.
  bool takeShouldStartFresh() {
    final shouldStartFresh = !_hasOpenedChat;
    _hasOpenedChat = true;
    return shouldStartFresh;
  }
}
