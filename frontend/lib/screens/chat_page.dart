import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/ai_text.dart';
import 'package:frontend/widgets/user_text.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
        appBar: AppBar(
          shadowColor: backgroundColor,
          bottomOpacity: 0,
          backgroundColor: Colors.white,
          shape: Border(
            bottom: BorderSide(color: backgroundColor, width: 2),
          ),
          elevation: 1,
          toolbarHeight: 100,
          centerTitle: true,
          title: const Text(
            "Chat",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),
          actions: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Builder(
                    builder: (BuildContext context) {
                      return Ink(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: backgroundColor,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.more_vert,
                              color: lighterBlack, size: 28),
                          tooltip: MaterialLocalizations.of(context)
                              .openAppDrawerTooltip,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: ListView(
                  children: [
                    UserText(),
                    AiText(),
                    UserText(),
                    AiText(),
                    UserText(),
                    AiText(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 16.0, left: 8, right: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Column(
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'Ask me anything...',
                            border: InputBorder.none,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Send"),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("Send"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
