import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import '../services/database_helper.dart';

class ChatlistScreen extends StatefulWidget {
  final Function(int) onOptionSelected;
  ChatlistScreen({super.key, required this.onOptionSelected});

  @override
  State<ChatlistScreen> createState() => _ChatlistScreenState();
}

class _ChatlistScreenState extends State<ChatlistScreen> {
  List<Conversation> _conversations = [];
  TextEditingController _conversationController = TextEditingController();

  final StreamController<List<Conversation>> _conversationStreamController =
      StreamController<List<Conversation>>();

  @override
  void initState() {
    super.initState();
    _listenForConversations();
  }

  @override
  void dispose() {
    _conversationStreamController.close();
    super.dispose();
  }

  void _listenForConversations() async {
    final conversations = await _loadConversations();
    _conversationStreamController.sink.add(conversations);
  }

  Future<List<Conversation>> _loadConversations() async {
    final conversations = await DatabaseHelper.instance.getConversations();
    setState(() {
      _conversations = conversations;
    });
    return conversations;
  }

  Future<void> _sendConversation(String conversation) async {
    final _conversation = Conversation(id: 0, conversationText: conversation);
    await DatabaseHelper.instance.insertConversation(_conversation);
    _listenForConversations();
  }

  _deleteConversation(int conversationId) async {
    await DatabaseHelper.instance.deleteConversation(conversationId);
    _listenForConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: Colors.red.shade400,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: -1.0),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.0, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(10.0))),
                  controller: _conversationController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                    onPressed: () {
                      _sendConversation(_conversationController.text);
                      _conversationController.clear();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("Add"),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Conversation>>(
              stream: _conversationStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: _conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = _conversations[index];
                      return Card(
                        child: ListTile(
                          trailing: conversation.conversationText != "Default"
                              ? IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    _deleteConversation(conversation.id);
                                  },
                                )
                              : Text(""),
                          title: Text(
                            conversation.conversationText,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onTap: () {
                            widget.onOptionSelected(conversation.id);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ConversationScreen(conversationId: conversation.id),
                            //   ),
                            // );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Error loading Conversations");
                }
                return CircularProgressIndicator();
              }),
        ),
      ],
    );
  }
}
