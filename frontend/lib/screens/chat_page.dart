import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:frontend/screens/example_typing.dart';
import 'package:http/http.dart' as holyhttp;

import 'package:flutter_tts/flutter_tts.dart';

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
  String readMessage = "I am Zeno";
  final _messageController = TextEditingController();
  // late List<Message> _messages;
  bool waitingAi = false;
  FlutterTts flutterTts = FlutterTts();

  final ScrollController _scrollController = ScrollController();

  final StreamController<List<Message>> _messageStreamController =
      StreamController<List<Message>>();

  get http => null;

  @override
  void initState() {
    super.initState();
    _listenForMessages();
    _scrollToBottom();
    initSetting();
  }

  void initSetting() async {
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setLanguage("en-US");
  }

  void _speak() async {
    initSetting();
    await flutterTts.speak(readMessage);
  }

  void _stop() async {
    await flutterTts.stop();
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

  funcbabay(String content) async {
    final response = await holyhttp.post(
      Uri.parse('https://375e-14-139-209-82.ngrok-free.app/ai'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'msg': content,
      }),
    );

    var responseData = json.decode(response.body);
    _storeAi(responseData["zeno"], "Ai");
    _listenForMessages();
  }

  Future<void> _storeAi(String content, String sender) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      waitingAi = false;
      readMessage = content;
    });
    _scrollToBottom();
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

  Future<void> _sendMessage(String content, String sender) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      waitingAi = true;
    });
    _scrollToBottom();
    final message = Message(
      id: 0, // Auto-incremented ID
      content: content,
      sender: sender,
      timestamp: timestamp,
      conversationId: widget.conversationId,
    );
    await DatabaseHelper.instance.insertMessage(message);
    _listenForMessages();
    await funcbabay(content);
  }

  _deleteMessage(int id) async {
    await DatabaseHelper.instance.deleteMessages(id);
    _listenForMessages();
  }

  void _showDeleteConfirmationDialog(BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text('Delete Message'),
          content: Text('Are you sure you want to delete this message?'),
          actions: [
            TextButton(
              child: Text('Copy'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: message.content));
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _speak();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // Handle delete action
                _deleteMessage(message.id);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _handleLongPress(BuildContext context, Message message) {
    _showDeleteConfirmationDialog(context, message);
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
                    return GestureDetector(
                        onLongPress: () {
                          _handleLongPress(context, message);
                        },
                        child: Column(
                          children: [
                            message.sender == "me"
                                ? SentMessage(
                                    message: message.content,
                                  )
                                : ReceivedMessage(
                                    message: message.content,
                                  ),
                          ],
                        ));
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
        Align(
          alignment: Alignment.bottomLeft,
          child: TypingIndicator(
            showIndicator: waitingAi,
          ),
        ),
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
                  var data = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OverlayScreen()));

                  if (data != null && data.trim() != "") {
                    _sendMessage(data, "me");
                  }
                },
                // child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
                child: Icon(Icons.mic),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  final content = _messageController.text;
                  final sender = 'me';
                  if (content.trimRight() != "") {
                    if (content == "!read") {
                      _speak();
                    }
                    if (content == "!stop") {
                      _stop();
                    }
                    // _sendMessage(content, sender);
                  }
                  _messageController.clear();
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
