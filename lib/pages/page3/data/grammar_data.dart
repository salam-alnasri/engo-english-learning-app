/// نموذج بيانات القواعد — مرتبط بمهمة "إنهاء أساسيات القواعد المهمة".
///
/// يحتوي هذا الملف على أهم القواعد الأساسية كبداية. أضف دروساً جديدة
/// عبر توسيع القائمة [grammarLessons] بنفس البنية.
library;

import 'package:flutter/material.dart';

/// درس قواعد واحد.
class GrammarLesson {
  /// معرّف تسلسلي ثابت للدرس.
  final int id;

  /// عنوان الدرس (بالعربية).
  final String title;

  /// شرح موجز للقاعدة.
  final String explanation;

  /// قائمة أمثلة تطبيقية (كل عنصر جملة كاملة).
  final List<String> examples;

  const GrammarLesson({
    required this.id,
    required this.title,
    required this.explanation,
    this.examples = const [],
  });
}

// ============================================================
//  🟢 EDIT HERE — أضف دروس قواعد جديدة هنا.
//
//  • أبقِ الـ id تسلسلياً.
//  • اجعل الشرح قصيراً وواضحاً.
//  • ضع 2–4 أمثلة لكل درس.
// ============================================================

const List<GrammarLesson> grammarLessons = [
  GrammarLesson(
    id: 1,
    title: 'الفعل "to be" في المضارع',
    explanation:
        'يُستخدم الفعل "to be" للتعبير عن الحالة أو الصفة. يتغير حسب الفاعل: '
        'I am, You are, He/She/It is, We are, They are.',
    examples: [
      'I am a student.',
      'She is happy today.',
      'They are my friends.',
    ],
  ),
  GrammarLesson(
    id: 2,
    title: 'المضارع البسيط',
    explanation:
        'يُستخدم للتعبير عن عادات وحقائق. مع الفاعل He/She/It نضيف s أو es '
        'للفعل، ومع باقي الفاعلين يبقى الفعل كما هو.',
    examples: [
      'I play football every Friday.',
      'He plays football every Friday.',
      'We study English every day.',
    ],
  ),
  GrammarLesson(
    id: 3,
    title: 'الماضي البسيط',
    explanation:
        'يُستخدم للحديث عن أحداث انتهت في الماضي. تُضاف ed إلى الأفعال '
        'المنتظمة، أما الشاذة فتحفظ كما هي (go → went, eat → ate).',
    examples: [
      'I visited my grandfather yesterday.',
      'She watched a movie last night.',
      'They went to school by bus.',
    ],
  ),
  GrammarLesson(
    id: 4,
    title: 'أدوات النكرة والتعريف',
    explanation:
        'a / an تُستخدمان قبل أسماء مفردة غير محددة (a قبل الصوت الساكن، '
        'an قبل الصوت الصائت). the تُستخدم عند الحديث عن شيء محدد معروف.',
    examples: [
      'I saw a cat in the garden.',
      'She is an engineer.',
      'The book on the table is mine.',
    ],
  ),
  GrammarLesson(
    id: 5,
    title: 'الضمائر الشخصية',
    explanation:
        'ضمائر الفاعل: I, you, he, she, it, we, they. '
        'ضمائر المفعول: me, you, him, her, it, us, them.',
    examples: [
      'He helps me every day.',
      'I called them last night.',
      'She is talking to him now.',
    ],
  ),
  GrammarLesson(
    id: 6,
    title: 'الجمع مع can / cannot',
    explanation:
        'can تُستخدم للتعبير عن القدرة أو السماح. cannot (can\'t) للنفي. '
        'لا تتغير can حسب الفاعل.',
    examples: [
      'I can swim very well.',
      'She can speak three languages.',
      'They cannot come today.',
    ],
  ),
  // 👇 أضف دروساً إضافية هنا:
  // GrammarLesson(id: 7, title: '...', explanation: '...', examples: [...]),
];

/// لون مميّز لأقسام القواعد داخل صفحة المهمة.
const Color grammarAccent = Color(0xFFFCEDC1);