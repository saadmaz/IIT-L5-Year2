import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

final Logger logger = Logger();

class StorageHelper {
  static const String _keyPainHistory = 'painHistory';

  /// ✅ Loads stored pain history from SharedPreferences.
  static Future<List<Map<String, dynamic>>> loadPainHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString(_keyPainHistory);

      if (storedData == null || storedData.isEmpty) return [];

      final decodedData = json.decode(storedData);
      if (decodedData is List) {
        return List<Map<String, dynamic>>.from(decodedData);
      } else {
        return [];
      }
    } catch (e, stackTrace) {
      logger.e("Error loading pain history", error: e, stackTrace: stackTrace);
      return [];
    }
  }

  /// ✅ Saves pain history into SharedPreferences.
  static Future<void> savePainHistory(
      List<Map<String, dynamic>> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = json.encode(history);
      await prefs.setString(_keyPainHistory, encodedData);
    } catch (e, stackTrace) {
      logger.e("Error saving pain history", error: e, stackTrace: stackTrace);
    }
  }

  /// ✅ Clears all stored pain history.
  static Future<void> clearPainHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyPainHistory);
      logger.i("Pain history cleared.");
    } catch (e, stackTrace) {
      logger.e("Error clearing pain history", error: e, stackTrace: stackTrace);
    }
  }

  /// ✅ Adds a new entry to the pain history.
  static Future<void> addPainEntry(Map<String, dynamic> newEntry) async {
    try {
      List<Map<String, dynamic>> history = await loadPainHistory();
      history.insert(0, newEntry); // Add new entry to the beginning
      await savePainHistory(history);
    } catch (e, stackTrace) {
      logger.e("Error adding pain entry", error: e, stackTrace: stackTrace);
    }
  }
}
