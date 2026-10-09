import 'package:engo/pages/page1/lesson1/lesson1.dart';
import 'package:engo/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:engo/widgets/lesson_exit_dialog.dart';
import 'lesson2_controller.dart'; // تأكد من وجود هذا الملف

class Lesson2 extends StatelessWidget {
  final int groupIndex;
  final int levelIndex;
  const Lesson2({
    super.key,
    required this.groupIndex,
    required this.levelIndex,
  });

  @override
  Widget build(BuildContext context) {
    void leaveLesson() {
      Get.offAll(Lesson1(groupIndex: groupIndex, levelIndex: levelIndex));
    }

    return GetBuilder<Lesson2Controller>(
      init: Lesson2Controller(groupIndex: groupIndex, levelIndex: levelIndex),
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final isCompleted =
                controller.currentWords.isNotEmpty &&
                controller.matchedLeft.length == controller.currentWords.length;

            if (isCompleted) {
              leaveLesson();
              return;
            }

            await LessonExitDialog.show(
              context,
              onExit: () => Get.offAll(() => const BottomNavBar()),
            );
          },
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            body: Obx(
              () => controller.isLoading.value || controller.currentWords.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // أثناء تحميل البيانات من JSON
                  : Column(
                      children: [
                        // شريط التقدم
                        Container(
                          margin: const EdgeInsets.only(
                            top: 60,
                            left: 10,
                            right: 10,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  const Text('صحيح'),
                                  Text(
                                    '${controller.correctMatches.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.assignment,
                                    color: Colors.blue,
                                  ),
                                  const Text('المحاولات'),
                                  Text(
                                    '${controller.totalAttempts.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.emoji_events,
                                    color: Colors.orange,
                                  ),
                                  const Text('الباقي'),
                                  Text(
                                    '${controller.currentWords.length - controller.correctMatches.value}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            'اضغط على الازواج المتطابقة',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),

                        // العمودان الرئيسيان
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10,
                            ),
                            child: Row(
                              children: [
                                // العمود الأيسر - الكلمات الإنجليزية
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              controller.leftColumn.length,
                                          separatorBuilder: (_, _) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) {
                                            final isMatched = controller
                                                .matchedLeft
                                                .contains(index);
                                            final isSelected =
                                                controller.selectedLeft.value ==
                                                index;
                                            final isWrong =
                                                controller.wrongLeft.value ==
                                                index;

                                            Color getBackgroundColor() {
                                              if (isMatched) {
                                                return Colors.green[100]!;
                                              }
                                              if (isWrong) {
                                                return Colors.red[100]!;
                                              }
                                              if (isSelected) {
                                                return Colors.white;
                                              }
                                              return Colors.white;
                                            }

                                            Color getBorderColor() {
                                              if (isMatched) {
                                                return Colors.green;
                                              }
                                              if (isWrong) return Colors.red;
                                              if (isSelected) {
                                                return Colors.green;
                                              }
                                              return Colors.grey[300]!;
                                            }

                                            Color getTextColor() {
                                              if (isMatched) {
                                                return Colors.green[700]!;
                                              }
                                              if (isWrong) {
                                                return Colors.red[700]!;
                                              }
                                              return Colors.black87;
                                            }

                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: getBackgroundColor(),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: getBorderColor(),
                                                  width: isSelected ? 3 : 1,
                                                ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  onTap: isMatched
                                                      ? null
                                                      : () => controller
                                                            .selectLeftWord(
                                                              index,
                                                            ),
                                                  child: Center(
                                                    child: Text(
                                                      controller
                                                          .leftColumn[index]["en"]!,
                                                      style: GoogleFonts.cairo(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: getTextColor(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // العمود الأيمن - الكلمات المكتوبة
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.separated(
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              controller.rightColumn.length,
                                          separatorBuilder: (_, _) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) {
                                            final isMatched = controller
                                                .matchedRight
                                                .contains(index);
                                            final isSelected =
                                                controller
                                                    .selectedRight
                                                    .value ==
                                                index;
                                            final isWrong =
                                                controller.wrongRight.value ==
                                                index;

                                            Color getBackgroundColor() {
                                              if (isMatched) {
                                                return Colors.green[100]!;
                                              }
                                              if (isWrong) {
                                                return Colors.red[100]!;
                                              }
                                              if (isSelected) {
                                                return Colors.white;
                                              }
                                              return Colors.white;
                                            }

                                            Color getBorderColor() {
                                              if (isMatched) {
                                                return Colors.green;
                                              }
                                              if (isWrong) return Colors.red;
                                              if (isSelected) {
                                                return Colors.green;
                                              }
                                              return Colors.grey[300]!;
                                            }

                                            Color getTextColor() {
                                              if (isMatched) {
                                                return Colors.green[700]!;
                                              }
                                              if (isWrong) {
                                                return Colors.red[700]!;
                                              }
                                              return Colors.black87;
                                            }

                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 180,
                                              ),
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: getBackgroundColor(),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: getBorderColor(),
                                                  width: isSelected ? 3 : 1,
                                                ),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  onTap: isMatched
                                                      ? null
                                                      : () => controller
                                                            .selectRightWord(
                                                              index,
                                                            ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        if (isMatched)
                                                          const Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                            size: 20,
                                                          ),
                                                        if (isWrong)
                                                          const Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                            size: 20,
                                                          ),
                                                        if (isMatched ||
                                                            isWrong)
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                        Text(
                                                          controller
                                                              .rightColumn[index]["ar"]!,
                                                          style: GoogleFonts.cairo(
                                                            fontSize: 16,
                                                            color:
                                                                getTextColor(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final isCompleted =
                    controller.currentWords.isNotEmpty &&
                    controller.matchedLeft.length ==
                        controller.currentWords.length;

                if (isCompleted) {
                  leaveLesson();
                  return;
                }

                await LessonExitDialog.show(
                  context,
                  onExit: () => Get.offAll(() => const BottomNavBar()),
                );
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
