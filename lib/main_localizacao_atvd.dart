import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Minha localização',
      home: LocalizacaoPage(),
    );
  }
}

class LocalizacaoPage extends StatefulWidget {
  const LocalizacaoPage({super.key});

  @override
  State<LocalizacaoPage> createState() => _LocalizacaoPageState();
}

class _LocalizacaoPageState extends State<LocalizacaoPage> {
  double latitudeAtual = 0;
  double longitudeAtual = 0;

  final double latitudeCasa = -21.479913671656487; 
  final double longitudeCasa = -47.00494079948531;

  double distanciaKm = 0;

  Future<void> buscarLocalizacao() async {
    bool servicoAtivo = await Geolocator.isLocationServiceEnabled();

    if (!servicoAtivo) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition();
  
    double distanciaEmMetros = Geolocator.distanceBetween(
      posicao.latitude,
      posicao.longitude,
      latitudeCasa,
      longitudeCasa,
    );

    setState(() {
      latitudeAtual = posicao.latitude;
      longitudeAtual = posicao.longitude;
      distanciaKm = distanciaEmMetros / 1000; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Localização'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Minha Posição Atual',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Lat: $latitudeAtual | Lon: $longitudeAtual', style: const TextStyle(fontSize: 16)),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(),
              ),

              const Icon(Icons.home, size: 60, color: Colors.green),
              const SizedBox(height: 10),
              const Text(
                'Coordenadas da Casa do Rafael',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Lat: $latitudeCasa | Lon: $longitudeCasa', style: const TextStyle(fontSize: 16)),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Divider(),
              ),

              const Text(
                'Distância até em casa:',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                '${distanciaKm.toStringAsFixed(2)} km',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: buscarLocalizacao,
                icon: const Icon(Icons.refresh),
                label: const Text('Calcular Distância Atual'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
