import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _titleColor = Color(0xFF343A40);
const Color _mutedColor = Color(0xFF868E96);

/// صندوق فقرة واحدة من القصة داخل مربّع حوار ملوّن بلون المستوى.
/// الضغط على الصندوق يُنطق الفقرة (يُمرّره المتحكم عبر onTap).
class ReadingDialogBox extends StatelessWidget {
  const ReadingDialogBox({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final Color color;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: .25)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote_rounded, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  height: 1.7,
                  color: _titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// صندوق المفردات المهمة في القصة (لا يظهر إذا لم تكن هناك مفردات).
class VocabBox extends StatelessWidget {
  const VocabBox({
    super.key,
    required this.color,
    required this.vocab,
    required this.onSpeak,
  });

  final Color color;

  /// كل عنصر = [الكلمة بالإنجليزية, المعنى بالعربية].
  final List<List<String>> vocab;

  /// يُستدعى عند الضغط على زر النطق بجوار الكلمة.
  final void Function(String word) onSpeak;

  String _wordAt(int index) => vocab[index].isNotEmpty ? vocab[index][0] : '';

  String _meaningAt(int index) =>
      vocab[index].length > 1 ? vocab[index][1] : '';

  @override
  Widget build(BuildContext context) {
    if (vocab.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.menu_book_rounded, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              'مفردات مهمة',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.cairo(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: _titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: .18)),
          ),
          child: Column(
            children: [
              for (var index = 0; index < vocab.length; index++) ...[
                if (index > 0)
                  Divider(height: 10, color: color.withValues(alpha: .12)),
                _VocabRow(
                  color: color,
                  word: _wordAt(index),
                  meaning: _meaningAt(index),
                  onTap: () => onSpeak(_wordAt(index)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// سطر واحد من المفردات: الكلمة + المعنى + زر النطق.
class _VocabRow extends StatelessWidget {
  const _VocabRow({
    required this.color,
    required this.word,
    required this.meaning,
    required this.onTap,
  });

  final Color color;
  final String word;
  final String meaning;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(Icons.volume_up_rounded, size: 17, color: color),
        ),
      ),
      const SizedBox(width: 4),
      Text(
        word,
        style: GoogleFonts.fredoka(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          meaning,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(fontSize: 13.5, color: _titleColor),
        ),
      ),
    ],
  );
}

/// تظهر عند عدم وجود قصص مضافة للمستوى بعد.
class EmptyLevelState extends StatelessWidget {
  const EmptyLevelState({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_stories_rounded,
            size: 86,
            color: Color(0xFFCED4DA),
          ),
          const SizedBox(height: 14),
          Text(
            'لا توجد قصص لهذا المستوى بعد',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'سيتم إضافة القصص قريبًا.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(fontSize: 14, color: _mutedColor),
          ),
        ],
      ),
    ),
  );
}

/// ملاحظة إرشادية في نهاية شاشة قراءة القصة.
class ReadingFooterNote extends StatelessWidget {
  const ReadingFooterNote({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 4),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF93987c),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lightbulb_rounded, color: Color(0xFF93987c), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'اقرأ القصة بتركيز، وافهم المفردات قبل الانتقال، ثم اضغط "أكملت القراءة" ليعرف التطبيق أنك أنهيت هذه القصة.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              fontSize: 13,
              height: 1.6,
              color: const Color(0xFF283618),
            ),
          ),
        ),
      ],
    ),
  );
}
