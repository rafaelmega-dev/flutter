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
        appBar: AppBar(title: Text('Cartão Digital')),
        
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
              width: 350,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 17, 1),
                borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Banco SESI/SENAI", 
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "1234 5678 9012 3456",
                              style: TextStyle(color: Colors.white, fontSize: 26),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Titular",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "Rafael Leme Mega",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            
                    
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.contactless, size: 20, color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.sim_card, size: 40, color: Colors.white,
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            Text(
                              "Validade",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              "02/34",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        )
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
              
               

  