import 'dart:convert';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

/// الدرس الأول: كلمة + ترجمة + إيموجي
class Lesson1Word {
  final String word;
  final String ar;
  final String image;

  /// رقم الدرس (Lesson). يُستخدم للتصفية من الـ JSON.
  /// يطابق رقم المستوى الذي يضغطه المستخدم في الـ roadmap
  /// (مثال: lesson 1 = المرحلة الأولى في الـ JSON).
  ///
  /// يُقرأ من حقل `lesson` أولاً، وإن لم يوجد يُقرأ من `difficulty`
  /// (للتوافق مع عناصر JSON القديمة).
  final int lesson;

  const Lesson1Word({
    required this.word,
    required this.ar,
    required this.image,
    required this.lesson,
  });

  factory Lesson1Word.fromJson(Map<String, dynamic> json) => Lesson1Word(
    word: json['word'] as String,
    ar: json['ar'] as String,
    image: (json['image'] as String).trim(),
    lesson: _readLessonOrDifficulty(json),
  );

  /// للتوافق مع الكود القديم الذي يستخدم Map
  Map<String, dynamic> toMap() => {
    'word': word,
    'ar': ar,
    'image': image,
    'lesson': lesson,
  };
}

/// الدرس الثاني: مطابقة كلمة إنجليزية بترجمتها
class Lesson2Pair {
  final String en;
  final String ar;

  /// رقم الدرس (Lesson). يُستخدم للتصفية من الـ JSON.
  ///
  /// يُقرأ من حقل `lesson` أولاً، وإن لم يوجد يُقرأ من `difficulty`.
  final int lesson;

  const Lesson2Pair({
    required this.en,
    required this.ar,
    required this.lesson,
  });

  factory Lesson2Pair.fromJson(Map<String, dynamic> json) => Lesson2Pair(
    en: json['en'] as String,
    ar: json['ar'] as String,
    lesson: _readLessonOrDifficulty(json),
  );

  Map<String, dynamic> toMap() => {
    'en': en,
    'ar': ar,
    'lesson': lesson,
  };
}

/// الدرس الثالث: جملة للاستماع
/// إذا كان عندك كلاس ListeningItem موجود، يمكنك استخدام
/// هذه البيانات لإنشائه: ListeningItem(lesson: x.lesson, ...)
class Lesson3Sentence {
  /// رقم الدرس (Lesson). يُستخدم للتصفية من الـ JSON.
  ///
  /// يُقرأ من حقل `lesson` أولاً، وإن لم يوجد يُقرأ من `difficulty`.
  final int lesson;
  final String sentence;
  final List<String> options;
  final String translation;

  const Lesson3Sentence({
    required this.lesson,
    required this.sentence,
    required this.options,
    required this.translation,
  });

  factory Lesson3Sentence.fromJson(Map<String, dynamic> json) =>
      Lesson3Sentence(
        lesson: _readLessonOrDifficulty(json),
        sentence: json['sentence'] as String,
        options: List<String>.from(json['options'] as List),
        translation: json['translation'] as String,
      );
}

/// يقرأ رقم الدرس من حقل `lesson` أولاً، ثم `difficulty` كتوافق خلفي.
/// يُرجع 1 كقيمة افتراضية إن لم يوجد أي منهما.
int _readLessonOrDifficulty(Map<String, dynamic> json) {
  final dynamic raw = json['lesson'] ?? json['difficulty'];
  if (raw is int) return raw;
  if (raw is num) return raw.toInt();
  return 1;
}

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

class LessonRepository {
  LessonRepository._();

  static const _lesson1Path = 'assets/data/lesson1_words.json';
  static const _lesson2Path = 'assets/data/lesson2_pairs.json';
  static const _lesson3Path = 'assets/data/lesson3_sentences.json';

  // تخزين مؤقت حتى لا يُقرأ الملف في كل مرة
  static final Map<String, List<Map<String, dynamic>>> _cache = {};

  static Future<List<Map<String, dynamic>>> _load(String path) async {
    final cached = _cache[path];
    if (cached != null) return cached;

    final raw = await rootBundle.loadString(path);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final items = List<Map<String, dynamic>>.from(data['items'] as List);
    _cache[path] = items;
    return items;
  }

  /// يُرجع كلمات درس معيّن.
  /// مثال: lesson1Words(lesson: 1) → 10 كلمات للدرس الأول.
  static Future<List<Lesson1Word>> lesson1Words({int? lesson}) async {
    final items = await _load(_lesson1Path);
    return items
        .map(Lesson1Word.fromJson)
        .where((w) => lesson == null || w.lesson == lesson)
        .toList();
  }

  /// يُرجع أزواج الترجمة لدرس معيّن.
  static Future<List<Lesson2Pair>> lesson2Pairs({int? lesson}) async {
    final items = await _load(_lesson2Path);
    return items
        .map(Lesson2Pair.fromJson)
        .where((p) => lesson == null || p.lesson == lesson)
        .toList();
  }

  /// يُرجع جُمل الاستماع لدرس معيّن.
  static Future<List<Lesson3Sentence>> lesson3Sentences({int? lesson}) async {
    final items = await _load(_lesson3Path);
    return items
        .map(Lesson3Sentence.fromJson)
        .where((s) => lesson == null || s.lesson == lesson)
        .toList();
  }
}