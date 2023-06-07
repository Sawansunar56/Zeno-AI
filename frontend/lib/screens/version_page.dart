import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:http/http.dart' as http;

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});
  funcbabay() async {
    final response = await http.post(
      Uri.parse('https://960f-14-139-209-82.ngrok-free.app/ai'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'msg': "hello babay",
      }),
    );

    var responseData = json.decode(response.body);
    print(responseData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Zeno"),
        centerTitle: true,
        backgroundColor: white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRz0MILLE1kA41DptTXN0bsqcGtkRnewFQk6A&usqp=CAU"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "ZENO V 1.1",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(child: Text("")),
            Text(
              "From: ",
              style: TextStyle(fontSize: 20),
            ),
            Text("Sawan Sunar"),
            Text("Nilabh Choudhury"),
            Text("Mortaza behesti Al Saeed"),
            ElevatedButton(
                onPressed: () {
                  funcbabay();
                },
                child: Text("Helllo")),
          ],
        ),
      ),
    );
  }
}
