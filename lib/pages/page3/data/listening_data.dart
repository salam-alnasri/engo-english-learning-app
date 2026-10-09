/// نموذج بيانات الاستماع — مرتبط بمهمة "20 دقيقة استماع يومياً".
///
/// النموذج جاهز لكن القائمة فارغة عمداً. عند توفّر المحتوى (روابط صوتية،
/// نصوص استماع، تمارين...) أضف العناصر داخل [listeningExercises] بنفس
/// البنية وسيتم عرضها تلقائياً في صفحة المهمة.
library;

import 'package:flutter/material.dart';

/// عنصر استماع واحد (حلقة بودكاست، مقطع فيديو، مقال صوتي...).
class ListeningExercise {
  /// معرّف تسلسلي ثابت.
  final int id;

  /// عنوان العنوان المعروض للمستخدم.
  final String title;

  /// وصف مختصر للمحتوى.
  final String description;

  /// رابط المقطع (YouTube, Spotify, ملف صوتي محلي...).
  final String? sourceUrl;

  /// المدة التقريبية بالدقائق (اختياري).
  final int? durationMinutes;

  const ListeningExercise({
    required this.id,
    required this.title,
    this.description = '',
    this.sourceUrl,
    this.durationMinutes,
  });
}

// ============================================================
//  🟢 EDIT HERE — أضف تمارين/مقاطع الاستماع هنا.
//
//  اترك القائمة فارغة عمداً الآن. عند الجاهزية أضف العناصر بهذا الشكل:
//
//    ListeningExercise(
//      id: 1,
//      title: 'حلقة 1: التحيات اليومية',
//      description: 'استمع لمحادثة قصيرة عن التحيات.',
//      sourceUrl: 'https://...',
//      durationMinutes: 5,
//    ),
// ============================================================

const List<ListeningExercise> listeningExercises = [
  // 👇 أضف المحتوى هنا لاحقاً.
];

/// لون مميّز لأقسام الاستماع داخل صفحة المهمة.
const Color listeningAccent = Color(0xFFE9DFFB);