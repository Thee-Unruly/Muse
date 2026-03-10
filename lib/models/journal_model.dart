import 'package:hive/hive.dart';

part 'journal_model.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String originalSpeech;

  @HiveField(3)
  final String aiReflection;

  JournalEntry({
    required this.id,
    required this.date,
    required this.originalSpeech,
    required this.aiReflection,
  });

  // No need for toMap/fromMap if using Hive for persistence directly
}
