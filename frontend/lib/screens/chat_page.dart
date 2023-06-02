import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/screens/overlay_screen.dart';
import 'package:frontend/widgets/received_message.dart';
import 'package:frontend/widgets/send_message.dart';
import 'package:frontend/services/database_helper.dart';

class ChatPage extends StatefulWidget {
  int conversationId;
  ChatPage({super.key, required this.conversationId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  // late List<Message> _messages;

  final ScrollController _scrollController = ScrollController();

  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>();

  @override
  void initState() {
    super.initState();
    _listenForMessages();
  }

  // Listening that changes the screen whenever there has been any change to the data.
  void _listenForMessages() async {
    final messages = await _loadMessages();
    _messageStreamController.sink.add(messages);
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageStreamController.close();
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll to the bottom of the screen when  called
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<List<Message>> _loadMessages() async {
    final messages =
        await DatabaseHelper.instance.getMessages(widget.conversationId);
    return messages;
  }

  Future<void> _sendMessage(String content, String sender) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final message = Message(
      id: 0, // Auto-incremented ID
      content: content,
      sender: sender,
      timestamp: timestamp,
      conversationId: widget.conversationId,
    );
    await DatabaseHelper.instance.insertMessage(message);
    _listenForMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: _messageStreamController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return message.sender == "me"
                        ? SentMessage(
                            message: message.content,
                          )
                        : ReceivedMessage(message: message.content);
                    // return ListTile(
                    //   title: Text(message.content),
                    //   subtitle: Text(message.sender),
                    //   // Display other message details as needed
                    // );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error loading messages');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        // Text(this.text),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0.0, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(30.0))),
                  controller: _messageController,
                ),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () async {
                  final data = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OverlayScreen()));

                  if (data != null) {
                    _sendMessage(data, "me");
                    print(data);
                  }
                  print("Mic1");
                },
                // child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
                child: Icon(Icons.mic),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  final content = _messageController.text;
                  final sender = 'me';
                  if (content.trim() != "") {
                    _sendMessage(content, sender);
                  }
                  _messageController.clear();
                  print(widget.conversationId);
                },
                child: Icon(Icons.send_sharp),
              )
            ],
          ),
        )
      ],
    );
  }
}
