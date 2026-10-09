import 'package:engo/data/lesson_repository.dart';
import 'package:engo/pages/page1/lesson3/lesson3.dart';
import 'package:engo/pages/page1/roadmap/progress_service.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class Lesson2Controller extends GetxController {
  final int groupIndex;
  final int levelIndex;
  final FlutterTts tts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  List<Map<String, dynamic>> currentWords = [];
  List<Map<String, dynamic>> leftColumn = [];
  List<Map<String, dynamic>> rightColumn = [];

  RxInt selectedLeft = (-1).obs;
  RxInt selectedRight = (-1).obs;
  RxInt correctMatches = 0.obs;
  RxInt totalAttempts = 0.obs;
  RxBool isProcessing = false.obs;

  RxInt wrongLeft = (-1).obs;
  RxInt wrongRight = (-1).obs;

  List<int> matchedLeft = [];
  List<int> matchedRight = [];

  /// حالة تحميل البيانات من ملف JSON.
  RxBool isLoading = true.obs;

  Future<void> _flushSelectionUi() async {
    update();
    await Future.delayed(const Duration(milliseconds: 60));
  }

  Lesson2Controller({required this.groupIndex, required this.levelIndex});

  @override
  void onInit() {
    super.onInit();
    setupTts();
    _loadData();
  }

  /// تحميل البيانات من ملف JSON وتهيئة الجولة.
  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final int lesson = levelIndex + 1;
      final pairs = await LessonRepository.lesson2Pairs(lesson: lesson);
      generateNewRound(pairs);
    } finally {
      isLoading.value = false;
    }
  }

  void setupTts() {
    tts.setLanguage('en-US');
    tts.setPitch(1.0);
    tts.setSpeechRate(0.4);
  }

  void generateNewRound([List<Lesson2Pair>? pairs]) {
    // تصفية البيانات حسب مستوى الصعوبة (levelIndex + 1)
    final source = (pairs ?? <Lesson2Pair>[]).toList();
    final filtered = source..shuffle();
    currentWords = filtered.take(7).map((p) => p.toMap()).toList();

    // العمود الأيسر: كلمات إنكليزية، العمود الأيمن: كلمات عربية
    leftColumn = List<Map<String, dynamic>>.from(currentWords)..shuffle();
    rightColumn = List<Map<String, dynamic>>.from(currentWords)..shuffle();

    selectedLeft.value = -1;
    selectedRight.value = -1;
    wrongLeft.value = -1;
    wrongRight.value = -1;
    matchedLeft.clear();
    matchedRight.clear();
    correctMatches.value = 0;
    totalAttempts.value = 0;
  }

  Future<void> playPhonetic(int index) async {
    if (matchedLeft.contains(index)) return;

    try {
      await tts.stop();
      await tts.speak(leftColumn[index]["en"]!);
    } catch (e) {}
  }

  Future<void> selectLeftWord(int index) async {
    if (matchedLeft.contains(index) || isProcessing.value) return;

    selectedLeft.value = index;
    wrongLeft.value = -1;
    wrongRight.value = -1;
    await _flushSelectionUi();
    await playPhonetic(index);

    if (selectedRight.value != -1) {
      await checkMatch();
    }
  }

  Future<void> selectRightWord(int index) async {
    if (matchedRight.contains(index) || isProcessing.value) return;

    selectedRight.value = index;
    wrongLeft.value = -1;
    wrongRight.value = -1;
    await _flushSelectionUi();

    if (selectedLeft.value != -1) {
      await checkMatch();
    }
  }

  Future<void> checkMatch() async {
    if (selectedLeft.value == -1 || selectedRight.value == -1) return;

    isProcessing.value = true;
    totalAttempts.value++;

    final leftWord = leftColumn[selectedLeft.value]["en"];
    final rightWord = rightColumn[selectedRight.value]["ar"];

    // تحقق من التطابق بين الكلمة الإنجليزية والترجمة العربية
    final correctAr = currentWords.firstWhere(
      (item) => item['en'] == leftWord,
    )['ar'];

    if (rightWord == correctAr) {
      correctMatches.value++;
      matchedLeft.add(selectedLeft.value);
      matchedRight.add(selectedRight.value);
      wrongLeft.value = -1;
      wrongRight.value = -1;

      // Clear current pair selection so the next tap starts a new pair.
      selectedLeft.value = -1;
      selectedRight.value = -1;

      try {
        await audioPlayer.play(AssetSource('sounds/correct.mp3'));
      } catch (e) {}

      if (matchedLeft.length == currentWords.length) {
        await Future.delayed(const Duration(milliseconds: 1000));
        ProgressService.markLessonCompleted(levelIndex, 1);
        // الانتقال مباشرة إلى صفحة A3 مع تمرير المؤشرات
        Get.offAll(
          () => const Lesson3(),
          arguments: {'groupIndex': groupIndex, 'levelIndex': levelIndex},
        );
        return;
      }
    } else {
      wrongLeft.value = selectedLeft.value;
      wrongRight.value = selectedRight.value;

      try {
        await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      } catch (e) {}

      await Future.delayed(const Duration(milliseconds: 500));
      selectedLeft.value = -1;
      selectedRight.value = -1;
      wrongLeft.value = -1;
      wrongRight.value = -1;
    }

    isProcessing.value = false;
  }

  @override
  void onClose() {
    tts.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}