import 'package:flutter/material.dart';

void main() {
  runApp(ScrollApp());
}

class ScrollApp extends StatelessWidget {
  const ScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Scroll',
      home: Scaffold(
        appBar: AppBar(title: Text("SingleChildScrollView")),
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(
              20,
              (index) => Container(
                margin: EdgeInsets.all(10),
                height: 80,
                color: Colors.green,
                child: Center(
                  child: Text(
                    "Item ${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}