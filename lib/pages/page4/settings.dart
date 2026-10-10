// ignore_for_file: use_build_context_synchronously

import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'privacy_policy_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../page1/roadmap/progress_service.dart';

class SettingsController extends GetxController {
  var vibrations = true.obs;
  var sounds = true.obs;
  var darkMode = false.obs;
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _launchRateUs(BuildContext context) async {
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.yourname.engo',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح الرابط')));
    }
  }

  Future<void> _showRestoreDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Center(
          child: Text(
            'إعادة الضبط؟',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.color1,
            ),
          ),
        ),
        content: Text(
          'هل أنت متأكد من ذلك؟\nعند الضغط على نعم سيتم فقدان جميع التقدم والعودة بالمراحل من البداية.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('إلغاء', style: TextStyle(color: AppColors.color1)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'نعم',
              style: TextStyle(
                color: AppColors.color1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ProgressService.resetAll();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تمت إعادة تعيين جميع التقدم بنجاح.')),
      );
      Get.find<SettingsController>().vibrations.value = true;
      Get.find<SettingsController>().sounds.value = true;
      Get.find<SettingsController>().darkMode.value = false;
    }
  }

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    // 🟢 MediaQuery لجعل الصفحة متناسقة مع جميع قياسات الشاشات.
    final MediaQueryData media = MediaQuery.of(context);
    final double screenW = media.size.width;
    final double screenH = media.size.height;
    const double refW = 375.0;
    const double refH = 812.0;
    final double wScale = (screenW / refW).clamp(0.70, 1.40);
    final double hScale = (screenH / refH).clamp(0.75, 1.30);
    final double ui = ((wScale + hScale) / 2).clamp(0.75, 1.35);

    final double cardRadius = 22 * ui;
    final double cardPadding = 18 * ui;
    final double cardMargin = 14 * ui;
    final double titleSize = 24 * ui;
    final double rowIconSize = 24 * ui;
    final double rowFontSize = 12 * ui;
    final double tagFontSize = 13 * ui;
    final double switchW = 50 * ui;
    final double switchH = 20 * ui;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 12 * ui, bottom: 24 * ui),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── العنوان ──────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20 * ui, 8 * ui, 20 * ui, 16 * ui),
                child: Text(
                  'إعدادات التطبيق',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.color1,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              SizedBox(height: screenH / 60),

              // ─── بطاقة الإعدادات السريعة (توهّجات) ──
              _SettingsCard(
                margin: cardMargin,
                padding: cardPadding,
                radius: cardRadius,
                child: Column(
                  children: [
                    _RowToggle(
                      icon: Icons.vibration_rounded,
                      title: 'الاهتزاز',
                      rxBool: controller.vibrations,
                      switchW: switchW,
                      switchH: switchH,
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                    ),
                    _DotDivider(ui: ui),
                    _RowToggle(
                      icon: Icons.volume_up_rounded,
                      title: 'الأصوات',
                      rxBool: controller.sounds,
                      switchW: switchW,
                      switchH: switchH,
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                    ),
                    _DotDivider(ui: ui),
                    _RowToggle(
                      icon: Icons.nightlight_round,
                      title: 'الوضع الداكن',
                      rxBool: controller.darkMode,
                      switchW: switchW,
                      switchH: switchH,
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenH / 40),
              // ─── بطاقة ترقية / إزالة الإعلانات ───
              _SettingsCard(
                margin: cardMargin,
                padding: 0,
                radius: cardRadius,
                onTap: () {},
                child: Row(
                  children: [
                    // زر الترقية (يسار) — شكل حبّة دواء
                    Container(
                      margin: EdgeInsets.all(cardPadding),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18 * ui,
                        vertical: 8 * ui,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.color3,
                        borderRadius: BorderRadius.circular(18 * ui),
                      ),
                      child: Text(
                        'ترقية',
                        style: TextStyle(
                          fontSize: tagFontSize,
                          fontWeight: FontWeight.w800,
                          color: AppColors.color1,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: cardPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'إزالة الإعلانات',
                            style: TextStyle(
                              fontSize: rowFontSize,
                              fontWeight: FontWeight.w800,
                              color: AppColors.color1,
                            ),
                          ),
                          SizedBox(width: 12 * ui),
                          Icon(
                            Icons.block_rounded,
                            color: AppColors.color1,
                            size: rowIconSize,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenH / 40),

              // ─── بطاقة الروابط (تقييم/تواصل/خصوصية) ──
              _SettingsCard(
                margin: cardMargin,
                padding: cardPadding,
                radius: cardRadius,
                child: Column(
                  children: [
                    _RowNav(
                      icon: Icons.star_rounded,
                      title: 'قيمنا الآن',
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                      onTap: () => _launchRateUs(context),
                    ),
                    _DotDivider(ui: ui),
                    _RowNav(
                      icon: Icons.mail_rounded,
                      title: 'تواصل معنا',
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                      onTap: () {},
                    ),
                    _DotDivider(ui: ui),
                    _RowNav(
                      icon: Icons.shield_rounded,
                      title: 'سياسة الخصوصية',
                      iconSize: rowIconSize,
                      fontSize: rowFontSize,
                      ui: ui,
                      onTap: () => _openPrivacyPolicy(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenH / 20),

              // ─── بطاقة إعادة الضبط (عمل حسّاس) ────
              _SettingsCard(
                margin: cardMargin,
                padding: cardPadding,
                radius: cardRadius,
                onTap: () => _showRestoreDialog(context),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'إعادة ضبط التقدم',
                        style: TextStyle(
                          fontSize: rowFontSize,
                          fontWeight: FontWeight.w900,
                          color: AppColors.color16, // أحمر مرجاني
                        ),
                      ),
                      SizedBox(width: 8 * ui),
                      Icon(
                        Icons.refresh_rounded,
                        size: rowIconSize,
                        color: AppColors.color16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// بطاقة عامة بزوايا مدوّرة وظلّ خفيف (نفس لغة باقي التطبيق).
// ════════════════════════════════════════════════════════════
class _SettingsCard extends StatelessWidget {
  final Widget child;
  final double margin;
  final double padding;
  final double radius;
  final VoidCallback? onTap;
  const _SettingsCard({
    required this.child,
    required this.margin,
    required this.padding,
    required this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // تحكم يدوي بالهامش الخارجي (نتجنّب Stack/wrappers أخرى).
      padding: EdgeInsets.symmetric(horizontal: margin),
      child: Material(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: AppColors.color1.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Container(
            padding: padding == 0 ? null : EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// صفّ مفتاح تشغيل/إيقاف (switch pill مخصّص يطابق التصميم).
// RTL: أيقونة يمين، نص يمين، مفتاح يسار.
// ════════════════════════════════════════════════════════════
class _RowToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final RxBool rxBool;
  final double switchW;
  final double switchH;
  final double iconSize;
  final double fontSize;
  final double ui;
  const _RowToggle({
    required this.icon,
    required this.title,
    required this.rxBool,
    required this.switchW,
    required this.switchH,
    required this.iconSize,
    required this.fontSize,
    required this.ui,
  });

  @override
  Widget build(BuildContext context) {
    // ارتفاع الصفّ يتناسب مع ارتفاع المفتاح + هوامش.
    final double rowH = switchH + 12 * ui;
    return SizedBox(
      height: rowH,
      child: Row(
        children: [
          // المفتاح (يسار)
          Obx(
            () => _PillSwitch(
              value: rxBool.value,
              onChanged: (v) => rxBool.value = v,
              width: switchW,
              height: switchH,
            ),
          ),
          const Spacer(),
          // النص + الأيقونة (يمين — RTL)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.color1,
                ),
              ),
              SizedBox(width: 12 * ui),
              Icon(icon, color: AppColors.color1, size: iconSize),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// صفّ تنقّل بأيقونة + نص + سهم خلفي.
// ════════════════════════════════════════════════════════════
class _RowNav extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double ui;
  const _RowNav({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
    required this.ui,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6 * ui),
        child: Row(
          children: [
            // السهم الخلفي على اليسار (يسير باتجاه الصفحة السابقة)
            Icon(
              Icons.chevron_left_rounded,
              color: AppColors.color1.withValues(alpha: 0.5),
              size: iconSize,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.color1,
                  ),
                ),
                SizedBox(width: 12 * ui),
                Icon(icon, color: AppColors.color1, size: iconSize),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// مفتاح بيضاوي مخصّص (pill switch) — يطابق الصورة المرفقة.
// لون متروك (غامق حين ON، رمادي حين OFF)، كرة بيضاء ثخينة.
// ════════════════════════════════════════════════════════════
class _PillSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width;
  final double height;
  const _PillSwitch({
    required this.value,
    required this.onChanged,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color track = value ? AppColors.color1 : const Color(0xFFB8C5D6);
    // الهامش الداخلي للكرة — 6% من الارتفاع
    final double thumbMargin = height * 0.10;
    final double thumbSize = height - thumbMargin * 2;
    final double thumbX = value
        ? thumbMargin // في الـ ON الكرة على يسار المسار (RTL)
        : width - thumbSize - thumbMargin; // في الـ OFF على اليمين
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(height),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              top: thumbMargin,
              left: thumbX,
              right: null,
              bottom: thumbMargin,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// فاصل نقطي خفيف بين صفوف البطاقة.
// ════════════════════════════════════════════════════════════
class _DotDivider extends StatelessWidget {
  final double ui;
  const _DotDivider({required this.ui});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4 * ui),
      child: Row(
        children: List.generate(
          60,
          (_) => Expanded(
            child: Container(
              height: 1,
              color: AppColors.color4.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
