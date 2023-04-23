import 'package:flutter/material.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
