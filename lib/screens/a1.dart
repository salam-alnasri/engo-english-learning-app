import 'package:engo/data/a1_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

class A1Q1Controller extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Map<String, String>> allWords = a1data;

  RxList<Map<String, String>> remainingWords = <Map<String, String>>[].obs;
  RxInt correctCount = 0.obs;
  RxInt wrongCount = 0.obs;
  RxInt totalAnswered = 0.obs;

  Rxn<Map<String, String>> currentWord = Rxn<Map<String, String>>();
  RxList<String> currentOptions = <String>[].obs;
  RxnInt correctOptionIndex = RxnInt();
  RxnInt selectedOptionIndex = RxnInt();
  RxnBool isCorrectSelection = RxnBool();
  RxBool showOptions = false.obs;
  RxBool isFlashing = false.obs;
  RxBool isLoading = true.obs;
  RxBool started = false.obs;

  late AnimationController controller;
  late Animation<double> fadeAnimation;

  final AudioPlayer audioPlayer = AudioPlayer();

  // إضافة متغير tts
  final FlutterTts tts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    controller = AnimationController(
      vsync: Get.find<GetTickerProvider>(),
      duration: const Duration(milliseconds: 1000),
    );
    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    // تهيئة tts
    tts.setLanguage('en-US');
    tts.setPitch(1.0);
    tts.setSpeechRate(0.45);
    _loadProgress();
  }

  @override
  void onClose() {
    controller.dispose();
    tts.stop(); // إيقاف النطق عند الإغلاق
    super.onClose();
  }

  Future<void> speakCurrentWord() async {
    final word = currentWord.value?["en"];
    if (word != null && word.isNotEmpty) {
      await tts.stop();
      await tts.speak(word);
    }
  }

  Future<void> _loadProgress() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    correctCount.value = prefs.getInt('a1q1_correct') ?? 0;
    wrongCount.value = prefs.getInt('a1q1_wrong') ?? 0;
    totalAnswered.value = prefs.getInt('a1q1_total') ?? 0;
    List<String> doneWords = prefs.getStringList('a1q1_doneWords') ?? [];
    remainingWords.value = allWords
        .where((w) => !doneWords.contains(w["en"]))
        .toList();

    // عند الدخول لأول مرة أو عند العودة، أظهر زر ابدأ
    started.value = false;
    isLoading.value = false;
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('a1q1_correct', correctCount.value);
    prefs.setInt('a1q1_wrong', wrongCount.value);
    prefs.setInt('a1q1_total', totalAnswered.value);
    List<String> doneWords = allWords
        .where((w) => !remainingWords.contains(w))
        .map((w) => w["en"]!)
        .toList();
    prefs.setStringList('a1q1_doneWords', doneWords);
  }

  void showNextWord({bool animate = true}) async {
    if (remainingWords.isEmpty) {
      currentWord.value = null;
      showOptions.value = false;
      _saveProgress();
      return;
    }
    _prepareNextWord(animate: animate);
    _saveProgress();
    // نطق الكلمة الجديدة تلقائياً
    await speakCurrentWord();
  }

  void _prepareNextWord({bool animate = true}) {
    currentWord.value = (remainingWords..shuffle()).first;
    List<String> wrongOptions =
        allWords
            .where((w) => w["ar"] != currentWord.value!["ar"])
            .map((w) => w["ar"]!)
            .toList()
          ..shuffle();
    currentOptions.value = [
      currentWord.value!["ar"]!,
      wrongOptions[0],
      wrongOptions[1],
      wrongOptions[2],
    ]..shuffle();
    correctOptionIndex.value = currentOptions.indexOf(
      currentWord.value!["ar"]!,
    );
    selectedOptionIndex.value = null;
    isCorrectSelection.value = null;
    showOptions.value = true;
    isFlashing.value = false;
    if (animate) {
      controller.forward(from: 0);
    }
  }

  Future<void> handleOptionTap(int index) async {
    if (isFlashing.value) return;
    selectedOptionIndex.value = index;
    isCorrectSelection.value = (index == correctOptionIndex.value);
    isFlashing.value = true;

    // تشغيل الصوت المناسب
    if (isCorrectSelection.value == true) {
      await audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    totalAnswered.value++;
    if (isCorrectSelection.value!) {
      correctCount.value++;
    } else {
      wrongCount.value++;
    }
    remainingWords.remove(currentWord.value);
    isFlashing.value = false;

    await controller.reverse();
    showNextWord();
  }

  Future<void> restart() async {
    correctCount.value = 0;
    wrongCount.value = 0;
    totalAnswered.value = 0;
    remainingWords.value = List.from(allWords);
    await _saveProgress();
    started.value = true;
    showNextWord();
  }
}

// مزود للـ vsync مع GetX
class GetTickerProvider extends GetxController
    with GetSingleTickerProviderStateMixin {}

class A1 extends StatelessWidget {
  const A1({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<GetTickerProvider>()) {
      Get.put(GetTickerProvider());
    }
    final A1Q1Controller c = Get.put(A1Q1Controller(), permanent: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ما عدد الكلمات التي تعرفها؟'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Obx(() {
          // إذا كان التحميل جارياً، أظهر مؤشر تحميل
          if (c.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // إذا لم يتم تعيين currentWord بعد، اعرض أول سؤال مباشرة
          if (c.currentWord.value == null && c.remainingWords.isNotEmpty) {
            // هذا السطر سيعرض أول سؤال تلقائياً بدون شاشة بيضاء
            WidgetsBinding.instance.addPostFrameCallback((_) {
              c.showNextWord();
            });
            // أثناء انتظار تعيين currentWord، أظهر مؤشر تحميل صغير
            return const Center(child: CircularProgressIndicator());
          }

          // ...باقي الكود كما هو (عرض السؤال والخيارات)...
          return Column(
            children: [
              Obx(() {
                final total = c.allWords.isEmpty
                    ? 1.0
                    : c.allWords.length.toDouble();
                final correctFraction =
                    (c.correctCount.value.toDouble() / total).clamp(0.0, 1.0);
                final wrongFraction = (c.wrongCount.value.toDouble() / total)
                    .clamp(0.0, 1.0);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Combined bar: green from left, red from right, gray background
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // green (correct) grows from left
                          FractionallySizedBox(
                            widthFactor: correctFraction,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(
                                    correctFraction == 1.0 ? 8 : 0,
                                  ),
                                  bottomRight: Radius.circular(
                                    correctFraction == 1.0 ? 8 : 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // red (wrong) grows from right
                          FractionallySizedBox(
                            widthFactor: wrongFraction,
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                  topLeft: Radius.circular(
                                    wrongFraction == 1.0 ? 8 : 0,
                                  ),
                                  bottomLeft: Radius.circular(
                                    wrongFraction == 1.0 ? 8 : 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Counts and small legends
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${c.correctCount.value} صحيح',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${c.wrongCount.value} خاطئ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              }),

              if (c.remainingWords.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'انتهت جميع الكلمات!\nإجابات صحيحة: ${c.correctCount.value}\nإجابات خاطئة: ${c.wrongCount.value}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(
                  child: FadeTransition(
                    opacity: c.fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // دائرة رقم الكلمة فوق الكلمة
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.teal,
                            child: Obx(
                              () => Text(
                                '${c.correctCount.value + c.wrongCount.value + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // الكلمة الإنجليزية مع زر صوتي
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.teal, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  c.currentWord.value?["en"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              IconButton(
                                icon: const Icon(Icons.volume_up, size: 32),
                                onPressed: () {
                                  c.speakCurrentWord();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // خيارات عربية
                        Obx(
                          () => Column(
                            children: List.generate(4, (i) {
                              Color? color;
                              if (c.selectedOptionIndex.value == i &&
                                  c.isFlashing.value) {
                                color = (c.isCorrectSelection.value ?? false)
                                    ? Colors.green
                                    : Colors.red;
                              } else {
                                color = Colors.white;
                              }
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Material(
                                  color: color,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap:
                                        (c.selectedOptionIndex.value == null &&
                                            !c.isFlashing.value)
                                        ? () => c.handleOptionTap(i)
                                        : null,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        c.currentOptions.length > i
                                            ? c.currentOptions[i]
                                            : "",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: color == Colors.white
                                              ? Colors.black
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await c.restart();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'البدء من جديد',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(180, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
