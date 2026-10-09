import 'package:engo/pages/page2/level_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _titleColor = Color(0xFF343A40);
const Color _mutedColor = Color(0xFF868E96);

/// بطاقة قصة قصيرة داخل صفحة المستوى.
///
/// تُعرض القصص واحدة فوق الأخرى، وكل بطاقة تُظهر:
/// رقم القصة، عنوانها بالإنجليزية بشكل واضح، عنوانها بالعربية،
/// وعدد الكلمات التي تحتويها القصة، مع شارة "تمت القراءة" عند إكمالها.
class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.text,
    required this.color,
    required this.number,
    required this.read,
    required this.onTap,
  });

  final ReadingText text;
  final Color color;

  /// رقم القصة داخل المستوى (يبدأ من 1).
  final int number;

  /// هل أنجز المستخدم قراءة هذه القصة؟
  final bool read;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withValues(alpha: read ? .55 : .22),
            width: read ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .1),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StoryNumber(number: number, color: color, read: read),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان القصة بالإنجليزية — واضح وبارز.
                    Text(
                      text.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _titleColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text.titleAr,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        color: _mutedColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _StoryMetaRow(text: text, color: color, read: read),
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

/// صف المعلومات أسفل عنوان القصة: عدد الكلمات + عدد الفقرات + حالة القراءة.
class _StoryMetaRow extends StatelessWidget {
  const _StoryMetaRow({
    required this.text,
    required this.color,
    required this.read,
  });

  final ReadingText text;
  final Color color;
  final bool read;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      // عدد الكلمات في القصة.
      _MetaChip(
        color: color,
        icon: Icons.text_fields_rounded,
        label: text.wordCountLabel,
        highlighted: true,
      ),
      const SizedBox(width: 6),
      _MetaChip(
        color: _mutedColor,
        icon: Icons.segment_rounded,
        label: '${text.paragraphsCount} فقرة',
        highlighted: false,
      ),
      const Spacer(),
      if (read)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              'تمت القراءة',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        )
      else
        const Icon(Icons.chevron_left_rounded, color: Color(0xFFCED4DA)),
    ],
  );
}

/// شريحة صغيرة تُظهر معلومة واحدة عن القصة.
class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.color,
    required this.icon,
    required this.label,
    required this.highlighted,
  });

  final Color color;
  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: highlighted
          ? color.withValues(alpha: .12)
          : const Color(0xFFF1F3F5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: highlighted ? FontWeight.w800 : FontWeight.w700,
            color: color,
          ),
        ),
      ],
    ),
  );
}

/// رقم القصة داخل مربّع ملوّن بجانب العنوان.
class _StoryNumber extends StatelessWidget {
  const _StoryNumber({
    required this.number,
    required this.color,
    required this.read,
  });

  final int number;
  final Color color;
  final bool read;

  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color.withValues(alpha: read ? 1 : .85),
          color.withValues(alpha: .7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      '$number',
      style: GoogleFonts.fredoka(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}
