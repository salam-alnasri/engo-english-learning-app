import 'package:engo/data/stories_repository.dart';
import 'package:engo/pages/page2/level_data.dart';
import 'package:engo/pages/page2/level_progress_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

/// متحكم الصفحة الأولى: قائمة المستويات الستة (بطاقات فوق بعضها).
class LevelsController extends GetxController {
  /// عدد القصص المقروءة لكل مستوى (المفتاح = رمز المستوى).
  final RxMap<String, int> _readCounts = <String, int>{}.obs;

  /// قائمة المستويات الحيّة. تبدأ فارغة وتُملأ بـ [_loadAllStories].
  late final RxList<CefrLevel> _levels;

  /// حالة التحميل من ملفات JSON.
  final RxBool isLoading = true.obs;

  List<CefrLevel> get levels => _levels;

  /// إجمالي عدد القصص في كل المستويات (يظهر في الترويسة).
  int get totalStoriesCount =>
      _levels.fold(0, (sum, level) => sum + level.texts.length);

  @override
  void onInit() {
    super.onInit();
    // نسخة قابلة للتعديل من القائمة الأساسية (texts تُملأ لاحقاً).
    _levels = cefrLevels.map((l) => l).toList().obs;
    _loadAllStories();
    _loadProgress();
  }

  /// تحميل كل المستويات بشكل غير متزامن من JSON.
  Future<void> _loadAllStories() async {
    isLoading.value = true;
    try {
      for (int i = 0; i < cefrLevels.length; i++) {
        final base = cefrLevels[i];
        final stories = await StoriesRepository.load(base.code.toLowerCase());
        // استبدل العنصر بنسخة جديدة تحوي القصص المحمَّلة.
        _levels[i] = CefrLevel(
          code: base.code,
          nameAr: base.nameAr,
          color: base.color,
          icon: base.icon,
          texts: stories,
        );
      }
    } catch (e) {
      // في حال الخطأ نترك القائمة فارغة ونخف الـ loading.
    } finally {
      isLoading.value = false;
    }
  }

  /// لقطة بعدد القصص المقروءة لكل مستوى.
  ///
  /// تُقرأ من داخل builder في الصفحة حتى تُسجَّل التحديثات على هذه القيم.
  Map<String, int> progressSnapshot() {
    final snapshot = <String, int>{};
    for (final level in _levels) {
      snapshot[level.code] = _readCounts[level.code] ?? 0;
    }
    return snapshot;
  }

  /// تُستدعى بعد العودة من صفحة قصص المستوى لتحديث أشرطة التقدّم.
  void refreshProgress() => _loadProgress();

  void _loadProgress() {
    for (final level in _levels) {
      _readCounts[level.code] = LevelProgressService.getReadCount(level.code);
    }
  }
}

/// متحكم صفحة قصص مستوى واحد.
class LevelStoriesController extends GetxController {
  LevelStoriesController({required this.level});

  final CefrLevel level;
  final FlutterTts flutterTts = FlutterTts();

  /// القصة المفتوحة حاليًا بالتفصيل (null = عرض قائمة القصص).
  final RxnString openedStoryId = RxnString();

  /// معرّفات القصص التي أنهها المستخدم.
  final RxList<String> readStoryIds = <String>[].obs;

  /// القصة التي يُقرأ نصها بصوت عالٍ حاليًا (null = لا يوجد).
  final RxnString speakingStoryId = RxnString();

  /// القصص المحمَّلة محلياً (قد تختلف عن `level.texts` إذا لم تكن محمَّلة بعد).
  late List<ReadingText> _stories = List<ReadingText>.from(level.texts);

  /// حالة تحميل القصص لهذا المستوى.
  final RxBool isLoading = true.obs;

  List<ReadingText> get stories => _stories;

  int get readCount => readStoryIds.length;

  double get progress => stories.isEmpty ? 0 : readCount / stories.length;

  bool get isLevelCompleted =>
      stories.isNotEmpty && readCount == stories.length;

  /// القصة المفتوحة حاليًا، أو null إذا كنا في قائمة القصص.
  ReadingText? get openedStory {
    final openedId = openedStoryId.value;
    if (openedId == null) return null;
    for (final story in stories) {
      if (story.id == openedId) return story;
    }
    return null;
  }

  /// أرقام القصص المكتملة (تبدأ من 1) لعرضها في ترويسة المستوى.
  List<int> get readStoryNumbers => [
    for (var index = 0; index < stories.length; index++)
      if (readStoryIds.contains(stories[index].id)) index + 1,
  ];

  @override
  void onInit() {
    super.onInit();
    readStoryIds.assignAll(LevelProgressService.getReadTexts(level.code));
    _configureTts();
    _loadStories();
  }

  /// تحميل قصص هذا المستوى من ملف JSON (إذا لم تكن محمَّلة بعد).
  Future<void> _loadStories() async {
    isLoading.value = true;
    try {
      final fresh = await StoriesRepository.load(level.code.toLowerCase());
      _stories = fresh;
    } catch (e) {
      // في حال الفشل نبقى على ما هو متاح.
    } finally {
      isLoading.value = false;
    }
  }

  /// حالة كل قصة: هل تمت قراءتها؟ تُقرأ من داخل builder في الصفحة.
  Map<String, bool> readSnapshot() {
    final snapshot = <String, bool>{};
    for (final story in stories) {
      snapshot[story.id] = readStoryIds.contains(story.id);
    }
    return snapshot;
  }

  Future<void> _configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.45);
    flutterTts.setCompletionHandler(() => speakingStoryId.value = null);
    flutterTts.setCancelHandler(() => speakingStoryId.value = null);
  }

  /// فتح قصة بعينها لعرض نصّها الكامل.
  void openStory(String storyId) => openedStoryId.value = storyId;

  /// العودة إلى قائمة القصص وإيقاف أي قراءة صوتية.
  Future<void> closeStory() async {
    await stopSpeaking();
    openedStoryId.value = null;
  }

  /// تسجيل القصة كمقروءة أو إلغاء ذلك (يُحفظ في التخزين المحلي).
  Future<void> toggleRead(String storyId) async {
    if (readStoryIds.contains(storyId)) {
      readStoryIds.remove(storyId);
      await LevelProgressService.unmarkAsRead(level.code, storyId);
    } else {
      readStoryIds.add(storyId);
      await LevelProgressService.markAsRead(level.code, storyId);
    }
  }

  /// يقرأ نص القصة كاملًا، أو يوقف القراءة إذا كان يُقرأ حاليًا.
  Future<void> speakStory(ReadingText story) async {
    if (speakingStoryId.value == story.id) {
      await stopSpeaking();
      return;
    }
    await flutterTts.stop();
    speakingStoryId.value = story.id;
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.speak(story.paragraphs.join(' '));
  }

  /// قراءة بطيئة تساعد المبتدئين على متابعة الكلمات.
  Future<void> speakStorySlowly(ReadingText story) async {
    await flutterTts.stop();
    speakingStoryId.value = story.id;
    await flutterTts.setSpeechRate(0.3);
    await flutterTts.speak(story.paragraphs.join(' '));
  }

  /// نطق أي نص قصير: فقرة من القصة أو كلمة من المفردات.
  Future<void> speak(String text) async {
    await flutterTts.stop();
    speakingStoryId.value = null;
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
    speakingStoryId.value = null;
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}