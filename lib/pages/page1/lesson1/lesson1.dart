import 'package:engo/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:engo/widgets/lesson_exit_dialog.dart';
import 'lesson1_controller.dart';

class Lesson1 extends StatelessWidget {
  final int groupIndex;
  final int levelIndex;
  const Lesson1({
    super.key,
    required this.groupIndex,
    required this.levelIndex,
  });

  @override
  Widget build(BuildContext context) {
    void exitToRoadMap() {
      Get.offAll(() => const BottomNavBar());
    }

    return GetBuilder<Lesson1Controller>(
      init: Lesson1Controller(groupIndex: groupIndex, levelIndex: levelIndex),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (controller.isQuizCompleted.value) {
              exitToRoadMap();
              return;
            }

            await LessonExitDialog.show(context, onExit: exitToRoadMap);
          },
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            body: Obx(
              () {
                // أثناء تحميل البيانات من ملف JSON
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.teal),
                  );
                }

                return Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  right: 10,
                  left: 10,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    // شريط التقدم والنتائج
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.purple,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${controller.currentQuestionNumber.value > 5 ? 5 : controller.currentQuestionNumber.value}/5',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Text(
                                'التقدم',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.favorite, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.correctCount.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                'صحيح',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.close, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.wrongCount.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Text('خطأ', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // عرض الكلمة مع زر الصوت
                    GestureDetector(
                      onTap: controller.speakCurrentWord,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.volume_up,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              controller.currentWord.value,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // الخيارات في شبكة 2x2
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                            ),
                        itemCount: controller.options.length,
                        itemBuilder: (context, index) {
                          final option = controller.options[index];
                          final isSelected =
                              controller.selectedIndex.value == index;
                          final isCorrectOption =
                              index == controller.correctIndex.value;

                          Color getBackgroundColor() {
                            if (!controller.isAnswered.value) {
                              return Colors.white;
                            }
                            if (isSelected && controller.isCorrect.value) {
                              return Colors.green[100]!;
                            }
                            if (isSelected && !controller.isCorrect.value) {
                              return Colors.red[100]!;
                            }
                            if (isCorrectOption &&
                                !controller.isCorrect.value) {
                              return Colors.green[100]!;
                            }
                            return Colors.white;
                          }

                          Color getBorderColor() {
                            if (!controller.isAnswered.value) {
                              return Colors.grey[300]!;
                            }
                            if (isSelected && controller.isCorrect.value) {
                              return Colors.green;
                            }
                            if (isSelected && !controller.isCorrect.value) {
                              return Colors.red;
                            }
                            if (isCorrectOption &&
                                !controller.isCorrect.value) {
                              return Colors.green;
                            }
                            return Colors.grey[300]!;
                          }

                          return GestureDetector(
                            onTap: () => controller.selectOption(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: getBackgroundColor(),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: getBorderColor(),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade100,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    option["image"]!,
                                    style: const TextStyle(fontSize: 60),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    option["ar"]!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (controller.isQuizCompleted.value) {
                  exitToRoadMap();
                  return;
                }

                await LessonExitDialog.show(context, onExit: exitToRoadMap);
              },
              backgroundColor: Colors.teal,
              tooltip: 'الرجوع للصفحة الرئيسية',
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          ),
        );
      },
    );
  }
}
