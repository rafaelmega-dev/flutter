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
        appBar: AppBar(title: Text('Carteira Digital')),
        
        body: Center(
          child: Column(
            children: [
              Container(
              width: 350,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color.fromARGB(255, 236, 0, 0),
                  Color.fromARGB(255, 149, 1, 1),
                ],  
                ),
                boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
                ],
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
              SizedBox(
                height: 70,
              ),
              Container(
              width: 350,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 236, 94, 0),
                  Color.fromARGB(255, 164, 72, 0),
                ],  
                ),
                boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
                ],
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
                              "Itáu", 
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "5555 6666 7777 8888",
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
                              "Vitória Pierre Mello",
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
                              "09/33",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(
                height: 70,
              ),
              Container(
              width: 350,
              height: 200,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 122, 0, 236),
                  Color.fromARGB(255, 73, 0, 132),
                ],  
                ),
                boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
                ],    
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
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(  
                                  width: 20,
                                ),
                                Image.asset(
                                'assets/images/chip-cartao.png',
                                width: 40,
                                ),
                                SizedBox(
                                width: 10,
                                ),
                                Icon(
                                  Icons.contactless_outlined, size: 20, color: Colors.white,
                                ),
                                SizedBox (  
                                  width: 130,
                                ),
                                Image.asset(  
                                  'assets/images/mastercard.png',
                                  width: 70,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Row(
                              children: [
                                Image.asset (
                                  'assets/images/nubank-logo-1.png',
                                  width: 50,
                                ),
                                SizedBox(  
                                  width: 40,
                                ),
                                Text(
                                  "Samuel Ângelo Carneiro Dias",style: TextStyle(color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
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
              
               

  