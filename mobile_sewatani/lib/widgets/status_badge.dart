import 'package:flutter/material.dart';
import '../config/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;
  const StatusBadge({super.key, required this.status, this.compact = false});

  Color get color {
    switch (status) {
      case 'diterima': return AppColors.primary;
      case 'selesai': return const Color(0xFF2563EB);
      case 'ditolak':
      case 'tidak_tersedia': return AppColors.danger;
      case 'tersedia': return AppColors.primary;
      default: return const Color(0xFFF59E0B);
    }
  }

  String get label {
    switch (status) {
      case 'diterima': return 'Diterima';
      case 'selesai': return 'Selesai';
      case 'ditolak': return 'Ditolak';
      case 'tidak_tersedia': return 'Tidak tersedia';
      case 'tersedia': return 'Tersedia';
      default: return 'Menunggu';
    }
  }

  IconData get icon {
    switch (status) {
      case 'diterima': return Icons.verified_rounded;
      case 'selesai': return Icons.task_alt_rounded;
      case 'ditolak': return Icons.cancel_rounded;
      case 'tidak_tersedia': return Icons.block_rounded;
      case 'tersedia': return Icons.check_circle_rounded;
      default: return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 5 : 7),
      decoration: BoxDecoration(
        color: c.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 13 : 15, color: c),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: c, fontSize: compact ? 11 : 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
