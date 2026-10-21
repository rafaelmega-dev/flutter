import 'package:flutter/material.dart';
import 'app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaFlowColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Ajustes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            _buildSettingTile(context, Icons.person_outline, 'Perfil da Conta', 'Kauã Silva'),
            _buildSettingTile(context, Icons.notifications_outlined, 'Notificações Push', 'Ativado'),
            _buildSettingTile(context, Icons.router_outlined, 'Gateway IoT', 'Conectado (IP: 10.140.169.6)'),
            _buildSettingTile(context, Icons.code, 'Sobre a GrapeDev', 'Versão 1.0.0 TCC'),
            const SizedBox(height: 32),
            
            // Botão de Sair adicionado
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); // Volta para a tela de Login
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text('Sair da Conta', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AquaFlowColors.danger,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AquaFlowColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AquaFlowColors.cardBorder),
      ),
      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Acessando: $title')));
        },
        leading: Icon(icon, color: AquaFlowColors.cyanNeon),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: AquaFlowColors.textMuted, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AquaFlowColors.textMuted),
      ),
    );
  }
}