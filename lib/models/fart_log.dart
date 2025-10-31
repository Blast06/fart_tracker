class FartLog {
  final String id;
  final String userId;
  final DateTime loggedAt;
  final bool isSilent;
  final DateTime createdAt;

  FartLog({
    required this.id,
    required this.userId,
    required this.loggedAt,
    required this.isSilent,
    required this.createdAt,
  });

  factory FartLog.fromJson(Map<String, dynamic> json) {
    return FartLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      loggedAt: DateTime.parse(json['logged_at'] as String),
      isSilent: json['is_silent'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'logged_at': loggedAt.toIso8601String(),
      'is_silent': isSilent,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
