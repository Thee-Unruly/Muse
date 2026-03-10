class JournalEntry {
  final String id;
  final String originalText;
  final String aiRewrittenText;
  final DateTime timestamp;

  JournalEntry({
    required this.id,
    required this.originalText,
    required this.aiRewrittenText,
    required this.timestamp,
  });

  // Convert a JournalEntry into a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalText': originalText,
      'aiRewrittenText': aiRewrittenText,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert a Map into a JournalEntry.
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      originalText: map['originalText'],
      aiRewrittenText: map['aiRewrittenText'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
