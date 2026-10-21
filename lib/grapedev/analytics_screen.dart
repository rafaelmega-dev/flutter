import 'package:flutter/material.dart';
import 'app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedFilter = 'Hoje';
  final List<String> _filters = ['Hoje', '7 dias', '30 dias', '90 dias', 'Personalizado'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaFlowColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Análises', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const Text('Acompanhe o histórico do seu consumo', style: TextStyle(fontSize: 13, color: AquaFlowColors.textSecondary)),
              const SizedBox(height: 20),

              // Filtro de Período Funcional
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    bool isSelected = filter == _selectedFilter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AquaFlowColors.cyanNeon : AquaFlowColors.cardBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? Colors.transparent : AquaFlowColors.cardBorder),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),
              // Restante da tela permanece idêntico...
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AquaFlowColors.cardBg, borderRadius: BorderRadius.circular(20), border: Border.all(color: AquaFlowColors.cardBorder)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consumo de água (${_selectedFilter.toLowerCase()})', style: const TextStyle(color: AquaFlowColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('1.256 L', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(colors: [AquaFlowColors.cyanNeon.withOpacity(0.2), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                      ),
                      child: const Center(child: Icon(Icons.show_chart, color: AquaFlowColors.cyanNeon, size: 80)),
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