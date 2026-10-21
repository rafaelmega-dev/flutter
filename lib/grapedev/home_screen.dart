import 'package:flutter/material.dart';
import 'app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Estado dos dispositivos
  bool _valveMainOpen = true;
  bool _bathroomValveOpen = false;

  void _showNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nenhuma notificação nova no momento.'),
        backgroundColor: AquaFlowColors.cardBorder,
      ),
    );
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('AquaFlow', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AquaFlowColors.purpleNeon)),
                      SizedBox(height: 4),
                      Text('Olá, Kauã! 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Monitore cada gota. Economize água.', style: TextStyle(fontSize: 12, color: AquaFlowColors.textSecondary)),
                    ],
                  ),
                  GestureDetector(
                    onTap: _showNotification,
                    child: const CircleAvatar(
                      backgroundColor: AquaFlowColors.cardBg,
                      child: Icon(Icons.notifications_none, color: AquaFlowColors.cyanNeon),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Banner Principal
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [Color(0xFF0284C7), Color(0xFF0F172A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  border: Border.all(color: AquaFlowColors.cyanNeon.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consumo de hoje', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AquaFlowColors.cyanNeon.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Text('1.256 L', style: TextStyle(color: AquaFlowColors.cyanNeon, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('1.256 L', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(Icons.arrow_downward, color: AquaFlowColors.success, size: 16),
                        SizedBox(width: 4),
                        Text('8% menor que ontem', style: TextStyle(color: AquaFlowColors.success, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Visão geral', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  InkWell(
                    onTap: () {
                      // Simula a abertura de um menu dropdown
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtro de data clicado')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AquaFlowColors.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AquaFlowColors.cardBorder),
                      ),
                      child: Row(
                        children: const [
                          Text('Hoje', style: TextStyle(color: Colors.white, fontSize: 12)),
                          Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  _buildMetricCard('Consumo total', '1.256 L', Colors.blue),
                  const SizedBox(width: 12),
                  _buildMetricCard('Economia', '214 L', AquaFlowColors.success),
                  const SizedBox(width: 12),
                  _buildMetricCard('Custo estim.', 'R\$ 6,38', AquaFlowColors.purpleNeon),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Dispositivos em destaque', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              
              _buildDeviceTile(
                'Válvula Principal', 
                _valveMainOpen ? 'Aberta • Fluxo: 12,4 L/min' : 'Fechada', 
                _valveMainOpen, 
                AquaFlowColors.cyanNeon,
                (val) => setState(() => _valveMainOpen = val)
              ),
              _buildDeviceTile(
                'Banheiro Social', 
                _bathroomValveOpen ? 'Fluxo contínuo • Atenção' : 'Fechada (Segura)', 
                _bathroomValveOpen, 
                _bathroomValveOpen ? AquaFlowColors.danger : AquaFlowColors.textMuted,
                (val) => setState(() => _bathroomValveOpen = val)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AquaFlowColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AquaFlowColors.cardBorder)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 6, backgroundColor: accentColor),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: AquaFlowColors.textMuted, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTile(String name, String status, bool isOpen, Color statusColor, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AquaFlowColors.cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: AquaFlowColors.cardBorder)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: statusColor.withOpacity(0.2), child: Icon(Icons.water, color: statusColor)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(status, style: TextStyle(color: statusColor, fontSize: 11)),
                ],
              ),
            ],
          ),
          Switch(
            value: isOpen,
            onChanged: onChanged,
            activeColor: AquaFlowColors.cyanNeon,
          ),
        ],
      ),
    );
  }
}