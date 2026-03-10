import 'package:muse/models/journal_model.dart';

class JournalService {
  // This service will handle saving and loading journal entries.
  Future<void> saveJournalEntry(JournalEntry entry) async {
    // TODO: Implement local storage saving (e.g., using shared_preferences or a local database)
    print('Saving entry: ${entry.id}');
  }

  Future<List<JournalEntry>> loadJournalEntries() async {
    // TODO: Implement local storage loading
    print('Loading journal entries...');
    return [];
  }
}
