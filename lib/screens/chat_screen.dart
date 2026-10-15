import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/chat_message.dart';
import '../routes/app_routes.dart';
import '../services/mock_chat_service.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final _service = MockChatService();
  bool _typing = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hi, I'm ComfyAI 💜 How are you feeling today?",
      isUser: false,
      time: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _typing) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
      _typing = true;
      _controller.clear();
    });
    _scrollToBottom();

    final reply = await _service.getReply(text);
    if (!mounted) return;

    setState(() {
      _messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      _typing = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = (ModalRoute.of(context)?.settings.arguments as bool?) ?? false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.appName,
              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
            ),
            Text(
              isGuest ? 'Guest mode' : 'Signed in',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Leave',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isGuest)
            Container(
              width: double.infinity,
              color: AppColors.primarySoft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "You're chatting as a guest. Chats won't be saved.",
                      style: TextStyle(fontSize: 13, color: AppColors.text),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.register),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (context, i) {
                if (i == _messages.length) {
                  return ChatBubble(
                    message: ChatMessage(
                      text: 'ComfyAI is typing...',
                      isUser: false,
                      time: DateTime.now(),
                    ),
                  );
                }
                return ChatBubble(message: _messages[i]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Type how you feel...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}