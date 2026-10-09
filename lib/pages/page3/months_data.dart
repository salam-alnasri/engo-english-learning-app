import 'package:flutter/material.dart';

/// The kind of activity a [TaskData] represents.
///
/// Used by content pages to decide what UI sections to render.
enum TaskType {
  vocabulary,
  grammar,
  listening,
  reading,
  conversation,
  fluency,
  review,
  immersion,
}

/// A single task card shown inside a month's 2×2 grid.
class TaskData {
  /// Stable unique identifier.
  final String id;

  /// The Arabic sentence shown on the card.
  final String title;

  /// Material icon drawn on the left side of the card.
  final IconData icon;

  /// Background color of the card.
  final Color color;

  /// Logical task category.
  final TaskType type;

  const TaskData({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.type,
  });
}

/// One whole month block on the learning path.
class MonthData {
  /// Stable unique identifier.
  final String id;

  /// First line of the green banner, e.g. "الشهر الأول".
  final String title;

  /// Second line of the green banner, e.g. "بناء الأساس".
  final String subtitle;

  /// Emoji drawn on the right side of the banner.
  final String emoji;

  /// Exactly 4 tasks rendered in a 2×2 grid.
  final List<TaskData> tasks;

  const MonthData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.tasks,
  });
}

// ============================================================
//  🟢 EDIT HERE — Add more months to extend the learning path.
//
//  Every MonthData needs exactly 4 TaskData entries so the
//  2×2 grid stays balanced. You can reorder, edit titles, or
//  swap icons/colors freely.
// ============================================================

const List<MonthData> months = [
  // -------- الشهر 1 --------
  MonthData(
    id: 'm1',
    title: 'الشهر الأول',
    subtitle: 'بناء الأساس',
    emoji: '🧱',
    tasks: [
      TaskData(
        id: 'm1t1',
        title: 'تعلّم 500 كلمة شائعة.',
        icon: Icons.style_rounded,
        color: Color(0xFFD6EBFB), // أزرق فاتح
        type: TaskType.vocabulary,
      ),
      TaskData(
        id: 'm1t2',
        title: 'إنهاء أساسيات القواعد المهمة.',
        icon: Icons.description_rounded,
        color: Color(0xFFFCEDC1), // أصفر فاتح
        type: TaskType.grammar,
      ),
      TaskData(
        id: 'm1t3',
        title: '20 دقيقة استماع يوميًا.',
        icon: Icons.headphones_rounded,
        color: Color(0xFFE9DFFB), // بنفسجي فاتح
        type: TaskType.listening,
      ),
      TaskData(
        id: 'm1t4',
        title: 'قراءة نص قصير يوميًا.',
        icon: Icons.menu_book_rounded,
        color: Color(0xFFFCDCD7), // وردي فاتح
        type: TaskType.reading,
      ),
    ],
  ),
  // -------- الشهر 2 --------
  // MonthData(
  //   id: 'm2',
  //   title: 'الشهر الثاني',
  //   subtitle: 'بناء الأساس',
  //   emoji: '🧱',
  //   tasks: [
  //     TaskData(
  //       id: 'm1t1',
  //       title: 'تعلّم 500 كلمة شائعة اخرى.',
  //       icon: Icons.style_rounded,
  //       color: Color(0xFFD6EBFB), // أزرق فاتح
  //       type: TaskType.vocabulary,
  //     ),
  //     TaskData(
  //       id: 'm1t2',
  //       title: 'إنهاء أساسيات القواعد المهمة.',
  //       icon: Icons.description_rounded,
  //       color: Color(0xFFFCEDC1), // أصفر فاتح
  //       type: TaskType.grammar,
  //     ),
  //     TaskData(
  //       id: 'm1t3',
  //       title: '20 دقيقة استماع يوميًا.',
  //       icon: Icons.headphones_rounded,
  //       color: Color(0xFFE9DFFB), // بنفسجي فاتح
  //       type: TaskType.listening,
  //     ),
  //     TaskData(
  //       id: 'm1t4',
  //       title: 'قراءة نص قصير يوميًا.',
  //       icon: Icons.menu_book_rounded,
  //       color: Color(0xFFFCDCD7), // وردي فاتح
  //       type: TaskType.reading,
  //     ),
  //   ],
  // ),
  // -------- الشهر 3 --------
  // MonthData(
  //   id: 'm3',
  //   title: 'الشهر الثالث',
  //   subtitle: 'مرحلة الاحتراف',
  //   emoji: '🚀',
  //   tasks: [
  //     TaskData(
  //       id: 'm3t1',
  //       title: 'مشاهدة المحتوى بدون ترجمة عربية.',
  //       icon: Icons.play_circle_outline_rounded,
  //       color: Color(0xFFD6EBFB),
  //       type: TaskType.immersion,
  //     ),
  //     TaskData(
  //       id: 'm3t2',
  //       title: 'إجراء محادثات يومية.',
  //       icon: Icons.chat_bubble_rounded,
  //       color: Color(0xFFFCEDC1),
  //       type: TaskType.conversation,
  //     ),
  //     TaskData(
  //       id: 'm3t3',
  //       title: 'مراجعة جميع الكلمات السابقة.',
  //       icon: Icons.dashboard_rounded,
  //       color: Color(0xFFE9DFFB),
  //       type: TaskType.review,
  //     ),
  //     TaskData(
  //       id: 'm3t4',
  //       title: 'التركيز على الطلاقة والنطق.',
  //       icon: Icons.record_voice_over_rounded,
  //       color: Color(0xFFFCDCD7),
  //       type: TaskType.fluency,
  //     ),
  //   ],
  // ),

  // -------- الشهر 4 --------
  // MonthData(
  //   id: 'm4',
  //   title: 'الشهر الرابع',
  //   subtitle: 'مرحلة الاحتراف',
  //   emoji: '🚀',
  //   tasks: [
  //     TaskData(
  //       id: 'm4t1',
  //       title: 'مشاهدة المحتوى بدون ترجمة عربية.',
  //       icon: Icons.play_circle_outline_rounded,
  //       color: Color(0xFFD6EBFB),
  //       type: TaskType.immersion,
  //     ),
  //     TaskData(
  //       id: 'm4t2',
  //       title: 'إجراء محادثات يومية.',
  //       icon: Icons.chat_bubble_rounded,
  //       color: Color(0xFFFCEDC1),
  //       type: TaskType.conversation,
  //     ),
  //     TaskData(
  //       id: 'm4t3',
  //       title: 'مراجعة جميع الكلمات السابقة.',
  //       icon: Icons.dashboard_rounded,
  //       color: Color(0xFFE9DFFB),
  //       type: TaskType.review,
  //     ),
  //     TaskData(
  //       id: 'm4t4',
  //       title: 'التركيز على الطلاقة والنطق.',
  //       icon: Icons.record_voice_over_rounded,
  //       color: Color(0xFFFCDCD7),
  //       type: TaskType.fluency,
  //     ),
  //   ],
  // ),
];
