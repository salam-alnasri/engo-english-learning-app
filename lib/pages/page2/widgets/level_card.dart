import 'package:engo/pages/page2/level_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _titleColor = Color(0xFF343A40);
const Color _mutedColor = Color(0xFF868E96);

/// بطاقة مستوى أفقيّة واحدة، تُعرض فوق البطاقة التالية مباشرة.
///
/// تحتوي على: رمز المستوى (A1 .. C2)، رقم ترتيب البطاقة، اسم المستوى،
/// وصفه المختصر، عدد القصص، شريط التقدّم ونسبة الإكمال.
class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.order,
    required this.readCount,
    required this.progress,
    required this.onTap,
  });

  final CefrLevel level;

  /// رقم ترتيب المستوى في القائمة (يبدأ من 1 لِـ A1).
  final int order;

  /// عدد القصص التي أكمل المستخدم قراءتها في هذا المستوى.
  final int readCount;

  /// نسبة التقدّم (0 .. 1).
  final double progress;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = level.texts.length;
    final isCompleted = total > 0 && readCount >= total;
    final percent = (progress * 100).round();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: level.color.withValues(alpha: isCompleted ? .6 : .28),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: level.color.withValues(alpha: .12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LevelBadge(level: level, order: order),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TitleRow(level: level, isCompleted: isCompleted),
                      const SizedBox(height: 4),
                      // Text(
                      //   level.descriptionAr,
                      //   textDirection: TextDirection.rtl,
                      //   textAlign: TextAlign.right,
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: GoogleFonts.cairo(
                      //     fontSize: 12.5,
                      //     height: 1.5,
                      //     color: _mutedColor,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.end,
                        children: [
                          InfoChip(
                            color: level.color,
                            icon: Icons.auto_stories_rounded,
                            label: '$total قصة',
                          ),
                          InfoChip(
                            color: level.color,
                            icon: isCompleted
                                ? Icons.emoji_events_rounded
                                : Icons.timelapse_rounded,
                            label: isCompleted
                                ? 'مكتمل $percent%'
                                : 'التقدّم $percent%',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          backgroundColor: level.color.withValues(alpha: .14),
                          color: level.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'تمت قراءة $readCount من $total',
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.cairo(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: level.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// مربّع رمز المستوى (A1 .. C2) مع رقم ترتيبه في القائمة.
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level, required this.order});

  final CefrLevel level;
  final int order;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 58,
        height: 58,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [level.color, level.color.withValues(alpha: .75)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: level.color.withValues(alpha: .35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          level.code,
          style: GoogleFonts.fredoka(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'المستوى $order',
        textDirection: TextDirection.rtl,
        style: GoogleFonts.cairo(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: _mutedColor,
        ),
      ),
    ],
  );
}

/// اسم المستوى مع أيقونته وعلامة الإكمال.
class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.level, required this.isCompleted});

  final CefrLevel level;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(level.icon, size: 18, color: level.color),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          level.nameAr,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: _titleColor,
          ),
        ),
      ),
      if (isCompleted)
        Icon(Icons.verified_rounded, size: 20, color: level.color)
      else
        const Icon(Icons.chevron_left_rounded, color: Color(0xFFCED4DA)),
    ],
  );
}

/// شريحة معلومات صغيرة داخل بطاقة المستوى.
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}
