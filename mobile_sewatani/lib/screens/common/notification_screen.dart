import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final items = provider.items;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: provider.markAllAsRead,
              child: const Text('Baca semua'),
            ),
        ],
      ),
      body: items.isEmpty
          ? const _EmptyNotification()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: item.isRead
                          ? const Color(0xFFE5E7EB)
                          : AppColors.primary.withOpacity(0.25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.035),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primarySoft,
                        child: Icon(
                          item.type == 'new_order'
                              ? Icons.inbox_rounded
                              : Icons.notifications_active_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              item.body,
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTime(item.createdAt),
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _EmptyNotification extends StatelessWidget {
  const _EmptyNotification();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 120),
        Icon(
          Icons.notifications_none_rounded,
          color: AppColors.primary,
          size: 86,
        ),
        SizedBox(height: 18),
        Text(
          'Belum ada notifikasi',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Update booking dan pesanan baru akan tampil di halaman ini.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textGrey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
