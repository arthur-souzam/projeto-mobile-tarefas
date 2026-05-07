import 'package:flutter/material.dart';

class BotaoPrimario extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final IconData? icone;
  final Color? cor;

  const BotaoPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.icone,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icone != null ? Icon(icone) : const SizedBox.shrink(),
      label: Text(texto),
      style: ElevatedButton.styleFrom(
        backgroundColor: cor ?? Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
