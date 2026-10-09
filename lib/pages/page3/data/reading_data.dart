/// نموذج بيانات القراءة — مرتبط بمهمة "قراءة نص قصير يوميًا".
///
/// النصوص الحالية مربوطة بالشهر الأول فقط ([monthId] = 'm1'). لإضافة
/// محتوى لباقي الأشهر، أنشئ قائمة جديدة داخل الخريطة [readingTextsByMonth]
/// باستخدام معرّف الشهر المناسب ('m2', 'm3', 'm4'...).
library;

import 'package:flutter/material.dart';

/// نص قراءة واحد مرتبط بشهر معيّن.
class ReadingText {
  /// معرّف تسلسلي ثابت (يستخدم للترتيب داخل الشهر).
  final int id;

  /// معرّف الشهر الذي ينتمي إليه النص (مثلاً 'm1', 'm2').
  /// يطابق قيمة [MonthData.id] في ملف `months_data.dart`.
  final String monthId;

  /// عنوان النص (اختياري لكن مفيد للقراءة السريعة).
  final String title;

  /// نص القراءة بالإنجليزية.
  final String content;

  /// ترجمة عربية كاملة للنص (اختياري لكن مفيد للمبتدئين).
  final String translation;

  const ReadingText({
    required this.id,
    required this.monthId,
    required this.title,
    required this.content,
    this.translation = '',
  });
}

// ============================================================
//  🟢 EDIT HERE — أضف نصوصاً جديدة هنا.
//
//  لإضافة نص للشهر الأول: أضف عنصراً جديداً في قائمة 'm1' أدناه.
//
//  لإضافة محتوى لشهر لاحق، أنشئ قائمة جديدة:
//    'm2': <ReadingText>[ ... ],
//
//  • اجعل النص قصيراً (3–6 جمل).
//  • حافظ على نفس الـ monthId المستخدم في months_data.dart.
//  • لا تكرر نفس الـ id داخل الشهر نفسه.
// ============================================================

const Map<String, List<ReadingText>> readingTextsByMonth = {
  // -------- الشهر الأول --------
  'm1': [
    ReadingText(
      id: 1,
      monthId: 'm1',
      title: 'A Good Morning',
      content:
          'Sara wakes up at seven. She drinks a glass of water. Then she '
          'brushes her teeth and gets dressed. She eats breakfast with her '
          'family. After breakfast, she goes to school. She smiles and says, '
          '"Good morning!" to her friends.',
      translation:
          'سارة تستيقظ في السابعة. تشرب كوباً من الماء. ثم تنظف أسنانها '
          'وترتدي ملابسها. تتناول الفطور مع عائلتها. بعد الفطور، تذهب إلى '
          'المدرسة. تبتسم وتقول لأصدقائها: "صباح الخير!"',
    ),
    ReadingText(
      id: 2,
      monthId: 'm1',
      title: 'My Family',
      content:
          'My family is small but happy. I have a father, a mother, and one '
          'brother. My father works in a hospital. My mother teaches at a '
          'school. My brother and I play football every weekend. We love '
          'spending time together.',
      translation:
          'عائلتي صغيرة لكن سعيدة. لدي أب وأم وأخ واحد. أبي يعمل في '
          'مستشفى. أمي تعلّم في مدرسة. أنا وأخي نلعب كرة القدم كل عطلة '
          'أسبوع. نحب أن نقضي الوقت معاً.',
    ),
    ReadingText(
      id: 3,
      monthId: 'm1',
      title: 'At the Coffee Shop',
      content:
          'Omar goes to a coffee shop every morning. He orders a cup of '
          'coffee and a small cake. He sits near the window and reads his '
          'book. Sometimes, he talks with the shop owner. He likes this '
          'quiet place very much.',
      translation:
          'عمر يذهب إلى مقهى كل صباح. يطلب كوب قهوة وكيكة صغيرة. يجلس '
          'بالقرب من النافذة ويقرأ كتابه. أحياناً يتحدث مع صاحب المقهى. '
          'يعجبه هذا المكان الهادئ كثيراً.',
    ),
    ReadingText(
      id: 4,
      monthId: 'm1',
      title: 'A Busy Day',
      content:
          'Today is a busy day for Hala. She wakes up early. She studies for '
          'two hours. Then she helps her mother at home. In the afternoon, '
          'she goes to her English class. In the evening, she watches a '
          'short movie. She goes to bed at ten.',
      translation:
          'اليوم يوم مزدحم لهالة. تستيقظ مبكراً. تدرس لساعتين. ثم تساعد '
          'أمها في البيت. بعد الظهر، تذهب إلى صفّها في اللغة الإنجليزية. '
          'في المساء، تشاهد فيلماً قصيراً. تذهب للنوم في العاشرة.',
    ),
    ReadingText(
      id: 5,
      monthId: 'm1',
      title: 'My Best Friend',
      content:
          'My best friend is Youssef. We met at school five years ago. He '
          'is kind and funny. We study together and play together. He always '
          'helps me when I have a problem. I am happy to have a friend like '
          'him.',
      translation:
          'صديقي المقرب هو يوسف. تعارفنا في المدرسة قبل خمس سنوات. هو '
          'طيب ومضحك. ندرس معاً ونلعب معاً. يساعدني دائماً عندما أواجه '
          'مشكلة. أنا سعيد أن لدي صديقاً مثله.',
    ),
    ReadingText(
      id: 6,
      monthId: 'm1',
      title: 'A Day at the Park',
      content:
          'On Friday, my family goes to the park. My sister rides her '
          'bicycle. My father walks with the dog. I sit on the grass and '
          'read a book. We eat sandwiches and drink juice. It is a beautiful '
          'day.',
      translation:
          'يوم الجمعة، عائلتي تذهب إلى الحديقة. أختي تركب دراجتها. أبي '
          'يمشي مع الكلب. أجلس على العشب وأقرأ كتاباً. نأكل سندويشات '
          'ونشرب عصيراً. إنه يوم جميل.',
    ),
    ReadingText(
      id: 7,
      monthId: 'm1',
      title: 'My Favorite Food',
      content:
          'My favorite food is pizza. I like it with cheese and vegetables. '
          'I eat pizza with my friends every Saturday. We always try a new '
          'restaurant. Pizza makes me happy.',
      translation:
          'طعامي المفضل هو البيتزا. أحبها بالجبن والخضار. آكل البيتزا مع '
          'أصدقائي كل سبت. دائماً نجرب مطعماً جديداً. البيتزا تجعلني '
          'سعيداً.',
    ),
  ],

  // 👇 أضف محتوى للشهور التالية عند الجاهزية:
  // 'm2': <ReadingText>[ ... ],
  // 'm3': <ReadingText>[ ... ],
  // 'm4': <ReadingText>[ ... ],
};

/// لون مميّز لأقسام القراءة داخل صفحة المهمة.
const Color readingAccent = Color(0xFFFCDCD7);

/// يرجّع قائمة النصوص الخاصة بشهر معيّن، أو قائمة فارغة عند عدم توفّر محتوى.
List<ReadingText> getReadingTextsForMonth(String monthId) {
  return readingTextsByMonth[monthId] ?? const <ReadingText>[];
}
