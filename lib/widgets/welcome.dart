import 'package:engo/widgets/bottom_nav_bar.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

/// صفحة الترحيب التفاعلية — 3 صفحات قابلة للسحب.
/// تصميم جليدي-فضي متناسق مع باقي التطبيق.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // 🧩 محتوى الصفحات (صورة فقط — لا أيقونة فوقها)
  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'أهلاً بك في Engo',
      subtitle: 'دليلك الصغير لاحتراف اللغة الإنجليزية\nخطوة بخطوة، في وقتك.',
      imagePath: 'assets/images/Engo.png',
    ),
    _OnboardingPage(
      title: 'مسار تعليمي متعرج',
      subtitle:
          '21 مرحلة ممتعة، من الكلمات الأساسية\nإلى المفردات المتقدمة، بأسلوب تفاعلي.',
      imagePath: 'assets/images/Engo.png',
    ),
    _OnboardingPage(
      title: 'ألعاب واختبارات',
      subtitle:
          'اختبر معلوماتك بألعاب سريعة، استمع\nللجمل، اقرأ نصوصاً قصيرة كل يوم.',
      imagePath: 'assets/images/Engo.png',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  void _finish() {
    GetStorage().write('hasSeenWelcome', true);
    Get.offAll(() => const BottomNavBar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.color3, AppColors.color5],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🟢 زر التخطي في الأعلى
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    _currentPage == _pages.length - 1 ? '' : 'تخطي',
                    style: GoogleFonts.cairo(
                      color: AppColors.color2,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // 🟢 الصفحات القابلة للسحب
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) =>
                      _OnboardingSlide(page: _pages[i]),
                ),
              ),

              // 🟢 مؤشر الصفحات (النقاط)
              _PageIndicator(count: _pages.length, current: _currentPage),

              const SizedBox(height: 24),

              // 🟢 زر التالي / ابدأ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color1,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.color1.withValues(alpha: 0.4),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'ابدأ التعلم 🚀'
                          : 'التالي',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

/// ───────────────────────────────────────────────────────────
/// بيانات صفحة تعريفية واحدة (صورة فقط)
/// ───────────────────────────────────────────────────────────
class _OnboardingPage {
  final String title;
  final String subtitle;
  final String imagePath;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

/// ───────────────────────────────────────────────────────────
/// محتوى الصفحة الواحدة (صورة كبيرة + عنوان + وصف)
/// ───────────────────────────────────────────────────────────
class _OnboardingSlide extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingSlide({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🧊 إطار جليدي للصورة (بدون أيقونة فوقها)
          Container(
            width: 290,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.color3,
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(page.imagePath, fit: BoxFit.contain),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // 🟢 العنوان
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.color1,
            ),
          ),

          const SizedBox(height: 16),

          // 🟢 الوصف
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              fontSize: 16,
              height: 1.7,
              fontWeight: FontWeight.w600,
              color: AppColors.color2,
            ),
          ),
        ],
      ),
    );
  }
}

/// ───────────────────────────────────────────────────────────
/// مؤشر الصفحات (نقاط أفقية)
/// ───────────────────────────────────────────────────────────
class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;
  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final bool active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 28 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: active
                ? AppColors.color1
                : AppColors.color2.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}
