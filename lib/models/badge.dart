class BadgeModel {
  final String emoji;
  final String titleKey;
  final String descriptionKey;
  final bool isUnlocked;

  BadgeModel({
    required this.emoji,
    required this.titleKey,
    required this.descriptionKey,
    this.isUnlocked = false,
  });
}
