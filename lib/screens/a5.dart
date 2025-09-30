import 'package:engo/screens/levelpage.dart';
import 'package:engo/data/dolingo_data5.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class ListeningQuizController extends GetxController {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxInt currentIndex = 0.obs;
  RxList<String> selectedWords = <String>[].obs;
  RxBool isCorrect = false.obs;
  RxBool checked = false.obs;
  RxBool readyForNext = false.obs;

  List<Map<String, dynamic>> get sentences => dolingoData5;
  @override
  void onInit() {
    super.onInit();
    flutterTts.setLanguage("en-US");
    speakSentence();
  }

  Future<void> speakSentence() async {
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(sentences[currentIndex.value]['sentence']);
  }

  Future<void> speakSentenceslow() async {
    await flutterTts.setSpeechRate(0.0);
    await flutterTts.speak(sentences[currentIndex.value]['sentence']);
  }

  Future<void> playResultSound(bool correct) async {
    await audioPlayer.stop();
    await audioPlayer.play(
      AssetSource(correct ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'),
    );
  }

  void goToNextQuestion() async {
    if (currentIndex.value < sentences.length - 1) {
      currentIndex.value++;
      selectedWords.clear();
      checked.value = false;
      isCorrect.value = false;
      readyForNext.value = false;
      await speakSentence();
    } else {
      // انتهاء جميع الأسئلة - العودة للصفحة السابقة
      Get.snackbar(
        'تهانينا!',
        'لقد أنهيت جميع التمارين بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.celebration, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        borderRadius: 20,
        margin: const EdgeInsets.all(16),
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
      );

      // انتظار ثانيتين ثم العودة للصفحة السابقة
      await Future.delayed(const Duration(seconds: 1));
      Get.off(LevelPage());
    }
  }

  void checkAnswer() async {
    final correct =
        selectedWords.join(' ') ==
        sentences[currentIndex.value]['arabicSentence'];
    isCorrect.value = correct;
    checked.value = true;
    await playResultSound(correct);

    if (correct) {
      // عرض snackbar للإجابة الصحيحة
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
      // عرض snackbar للإجابة الخاطئة
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

class A5 extends StatelessWidget {
  const A5({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListeningQuizController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('ترجم ما تسمع'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        final sentence = controller.sentences[controller.currentIndex.value];
        final options = List<String>.from(sentence['options']);
        options.shuffle(Random(controller.currentIndex.value));

        return Stack(
          children: [
            Column(
              children: [
                // شريط التقدم
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: LinearProgressIndicator(
                    value:
                        (controller.currentIndex.value + 1) /
                        controller.sentences.length,
                    backgroundColor: Colors.grey[300],
                    color: Colors.teal,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                // زر الصوت
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.slow_motion_video,
                        color: Colors.blue,
                        size: 40,
                      ),
                      onPressed: controller.speakSentenceslow,
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.blue,
                        size: 50,
                      ),
                      onPressed: controller.speakSentence,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // عرض الجملة الإنجليزية
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal[200]!, width: 1),
                  ),
                  child: Text(
                    sentence['sentence'],
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                // منطقة الكلمات المختارة (فراغ ثابت)
                Container(
                  width: double.infinity,
                  height: 150, // ارتفاع ثابت للمنطقة
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Obx(
                    () => Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      textDirection: TextDirection.rtl,
                      children: controller.selectedWords
                          .map(
                            (word) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                              ),
                              onPressed: () {
                                controller.selectedWords.remove(word);
                              },
                              child: Text(
                                word,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // الخيارات
                Obx(
                  () => Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: options.map((word) {
                      final isSelected = controller.selectedWords.contains(
                        word,
                      );
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? Colors.grey[300]
                              : Colors.grey[100],
                          foregroundColor: isSelected
                              ? Colors.grey[500]
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                        ),
                        onPressed: isSelected
                            ? null
                            : () {
                                controller.selectedWords.add(word);
                              },
                        child: Text(word, style: const TextStyle(fontSize: 15)),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(),
                // زر تحقق
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: controller.selectedWords.isEmpty
                          ? null
                          : controller.readyForNext.value
                          ? controller.goToNextQuestion
                          : controller.checkAnswer,
                      child: Text(
                        controller.readyForNext.value ? 'متابعة' : 'تحقّق',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ],
        );
      }),
    );
  }
}
