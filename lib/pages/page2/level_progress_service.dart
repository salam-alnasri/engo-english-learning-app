import 'package:get_storage/get_storage.dart';

/// خدمة حفظ تقدّم القراءة لكل مستوى (النصوص التي أنهى المستخدم قراءتها).
class LevelProgressService {
  static final GetStorage _box = GetStorage();

  static String _readKey(String levelCode) =>
      'reading_level_${levelCode}_read_texts';

  /// معرّفات النصوص التي تمت قراءتها في هذا المستوى.
  static List<String> getReadTexts(String levelCode) {
    final stored = _box.read<dynamic>(_readKey(levelCode));
    if (stored is List) {
      return stored.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  static bool isTextRead(String levelCode, String textId) =>
      getReadTexts(levelCode).contains(textId);

  static int getReadCount(String levelCode) => getReadTexts(levelCode).length;

  static Future<void> markAsRead(String levelCode, String textId) async {
    final readIds = getReadTexts(levelCode);
    if (!readIds.contains(textId)) {
      readIds.add(textId);
      await _box.write(_readKey(levelCode), readIds);
    }
  }

  static Future<void> unmarkAsRead(String levelCode, String textId) async {
    final readIds = getReadTexts(levelCode);
    readIds.remove(textId);
    await _box.write(_readKey(levelCode), readIds);
  }

  static Future<void> resetLevel(String levelCode) async {
    await _box.remove(_readKey(levelCode));
  }
}
