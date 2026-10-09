import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:engo/pages/page2/level_models.dart';

/// تحميل القصص من ملفات JSON المحلية وتحويلها إلى ReadingText
/// (نفس الكلاس المستخدم حالياً، فلا تتغير الشاشات).
///
/// المستويات المتاحة: a1, a2, b1, b2, c1, c2
class StoriesRepository {
  StoriesRepository._();

  static const _basePath = 'assets/data';

  // تخزين مؤقت حتى لا يُقرأ الملف في كل مرة
  static final Map<String, List<ReadingText>> _cache = {};

  /// مثال: await StoriesRepository.load('a1')
  static Future<List<ReadingText>> load(String level) async {
    final key = level.toLowerCase();
    final cached = _cache[key];
    if (cached != null) return cached;

    final raw = await rootBundle.loadString('$_basePath/${key}_stories.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final items = (data['items'] as List).cast<Map<String, dynamic>>();

    final stories = items.map(_fromJson).toList(growable: false);
    _cache[key] = stories;
    return stories;
  }

  /// تحميل قصة واحدة بالـ id، مثل 'a1_3'
  static Future<ReadingText?> byId(String id) async {
    final level = id.split('_').first;
    final stories = await load(level);
    for (final s in stories) {
      if (s.id == id) return s;
    }
    return null;
  }

  static ReadingText _fromJson(Map<String, dynamic> json) {
    final vocab = (json['vocab'] as List)
        .map<List<String>>(
          (v) => [v['en'] as String, v['ar'] as String],
        )
        .toList();

    return ReadingText(
      id: json['id'] as String,
      title: json['title'] as String,
      titleAr: json['titleAr'] as String,
      paragraphs: List<String>.from(json['paragraphs'] as List),
      vocab: vocab,
    );
  }
}
