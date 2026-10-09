import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:engo/widgets/lesson_exit_dialog.dart';
import 'package:engo/widgets/bottom_nav_bar.dart';
import 'lesson3_controller.dart'; // <-- الاستيراد الجديد

class Lesson3 extends StatelessWidget {
  const Lesson3({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments ?? {};
    final int groupIndex = args['groupIndex'] ?? 0;
    final int levelIndex = args['levelIndex'] ?? 0;
    final controller = Get.put(
      Lesson3Controller(groupIndex: groupIndex, levelIndex: levelIndex),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await LessonExitDialog.show(
          context,
          onExit: () => Get.offAll(() => const BottomNavBar()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أدخل الكلمات التي سمعتها'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Obx(() {
          // أثناء تحميل البيانات من ملف JSON
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (controller.sentences.isEmpty) {
            return const Center(
              child: Text('لا توجد بيانات متاحة لهذا المستوى حالياً'),
            );
          }

          final sentence = controller.sentences[controller.currentIndex.value];
          final options = List<String>.from(sentence.options);
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

                  // أزرار الصوت وترجمة الجملة
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                            color: Colors.blue,
                            size: 50,
                          ),
                          onPressed: controller.speakSentence,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.slow_motion_video,
                            color: Colors.blue,
                            size: 50,
                          ),
                          onPressed: controller.speakSentenceslow,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            controller.currentArabicTranslation,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // منطقة الكلمات المختارة (فراغ ثابت)
                  Container(
                    width: double.infinity,
                    height: 200, // ارتفاع ثابت للمنطقة
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 1),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Obx(
                      () => Wrap(
                        spacing: 5,
                        runSpacing: 5,
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
                  const SizedBox(height: 24),
                  // الخيارات
                  Obx(
                    () => Wrap(
                      spacing: 8,
                      runSpacing: 8,
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
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                          ),
                          onPressed: isSelected
                              ? null
                              : () {
                                  // انطق الكلمة فور الضغط عليها (نطق سريع)
                                  controller.speakWord(word);
                                  controller.selectedWords.add(word);
                                },
                          child: Text(
                            word,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Spacer(),
                  // زر تحقق
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
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
                  const Spacer(flex: 2),
                ],
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await LessonExitDialog.show(
              context,
              onExit: () => Get.offAll(() => const BottomNavBar()),
            );
          },
          backgroundColor: Colors.teal,
          tooltip: 'الرجوع للصفحة الرئيسية',
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
