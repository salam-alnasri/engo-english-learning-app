import 'package:engo/widgets/bottom_nav_bar.dart';
import 'package:engo/data/lesson_repository.dart';
import 'package:engo/data/listening_data.dart';
import 'package:engo/pages/page1/roadmap/progress_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class Lesson3Controller extends GetxController {
  final int groupIndex;
  final int levelIndex;
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxInt currentIndex = 0.obs;
  RxList<String> selectedWords = <String>[].obs;
  RxBool isCorrect = false.obs;
  RxBool checked = false.obs;
  RxBool readyForNext = false.obs;

  /// حالة تحميل البيانات من ملف JSON.
  RxBool isLoading = true.obs;

  /// الجمل الخاص بناّت بالمرحلة الحالية (مُحمَّلة من LessonRepository).
  List<ListeningItem> sentences = [];

  Lesson3Controller({required this.groupIndex, required this.levelIndex});

  /// الترجمة العربية للجملة الحالية.
  String get currentArabicTranslation {
    if (currentIndex.value >= sentences.length) return '';
    return sentences[currentIndex.value].translation;
  }

  @override
  void onInit() {
    super.onInit();
    flutterTts.setLanguage("en-US");
    _loadData();
  }

  /// تحميل البيانات من ملف JSON وتحويلها إلى ListeningItem
  /// للحفاظ على توافق واجهة المستخدم.
  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final int lesson = levelIndex + 1;
      final items = await LessonRepository.lesson3Sentences(lesson: lesson);

      // تحويل إلى ListeningItem للتوافق مع باقي الكود (UI يعتمد عليه).
      sentences = items
          .map((s) => ListeningItem(
                lesson: s.lesson,
                sentence: s.sentence,
                options: s.options,
                translation: s.translation,
              ))
          .toList();
    } finally {
      isLoading.value = false;
    }

    // نطق أول جملة بعد التحميل
    if (sentences.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 400), () {
        speakSentence();
      });
    }
  }

  Future<void> speakSentence() async {
    if (sentences.isEmpty) return;
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(sentences[currentIndex.value].sentence);
  }

  Future<void> speakSentenceslow() async {
    if (sentences.isEmpty) return;
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(sentences[currentIndex.value].sentence);
  }

  /// ينطق كلمة فردية عند الضغط عليها من قائمة الخيارات.
  /// يُستخدم لمساعدة المتعلم على سماع الكلمة قبل اختيارها.
  Future<void> speakWord(String word) async {
    if (word.isEmpty) return;
    await flutterTts.stop();
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(word);
  }

  Future<void> playResultSound(bool correct) async {
    await audioPlayer.stop();
    await audioPlayer.play(
      AssetSource(correct ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'),
    );
  }

  void goToNextQuestion() async {
    if (sentences.isEmpty) {
      Get.offAll(() => BottomNavBar());
      return;
    }

    if (currentIndex.value < sentences.length - 1) {
      currentIndex.value++;
      selectedWords.clear();
      checked.value = false;
      isCorrect.value = false;
      readyForNext.value = false;
      await speakSentence();
    } else {
      ProgressService.markLessonCompleted(levelIndex, 2);
      // عند الانتهاء من جميع الأسئلة، العودة للرئيسية
      Get.offAll(() => BottomNavBar());
    }
  }

  void checkAnswer() async {
    if (sentences.isEmpty) return;

    // Normalize both user answer and correct answer: remove punctuation, trim, and lowercase
    String normalize(String s) => s
        .replaceAll(RegExp(r'[.,!?]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();

    final userAnswer = normalize(selectedWords.join(' '));
    final correctAnswer = normalize(sentences[currentIndex.value].sentence);
    final correct = userAnswer == correctAnswer;
    isCorrect.value = correct;
    checked.value = true;
    await playResultSound(correct);

    if (correct) {
      Get.snackbar(
        'ممتاز!',
        'إجابة صحيحة',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
      );
      readyForNext.value = true;
    } else {
      Get.snackbar(
        'غير صحيح!',
        'حاول مرة أخرى',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
  }
}