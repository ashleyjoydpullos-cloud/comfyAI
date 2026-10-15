/// Prototype only: returns canned replies. A real REST API comes later.
class MockChatService {
  static const _replies = [
    "I'm here with you. Take your time, what's on your mind? 💜",
    "That sounds really heavy. Thank you for trusting me with it.",
    "It's okay to feel that way. You don't have to go through it alone.",
    "Let's take a slow breath together. In... and out. Better?",
    "You're doing better than you think. Do you want to tell me more?",
  ];

  int _index = 0;

  Future<String> getReply(String userText) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final reply = _replies[_index % _replies.length];
    _index++;
    return reply;
  }
}