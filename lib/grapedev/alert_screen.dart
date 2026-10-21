import 'package:flutter/material.dart';
import 'app_theme.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool _isValveClosed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AquaFlowColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ícone Alerta Animado
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isValveClosed ? AquaFlowColors.success.withOpacity(0.2) : AquaFlowColors.danger.withOpacity(0.2),
                  border: Border.all(
                    color: _isValveClosed ? AquaFlowColors.success : AquaFlowColors.danger,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _isValveClosed ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                  size: 60,
                  color: _isValveClosed ? AquaFlowColors.success : AquaFlowColors.danger,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _isValveClosed ? 'Vazamento Fechado!' : 'ALERTA DE VAZAMENTO!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _isValveClosed ? AquaFlowColors.success : AquaFlowColors.danger,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isValveClosed
                    ? 'A Válvula V-401 foi fechada remotamente com sucesso.'
                    : 'Anomalia detectada no Banheiro Social (Válvula V-401).',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AquaFlowColors.textSecondary, fontSize: 14),
              ),

              const SizedBox(height: 36),

              // Botão de Ação Imediata
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isValveClosed = !_isValveClosed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isValveClosed ? AquaFlowColors.cardBg : AquaFlowColors.danger,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _isValveClosed ? 'REABRIR VÁLVULA' : 'FECHAR VÁLVULA AGORA',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}