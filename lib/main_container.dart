import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Exemplo Container')),
        
        body: Center(
          child: Container(
          width: 200,
          height: 100,
          color: Colors.green,
          child: Center(
            child: Text("Olá Flutter",style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
      ),
    );
  }
}