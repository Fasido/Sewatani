import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        Icon(icon, color: AppColors.primary, size: 84),
        const SizedBox(height: 18),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textDark, fontSize: 23, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textGrey, height: 1.5)),
        if (buttonText != null && onPressed != null) ...[
          const SizedBox(height: 22),
          ElevatedButton(onPressed: onPressed, child: Text(buttonText!)),
        ],
      ],
    );
  }
}
