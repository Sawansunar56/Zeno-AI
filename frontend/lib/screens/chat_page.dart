import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat", style: TextStyle(color: Colors.black)),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu_open_outlined),
            );
          },
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            Text("data"),
            Text("data"),
            Text("data"),
            Text("data"),
          ],
        ),
      ),
    );
  }
}
