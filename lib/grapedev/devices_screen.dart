import 'package:flutter/material.dart';
import 'app_theme.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({Key? key}) : super(key: key);

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
              const Text(
                'Dispositivos',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                'Gerencie e monitore todos os dispositivos do AquaFlow',
                style: TextStyle(fontSize: 12, color: AquaFlowColors.textSecondary),
              ),
              const SizedBox(height: 20),

              // Métricas dos Dispositivos (Total, Online, Atenção)
              Row(
                children: [
                  _buildStatusBadge('4 Total', Colors.blue),
                  const SizedBox(width: 8),
                  _buildStatusBadge('3 Online', AquaFlowColors.success),
                  const SizedBox(width: 8),
                  _buildStatusBadge('1 Atenção', AquaFlowColors.danger),
                ],
              ),

              const SizedBox(height: 24),

              // Lista de Dispositivos
              _buildDeviceCard('Válvula Principal', 'Local: Caixa d\'água', 'Aberta • Fluxo: 12,4 L/min', true, AquaFlowColors.cyanNeon),
              _buildDeviceCard('Sensor Entrada', 'Local: Tubulação principal', 'Fluxo normal • Total: 562 L', true, AquaFlowColors.success),
              _buildDeviceCard('Área Externa', 'Local: Jardim', 'Sem vazamentos • Umidade 32%', false, AquaFlowColors.textMuted),
              _buildDeviceCard('Banheiro Social', 'Local: Banheiro', 'Possível vazamento detectado', true, AquaFlowColors.danger),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  static Widget _buildDeviceCard(String name, String location, String info, bool active, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AquaFlowColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AquaFlowColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Switch(value: active, onChanged: (v) {}, activeColor: statusColor),
            ],
          ),
          Text(location, style: const TextStyle(color: AquaFlowColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Text(info, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}