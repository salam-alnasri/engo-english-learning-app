import 'dart:math';

import 'package:flutter/material.dart';

class LessonExitDialog {
  static final Random _random = Random();

  static const List<IconData> _coachIcons = [
    Icons.emoji_people,
    Icons.sentiment_very_satisfied,
    Icons.face,
    Icons.support_agent,
    Icons.psychology,
    Icons.school,
    Icons.record_voice_over,
  ];

  static const List<String> _messages = [
    'انتظر قليلًا، بقيت خطوة صغيرة وتكمل الدرس.',
    'أنت قريب جدًا من الهدف، تابع التعلم الآن.',
    'دقيقة إضافية منك تصنع فرقًا كبيرًا.',
    'رائع أنك وصلت لهنا، لا تتوقف الآن.',
    'باقي جزء بسيط فقط، أكمل وافتخر بإنجازك.',
    'تعلمك مستمر وجميل، أعطِ نفسك فرصة أخيرة الآن.',
    'أحسنت، بقي القليل لتُنهي هذا الدرس بنجاح.',
  ];

  static Future<bool> show(
    BuildContext context, {
    required VoidCallback onExit,
  }) async {
    final icon = _coachIcons[_random.nextInt(_coachIcons.length)];
    final message = _messages[_random.nextInt(_messages.length)];

    final shouldExit =
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (dialogContext) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal.shade50,
                    child: Icon(icon, color: Colors.teal),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('قبل المغادرة', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              content: Text(
                message,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('تابع التعلم'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('خروج'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (shouldExit) {
      onExit();
    }

    return shouldExit;
  }
}
