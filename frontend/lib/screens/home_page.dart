import 'package:flutter/material.dart';
import 'package:frontend/constants/router_constants.dart';
import 'package:frontend/screens/chat_page.dart';

import 'package:go_router/go_router.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(children: [
              Text(
                "History",
                style: TextStyle(fontSize: 20),
              ),
              Expanded(
                child: Text("hellow"),
              ),
              ElevatedButton(onPressed: () {}, child: Text("Add")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.ac_unit),
                  Icon(Icons.ac_unit),
                  Icon(Icons.ac_unit),
                ],
              )
            ]),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Zeno"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              GoRouter.of(context).pushNamed(RouterConstants.versionPage);
            },
            child: Icon(Icons.abc),
          )
        ],
      ),
      body: ChatPage(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: toggleRecording,
      //   child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
      // ),
    );
  }
}
