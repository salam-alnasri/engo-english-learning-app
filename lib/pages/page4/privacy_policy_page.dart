// lib/pages/page4/privacy_policy_page.dart
//
// 🟢 يعرض سياسة الخصوصية من ملف JSON.
// يستخدم GetX (StatelessWidget + Obx) لإدارة الحالة:
//   - اللغة الحالية (ar / en)
//   - حالة التحميل
//   - البيانات المحمَّلة
// زر جانبي (FAB) لتبديل اللغة بين العربية والإنجليزية والعكس.

import 'package:engo/data/privacy_repository.dart';
import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyController extends GetxController {
  /// كود اللغة الحالي: 'ar' أو 'en'.
  final RxString lang = 'ar'.obs;

  /// بيانات السياسة المحمَّلة من JSON.
  final Rx<PrivacyPolicyData?> data = Rx<PrivacyPolicyData?>(null);

  /// حالة التحميل الأولي.
  final RxBool loading = true.obs;

  bool get isArabic => lang.value == 'ar';
  String get otherLangLabel => isArabic ? 'EN' : 'العربية';

  /// يُحمَّل تلقائياً عند إنشاء الـ controller (أول بناء للصفحة).
  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      final result = await PrivacyRepository().load();
      data.value = result;
    } catch (e) {
      // 🟢 إشعار خطأ عبر GetX — لا يحتاج context.
      Get.snackbar(
        'خطأ',
        'تعذر تحميل سياسة الخصوصية: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
      );
    } finally {
      loading.value = false;
    }
  }

  /// تبديل اللغة بين العربية والإنجليزية.
  void toggleLang() {
    lang.value = isArabic ? 'en' : 'ar';
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static String _fontFamily() => GoogleFonts.cairo().fontFamily!;

  @override
  Widget build(BuildContext context) {
    // 🟢 Get.put — نفس النمط المستخدم في SettingsPage.
    final controller = Get.put(PrivacyController());

    // 🟢 MediaQuery لجعل الصفحة متناسقة مع جميع قياسات الشاشات.
    final MediaQueryData media = MediaQuery.of(context);
    final double screenW = media.size.width;
    final double screenH = media.size.height;
    const double refW = 375.0;
    const double refH = 812.0;
    final double wScale = (screenW / refW).clamp(0.70, 1.40);
    final double hScale = (screenH / refH).clamp(0.75, 1.30);
    final double ui = ((wScale + hScale) / 2).clamp(0.75, 1.35);

    final double padding = 18 * ui;
    final double h2Size = 18 * ui;
    final double pSize = 14 * ui;
    final double dateSize = 12 * ui;

    return Obx(() {
      // 🟢 قراءة كل القيم التفاعلية داخل Obx ليُحدَّث الـ UI تلقائياً.
      final bool isArabic = controller.isArabic;
      final String lang = controller.lang.value;
      final PrivacyPolicyData? data = controller.data.value;
      final bool loading = controller.loading.value;

      // اتجاه الصفحة يتبع اللغة: RTL للعربية، LTR للإنجليزية.
      final TextDirection pageDir = isArabic
          ? TextDirection.rtl
          : TextDirection.ltr;

      return Directionality(
        textDirection: pageDir,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.color1,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Text(
              data == null
                  ? (isArabic ? 'جاري التحميل...' : 'Loading...')
                  : data.title.get(lang),
              style: TextStyle(
                fontFamily: _fontFamily(),
                fontSize: 18 * ui,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            // 🟢 زر جانبي بديل في الـ AppBar — دائماً متاح
            actions: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.color3,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: data == null ? null : controller.toggleLang,

                  child: Text(
                    controller.otherLangLabel,
                    style: TextStyle(
                      fontFamily: _fontFamily(),
                      fontSize: 14 * ui,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8 * ui),
            ],
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : data == null
              ? Center(
                  child: Text(
                    isArabic ? 'تعذر تحميل السياسة' : 'Failed to load',
                    style: TextStyle(
                      fontFamily: _fontFamily(),
                      fontSize: pSize,
                      color: AppColors.color1,
                    ),
                  ),
                )
              : _buildBody(
                  controller: controller,
                  data: data,
                  padding: padding,
                  h2Size: h2Size,
                  pSize: pSize,
                  dateSize: dateSize,
                  ui: ui,
                  isArabic: isArabic,
                ),
        ),
      );
    });
  }

  Widget _buildBody({
    required PrivacyController controller,
    required PrivacyPolicyData data,
    required double padding,
    required double h2Size,
    required double pSize,
    required double dateSize,
    required double ui,
    required bool isArabic,
  }) {
    final TextStyle heading2 = TextStyle(
      fontFamily: _fontFamily(),
      fontSize: h2Size,
      fontWeight: FontWeight.w800,
      color: AppColors.color1,
    );
    final TextStyle paragraph = TextStyle(
      fontFamily: _fontFamily(),
      fontSize: pSize,
      color: Colors.black87,
      height: 1.6,
    );
    final TextStyle date = TextStyle(
      fontFamily: _fontFamily(),
      fontSize: dateSize,
      color: AppColors.color2,
      fontWeight: FontWeight.w700,
    );
    final TextStyle bullet = paragraph.copyWith(height: 1.5);

    // اللغة الحالية — تُقرأ من Rx في كل بناء ليُحدَّث المحتوى.
    final String lang = controller.lang.value;

    final widgets = <Widget>[];

    // مقدمة (intro) — فقرات فقط
    for (final block in data.intro) {
      if (block.type == 'paragraph') {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12 * ui),
            child: Text(
              block.text(lang),
              style: paragraph,
              textAlign: TextAlign.justify,
            ),
          ),
        );
      }
    }

    // فاصل + تاريخ السريان
    widgets.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10 * ui),
        child: Text(
          (isArabic ? 'تاريخ السريان: ' : 'Effective Date: ') +
              data.effectiveDate.get(lang),
          style: date,
        ),
      ),
    );

    // الأقسام
    for (final section in data.sections) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(top: 14 * ui, bottom: 6 * ui),
          child: Text(section.title.get(lang), style: heading2),
        ),
      );

      for (final block in section.content) {
        if (block.type == 'paragraph') {
          widgets.add(
            Padding(
              padding: EdgeInsets.only(bottom: 10 * ui),
              child: Text(
                block.text(lang),
                style: paragraph,
                textAlign: TextAlign.justify,
              ),
            ),
          );
        } else if (block.type == 'list') {
          for (final item in block.list(lang)) {
            widgets.add(
              Padding(
                padding: EdgeInsets.only(
                  right: 8 * ui,
                  left: 8 * ui,
                  bottom: 6 * ui,
                ),
                child: Text(
                  '• $item',
                  style: bullet,
                  textAlign: TextAlign.justify,
                ),
              ),
            );
          }
        }
      }
    }

    // آخر تحديث
    widgets.add(
      Padding(
        padding: EdgeInsets.only(top: 18 * ui, bottom: 4 * ui),
        child: Text(
          (isArabic ? 'آخر تحديث: ' : 'Last updated: ') +
              data.lastUpdated.get(lang),
          style: date,
        ),
      ),
    );

    widgets.add(SizedBox(height: 100 * ui)); // مساحة للـ FAB

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          padding,
          padding,
          padding,
          padding + 80 * ui, // مساحة للـ FAB العائم
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }
}
