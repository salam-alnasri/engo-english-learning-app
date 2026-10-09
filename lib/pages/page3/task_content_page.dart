import 'package:engo/pages/page3/data/grammar_data.dart';
import 'package:engo/pages/page3/data/listening_data.dart';
import 'package:engo/pages/page3/data/reading_data.dart';
import 'package:engo/pages/page3/data/vocabulary_data.dart';
import 'package:engo/pages/page3/months_data.dart';
import 'package:flutter/material.dart';

/// صفحة محتوى المهمة: تعرض المحتوى المناسب حسب [task.type] ومعرّف
/// الشهر [monthId] (مهم لمحتوى القراءة لتصفية النصوص حسب الشهر).
///
/// بطاقات المهام تمرّر كلا المعطيين عبر [TaskCard] -> [TaskContentPage].
class TaskContentPage extends StatelessWidget {
  final TaskData task;

  /// معرّف الشهر الذي تنتمي إليه المهمة ('m1', 'm2'...).
  final String monthId;

  const TaskContentPage({super.key, required this.task, required this.monthId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          task.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        backgroundColor: task.color,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: task.color.withValues(alpha: 0.25),
        child: _buildBody(context),
      ),
    );
  }

  /// يختار المحتوى المناسب حسب نوع المهمة.
  Widget _buildBody(BuildContext context) {
    switch (task.type) {
      case TaskType.vocabulary:
        return _VocabularyList(words: vocabularyWords);
      case TaskType.grammar:
        return _GrammarList(lessons: grammarLessons);
      case TaskType.listening:
        return _ListeningList(exercises: listeningExercises);
      case TaskType.reading:
        return _ReadingList(
          texts: getReadingTextsForMonth(monthId),
          monthId: monthId,
        );
      // بقية الأنواع (conversation, fluency, review, immersion) ما زالت
      // placeholders — يمكن توسيعها لاحقاً بنفس النمط.
      default:
        return _PlaceholderBody(task: task);
    }
  }
}

// ============================================================
//  صفحة محتوى المفردات
// ============================================================

class _VocabularyList extends StatelessWidget {
  final List<VocabularyWord> words;

  const _VocabularyList({required this.words});

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return const _EmptyState(
        icon: Icons.style_rounded,
        title: 'لا توجد كلمات بعد',
        hint: 'أضف كلماتك في vocabulary_data.dart',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: words.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final w = words[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: vocabularyAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${w.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      w.english,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    w.arabic,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (w.pronunciation != null && w.pronunciation!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '🔊 ${w.pronunciation}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (w.example != null && w.example!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '✦ ${w.example}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
//  صفحة محتوى القواعد
// ============================================================

class _GrammarList extends StatelessWidget {
  final List<GrammarLesson> lessons;

  const _GrammarList({required this.lessons});

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return const _EmptyState(
        icon: Icons.description_rounded,
        title: 'لا توجد دروس بعد',
        hint: 'أضف دروساً في grammar_data.dart',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: lessons.length,
      separatorBuilder: (_, i) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final l = lessons[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: grammarAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'الدرس ${l.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l.explanation,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (l.examples.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'أمثلة:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                ...l.examples.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• $e',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
//  صفحة محتوى الاستماع (فارغة حالياً)
// ============================================================

class _ListeningList extends StatelessWidget {
  final List<ListeningExercise> exercises;

  const _ListeningList({required this.exercises});

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const _EmptyState(
        icon: Icons.headphones_rounded,
        title: 'لا توجد تمارين استماع بعد',
        hint:
            'هذا القسم جاهز لكن فارغ. أضف المحتوى في listening_data.dart\n'
            'وسيظهر هنا تلقائياً.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: exercises.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final ex = exercises[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ex.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
              if (ex.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  ex.description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
//  صفحة محتوى القراءة (نصوص قصيرة مفلترة حسب الشهر)
// ============================================================

class _ReadingList extends StatelessWidget {
  final List<ReadingText> texts;
  final String monthId;

  const _ReadingList({required this.texts, required this.monthId});

  @override
  Widget build(BuildContext context) {
    if (texts.isEmpty) {
      return _EmptyState(
        icon: Icons.menu_book_rounded,
        title: 'لا توجد نصوص لهذا الشهر بعد',
        hint:
            'لم يُضَف محتوى لشهر "$monthId" بعد.\n'
            'أضف نصوصاً في reading_data.dart داخل الخريطة '
            'readingTextsByMonth["$monthId"].',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: texts.length,
      separatorBuilder: (_, i) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        final t = texts[i];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: readingAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${t.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      t.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: readingAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'm1',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                t.content,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.7,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (t.translation.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: readingAccent.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🇸🇦 ${t.translation}',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.6,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
//  عناصر مساعدة مشتركة
// ============================================================

class _PlaceholderBody extends StatelessWidget {
  final TaskData task;
  const _PlaceholderBody({required this.task});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(task.icon, size: 64, color: Colors.black54),
            ),
            const SizedBox(height: 28),
            Text(
              task.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'أضف المحتوى الخاص بهذه المهمة هنا',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, size: 56, color: Colors.black38),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
