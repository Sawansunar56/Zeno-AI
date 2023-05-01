import 'package:frontend/constants/router_constants.dart';
import 'package:frontend/screens/chat_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/start_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouterConstants.startPage,
        path: '/start',
        pageBuilder: (context, state) {
          return MaterialPage(child: StartPage());
        },
      ),
      GoRoute(
        name: RouterConstants.homePage,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(child: MyHomePage());
        },
      ),
      GoRoute(
        name: RouterConstants.chatPage,
        path: '/chat',
        pageBuilder: (context, state) {
          return MaterialPage(child: ChatPage());
        },
      )
    ],
  );
}
