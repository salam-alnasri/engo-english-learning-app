import 'package:engo/data/lesson_repository.dart';
import 'package:engo/pages/page1/lesson2/lesson2.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:engo/pages/page1/roadmap/progress_service.dart';

class Lesson1Controller extends GetxController {
  final FlutterTts tts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxString currentWord = "".obs;
  RxString currentArabic = "".obs;
  List<Map<String, String>> options = [];
  RxInt correctIndex = (-1).obs;
  RxInt selectedIndex = (-1).obs;
  RxBool isAnswered = false.obs;
  RxBool isCorrect = false.obs;

  RxInt correctCount = 0.obs;
  RxInt wrongCount = 0.obs;
  RxInt currentQuestionNumber = 1.obs;

  final int maxWords = 5;
  RxBool isQuizCompleted = false.obs;

  late List<Map<String, String>> randomWords;
  int currentWordIndex = 0;

  /// حالة تحميل البيانات من ملف JSON.
  RxBool isLoading = true.obs;

  /// قائمة كاملة بكلمات المستوى الحالي (للخيارات الخاطئة أيضاً).
  List<Map<String, String>> levelWords = [];

  dynamic get progressController {
    try {
      return Get.find<dynamic>();
    } catch (e) {
      return null;
    }
  }

  final int groupIndex;
  final int levelIndex;
  Lesson1Controller({required this.groupIndex, required this.levelIndex});

  @override
  void onInit() {
    super.onInit();
    setupTts();
    _loadData();
  }

  /// تحميل البيانات من ملف JSON وتهيئة الأسئلة.
  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final int lesson = levelIndex + 1;
      final words = await LessonRepository.lesson1Words(lesson: lesson);

      // تخزين كل كلمات المستوى بصيغة Map للتوافق مع الكود الحالي
      levelWords = words
          .map((w) => w.toMap().map((k, v) => MapEntry(k, v?.toString() ?? '')))
          .toList();

      setupRandomWords();
      generateNewQuestion();
    } finally {
      isLoading.value = false;
    }
  }

  void setupTts() {
    tts.setLanguage('en-US');
    tts.setPitch(1.0);
    tts.setSpeechRate(0.4);
  }

  void setupRandomWords() {
    randomWords = List<Map<String, String>>.from(levelWords);
    randomWords.shuffle();
    randomWords = randomWords.take(maxWords).toList();
    currentWordIndex = 0;
  }

  void generateNewQuestion() {
    if (currentQuestionNumber.value > maxWords || randomWords.isEmpty) {
      isQuizCompleted.value = true;
      return;
    }

    final correctAnswer = randomWords[currentWordIndex];

    currentWord.value = correctAnswer["word"] ?? "";
    currentArabic.value = correctAnswer["ar"] ?? "";

    // خيارات خاطئة من نفس المستوى (بدون تكرار الكلمة الصحيحة)
    final availableOptions = levelWords
        .where((item) => item["word"] != correctAnswer["word"])
        .toList();

    availableOptions.shuffle();
    final wrongOptions = availableOptions.take(3).toList();

    options = [correctAnswer, ...wrongOptions]..shuffle();
    correctIndex.value = options.indexWhere(
      (item) => item["word"] == correctAnswer["word"],
    );

    selectedIndex.value = -1;
    isAnswered.value = false;
    isCorrect.value = false;

    Future.delayed(const Duration(seconds: 1), () {
      speakCurrentWord();
    });
  }

  Future<void> speakCurrentWord() async {
    try {
      await tts.stop();
      await tts.speak(currentWord.value);
    } catch (e) {}
  }

  Future<void> selectOption(int index) async {
    if (isAnswered.value || isQuizCompleted.value) return;

    selectedIndex.value = index;
    isAnswered.value = true;
    isCorrect.value = index == correctIndex.value;

    if (progressController != null) {
      progressController.addQuestion(isCorrect.value);
    }

    if (isCorrect.value) {
      correctCount.value++;
      try {
        await audioPlayer.play(AssetSource('sounds/correct.mp3'));
      } catch (e) {}
    } else {
      wrongCount.value++;
      try {
        await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      } catch (e) {}
    }

    await Future.delayed(const Duration(milliseconds: 2000));
    nextQuestion();
  }

  void nextQuestion() {
    currentQuestionNumber.value++;
    currentWordIndex++;

    if (currentQuestionNumber.value > maxWords ||
        currentWordIndex >= randomWords.length) {
      isQuizCompleted.value = true;
      showCompletionDialog();
    } else {
      generateNewQuestion();
    }
  }

  void showCompletionDialog() {
    // Save lesson 1 result for this stage
    ProgressService.setStageMistakes(levelIndex, wrongCount.value);
    ProgressService.markLessonCompleted(levelIndex, 0);
    Future.delayed(const Duration(milliseconds: 1000), () {
      goToA2();
    });
  }

  void goToA2() {
    // مرر نفس groupIndex و levelIndex للصفحة التالية إذا كانت تدعم ذلك
    Get.to(() => Lesson2(groupIndex: groupIndex, levelIndex: levelIndex));
  }

  void restart() {
    correctCount.value = 0;
    wrongCount.value = 0;
    currentQuestionNumber.value = 1;
    currentWordIndex = 0;
    isQuizCompleted.value = false;

    setupRandomWords();
    generateNewQuestion();
  }

  @override
  void onClose() {
    tts.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}
