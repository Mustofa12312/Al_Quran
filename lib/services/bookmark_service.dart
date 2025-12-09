// lib/services/bookmark_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class BookmarkService {
  static const String key = "BOOKMARK_LIST";

  /// Get all bookmarks
  static Future<List<Map<String, dynamic>>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(key);

    if (jsonData == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(jsonData));
  }

  /// Check if bookmarked
  static Future<bool> isBookmarked(int surah, int ayat) async {
    final list = await getBookmarks();
    return list.any((b) => b["surah"] == surah && b["ayat"] == ayat);
  }

  /// Add bookmark
  static Future<void> addBookmark(int surah, int ayat, String arab) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBookmarks();

    bool exist = list.any((b) => b["surah"] == surah && b["ayat"] == ayat);

    if (!exist) {
      list.add({"surah": surah, "ayat": ayat, "arab": arab});
      await prefs.setString(key, json.encode(list));
    }
  }

  /// Remove bookmark
  static Future<void> removeBookmark(int surah, int ayat) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getBookmarks();

    list.removeWhere((b) => b["surah"] == surah && b["ayat"] == ayat);

    await prefs.setString(key, json.encode(list));
  }
}
