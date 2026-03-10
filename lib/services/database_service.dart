import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muse/models/journal_model.dart';

class DatabaseService {
  static const String _journalBoxName = 'journalBox';

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(JournalEntryAdapter());
  }

  Future<Box<JournalEntry>> _openJournalBox() async {
    return await Hive.openBox<JournalEntry>(_journalBoxName);
  }

  Future<List<JournalEntry>> getJournalEntries() async {
    final box = await _openJournalBox();
    return box.values.toList();
  }

  Future<void> addJournalEntry(JournalEntry entry) async {
    final box = await _openJournalBox();
    await box.put(entry.id, entry); // Use id as key
  }

  Future<void> deleteJournalEntry(String id) async {
    final box = await _openJournalBox();
    await box.delete(id);
  }

  Future<JournalEntry?> getJournalEntry(String id) async {
    final box = await _openJournalBox();
    return box.get(id);
  }
}
