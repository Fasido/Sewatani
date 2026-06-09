class AppNotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  AppNotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
