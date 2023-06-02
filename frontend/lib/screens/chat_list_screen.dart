import 'package:flutter/material.dart';
import 'package:frontend/screens/exam_chat.dart';

import '../services/database_helper.dart';

class ChatlistScreen extends StatefulWidget {
  ChatlistScreen({super.key});

  @override
  State<ChatlistScreen> createState() => _ChatlistScreenState();
}

class _ChatlistScreenState extends State<ChatlistScreen> {
  List<Conversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final conversations = await DatabaseHelper.instance.getConversations();
    setState(() {
      _conversations = conversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return ListTile(
          title: Text('Conversation ${conversation.conversationId}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(conversationId: conversation.id),
              ),
            );
          },
        );
      },
    );
  }
}
