import 'dart:math';
import 'package:engo/data/a1_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class A1Q2Controller extends GetxController {
  final List<Map<String, String>> data = a1data;
  final _rnd = Random();
  final FlutterTts tts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();

  late List<int> remainingIndexes;
  late int qIndex;
  late List<String> options;
  RxnInt selected = RxnInt();
  RxBool isCorrect = false.obs;
  RxBool processing = false.obs;

  RxInt correctCount = 0.obs;
  RxInt wrongCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tts.setLanguage('en-US');
    tts.setPitch(1.0);
    tts.setSpeechRate(0.45);
    initProgress();
  }

  Future<void> initProgress() async {
    final prefs = await SharedPreferences.getInstance();
    correctCount.value = prefs.getInt('a1q2_correct') ?? 0;
    wrongCount.value = prefs.getInt('a1q2_wrong') ?? 0;
    List<String> doneIndexes = prefs.getStringList('a1q2_doneIndexes') ?? [];
    remainingIndexes = List.generate(data.length, (i) => i)
      ..removeWhere((i) => doneIndexes.contains(i.toString()));

    if (remainingIndexes.isEmpty) {
      correctCount.value = 0;
      wrongCount.value = 0;
      remainingIndexes = List.generate(data.length, (i) => i);
      await prefs.remove('a1q2_doneIndexes');
    }

    qIndex = remainingIndexes[_rnd.nextInt(remainingIndexes.length)];
    prepareQuestion();
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('a1q2_correct', correctCount.value);
    prefs.setInt('a1q2_wrong', wrongCount.value);
    final doneIndexes = List.generate(data.length, (i) => i)
        .where((i) => !remainingIndexes.contains(i))
        .map((i) => i.toString())
        .toList();
    prefs.setStringList('a1q2_doneIndexes', doneIndexes);
  }

  void prepareQuestion() {
    final correct = data[qIndex]["en"]!;
    final others = data.where((e) => e["en"] != correct).toList()
      ..shuffle(_rnd);
    options = [correct, others[0]["en"]!, others[1]["en"]!, others[2]["en"]!]
      ..shuffle(_rnd);
    selected.value = null;
    isCorrect.value = false;
    processing.value = false;
    update();
    tts.speak(data[qIndex]["en"]!);
  }

  Future<void> onTapOption(int i, BuildContext context) async {
    if (processing.value) return;
    selected.value = i;
    isCorrect.value = (options[i] == data[qIndex]["en"]);
    processing.value = true;
    if (isCorrect.value) {
      correctCount.value++;
      await audioPlayer.play(AssetSource('sounds/correct.mp3'));
    } else {
      wrongCount.value++;
      await audioPlayer.play(AssetSource('sounds/wrong.mp3'));
    }
    update();

    await Future.delayed(const Duration(milliseconds: 1500));
    remainingIndexes.remove(qIndex);
    await saveProgress();

    if (remainingIndexes.isNotEmpty) {
      qIndex = remainingIndexes[_rnd.nextInt(remainingIndexes.length)];
      prepareQuestion();
    } else {
      await saveProgress();
      if (Get.context == null) return;
      await Get.dialog(
        AlertDialog(
          title: const Text('انتهى الاختبار'),
          content: Text(
            'أكملت جميع الجمل.\nإجابات صحيحة: ${correctCount.value}\nإجابات خاطئة: ${wrongCount.value}\nهل تريد إعادة التشغيل؟',
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('إغلاق')),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await restart();
              },
              child: const Text('إعادة'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> restart() async {
    correctCount.value = 0;
    wrongCount.value = 0;
    remainingIndexes = List.generate(data.length, (i) => i);
    await saveProgress();
    qIndex = remainingIndexes[_rnd.nextInt(remainingIndexes.length)];
    prepareQuestion();
  }

  Future<void> speak(String text) async {
    try {
      await tts.stop();
      await tts.speak(text);
    } catch (_) {}
  }

  @override
  void onClose() {
    tts.stop();
    audioPlayer.dispose();
    super.onClose();
  }
}

class A2 extends StatelessWidget {
  const A2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<A1Q2Controller>(
      init: A1Q2Controller(),
      builder: (c) {
        if (c.options.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final enText = c.data[c.qIndex]["ar"]!;
        final total = c.data.length.toDouble();
        final correctFraction = (c.correctCount.value / total).clamp(0.0, 1.0);
        final wrongFraction = (c.wrongCount.value / total).clamp(0.0, 1.0);

        return Scaffold(
          appBar: AppBar(
            title: const Text(' ما عدد الكلمات التي تسمعها؟'),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FractionallySizedBox(
                              widthFactor: correctFraction,
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green,
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
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                              const SizedBox(width: 8),
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
                      const SizedBox(height: 16),
                    ],
                  ),
                  // الجملة الإنجليزية + زر الصوت
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          enText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => c.speak(enText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // الخيارات
                  Expanded(
                    child: ListView.separated(
                      itemCount: c.options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final isSelected = c.selected.value == i;
                        Color bg = Colors.white;
                        Color textColor = Colors.black;
                        if (isSelected) {
                          bg = c.isCorrect.value ? Colors.green : Colors.red;
                          textColor = Colors.white;
                        }
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => c.onTapOption(i, context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 12,
                                ),
                                child: Text(
                                  c.options[i],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // زر إعادة
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: c.restart,
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة الاختبار'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
