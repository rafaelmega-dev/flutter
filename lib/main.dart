import 'package:flutter/material.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tela de Login Responsiva",
      home: const HomeScreen(),
    );
  }
}
        
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: largura * 0.9,
              height: altura * 0.8,
            child: Column(  
              children: [
                Icon(
                  Icons.lock,
                  size: largura * 0.2,
                  color: Colors.blue
                ),
                SizedBox(height: altura * 0.05),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: largura * 0.08,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(height: altura * 0.05),
                TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: altura * 0.03),
                TextField(
                    decoration: InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                  ),
                  ),
                


            ],
          )
           
        )
      ),
    ),
    )
    );
  }
}
    

        

    
