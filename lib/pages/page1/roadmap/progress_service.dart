import 'package:get_storage/get_storage.dart';

class ProgressService {
  // Update this value when adding new lessons to each stage.
  static const int lessonsPerStage = 3;

  /// Erase all progress and mistakes from storage
  static Future<void> resetAll() async {
    await _box.erase();
  }

  static final _box = GetStorage();

  static String _mistakeKey(int stage) => 'stage_${stage}_mistakes';
  static String _passedKey(int stage) => 'stage_${stage}_passed';
  static String _lessonDoneKey(int stage, int lessonIndex) =>
      'stage_${stage}_lesson_${lessonIndex}_done';

  static int getStageMistakes(int stage) {
    return _box.read(_mistakeKey(stage)) ?? 0;
  }

  static void setStageMistakes(int stage, int value) {
    _box.write(_mistakeKey(stage), value);
  }

  static bool getStagePassed(int stage) {
    return _box.read(_passedKey(stage)) ?? false;
  }

  static void setStagePassed(int stage, bool value) {
    _box.write(_passedKey(stage), value);
  }

  static int getLessonsPerStage(int stage) {
    return lessonsPerStage;
  }

  static void markLessonCompleted(int stage, int lessonIndex) {
    _box.write(_lessonDoneKey(stage, lessonIndex), true);

    if (isStageFullyCompleted(stage)) {
      setStagePassed(stage, true);
    }
  }

  static bool isLessonCompleted(int stage, int lessonIndex) {
    return _box.read(_lessonDoneKey(stage, lessonIndex)) ?? false;
  }

  static int getCompletedLessonsCount(int stage) {
    final totalLessons = getLessonsPerStage(stage);
    int count = 0;

    for (int lessonIndex = 0; lessonIndex < totalLessons; lessonIndex++) {
      if (isLessonCompleted(stage, lessonIndex)) {
        count++;
      }
    }

    return count;
  }

  static bool isStageFullyCompleted(int stage) {
    return getCompletedLessonsCount(stage) >= getLessonsPerStage(stage);
  }

  static String _correctKey(int stage) => 'stage_${stage}_correct';

  static int getStageCorrect(int stage) {
    return _box.read(_correctKey(stage)) ?? 0;
  }

  static void setStageCorrect(int stage, int value) {
    _box.write(_correctKey(stage), value);
  }

  /// Returns true if the stage is open (first is always open, others only if previous is passed)
  static bool isStageOpen(int stage) {
    if (stage == 0) return true;
    return true;

    // getStagePassed(stage - 1);
  }
}
