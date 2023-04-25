import 'package:flutter/material.dart';
import 'package:frontend/routes/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.router.routeInformationParser,
      routerDelegate: _router.router.routerDelegate,
      debugShowCheckedModeBanner: false,
    );
  }
}
