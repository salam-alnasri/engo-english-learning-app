/// نموذج قطعة استماع واحدة: جملة + كلمات للترتيب + ترجمة عربية.
///
/// البيانات الفعلية تُحمَّل الآن من `assets/data/lesson3_sentences.json`
/// عبر `LessonRepository.lesson3Sentences(lesson: ...)`.
///
/// هذا الكلاس محفوظ لتوفير النوع لـ `lesson3_controller.dart` و `lesson3.dart`.
class ListeningItem {
  /// رقم الدرس (Lesson) الذي تنتمي إليه الجملة.
  final int lesson;

  final String sentence;
  final List<String> options;
  final String translation;

  const ListeningItem({
    required this.lesson,
    required this.sentence,
    required this.options,
    required this.translation,
  });
}