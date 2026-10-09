import 'package:flutter/material.dart';

class ReadingText {
  const ReadingText({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.paragraphs,
    this.vocab = const [],
  });

  /// معرّف فريد للقصة، يُستخدم لحفظ حالة "تمت القراءة".
  final String id;

  /// عنوان القصة بالإنجليزية.
  final String title;

  /// عنوان القصة بالعربية.
  final String titleAr;

  /// فقرات القصة بالترتيب.
  final List<String> paragraphs;

  /// مفردات القصة: كل عنصر = [الكلمة بالإنجليزية, المعنى بالعربية].
  final List<List<String>> vocab;

  /// عدد الكلمات في القصة، ويُحسب تلقائيًا من الفقرات (لا حاجة لكتابته يدويًا).
  int get wordCount {
    var total = 0;
    for (final paragraph in paragraphs) {
      total += paragraph
          .trim()
          .split(RegExp(r'\s+'))
          .where((word) => word.isNotEmpty)
          .length;
    }
    return total;
  }

  /// عدد الكلمات جاهزًا للعرض على بطاقة القصة: "85 كلمة".
  String get wordCountLabel => '$wordCount كلمة';

  /// عدد فقرات القصة.
  int get paragraphsCount => paragraphs.length;
}

/// نموذج مستوى لغوي واحد بحسب الإطار الأوروبي المرجعي (CEFR).
class CefrLevel {
  const CefrLevel({
    required this.code,
    required this.nameAr,
    // required this.descriptionAr,
    required this.color,
    required this.icon,
    required this.texts,
  });

  /// رمز المستوى: A1 .. C2
  final String code;

  /// اسم المستوى بالعربية.
  final String nameAr;

  /// وصف مختصر لمستوى القصص.
  // final String descriptionAr;

  /// لون المستوى (يُستخدم في البطاقات ومربعات الحوار).
  final Color color;

  /// أيقونة المستوى.
  final IconData icon;

  /// قصص المستوى القصيرة.
  final List<ReadingText> texts;

  /// عدد قصص المستوى.
  int get storiesCount => texts.length;
}
