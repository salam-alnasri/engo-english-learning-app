// ignore_for_file: use_build_context_synchronously

import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'privacy_policy_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../page1/roadmap/progress_service.dart';

class SettingsController extends GetxController {
  var vibrations = false.obs;
  var sounds = false.obs;
  var darkMode = false.obs;
  var removeAds = false.obs;
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
            'اعادة الضبط؟ ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.color1,
            ),
          ),
        ),
        content: Text(
          'هل انت متأكد من ذلك؟\nعند الضغط على نعم سيتم فقدان جميع التقدم والعودة بالمراحل من البداية.',
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
      Get.find<SettingsController>().vibrations.value = false;
      Get.find<SettingsController>().sounds.value = false;
      Get.find<SettingsController>().darkMode.value = false;
      Get.find<SettingsController>().removeAds.value = false;
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
    return Scaffold(
      backgroundColor: Colors.white, //==========================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'إعدادات التطبيق',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                ),
              ),
              _buildSection(
                children: [
                  _buildSwitchTile(
                    icon: Icons.waves_rounded,
                    title: 'Vibrations',
                    value: controller.vibrations,
                    onChanged: (val) => controller.vibrations.value = val,
                  ),
                  _buildSwitchTile(
                    icon: Icons.volume_up_rounded,
                    title: 'Sounds',
                    value: controller.sounds,
                    onChanged: (val) => controller.sounds.value = val,
                  ),
                  _buildSwitchTile(
                    icon: Icons.nightlight_round,
                    title: 'Dark mode',
                    value: controller.darkMode,
                    onChanged: (val) => controller.darkMode.value = val,
                  ),
                  _buildSwitchTile(
                    icon: Icons.block_rounded,
                    title: 'Remove ads',
                    value: controller.removeAds,
                    onChanged: (val) => controller.removeAds.value = val,
                  ),
                ],
              ),
              _buildSection(
                children: [
                  _buildSimpleTile(
                    icon: Icons.star_rounded,
                    title: 'قيمنا الان',
                    onTap: () => _launchRateUs(context),
                  ),
                  _buildSimpleTile(
                    icon: Icons.edit_rounded,
                    title: 'تواصل معنا',
                    onTap: () {},
                  ),
                ],
              ),
              _buildSection(
                children: [
                  _buildSimpleTile(
                    icon: Icons.restore_rounded,
                    title: 'اعادة ضبط التقدم',
                    onTap: () => _showRestoreDialog(context),
                  ),
                ],
              ),
              _buildSection(
                children: [
                  _buildSimpleTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy Policy',
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                ],
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required RxBool value,
    required void Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.color1, //===============

              size: 22,
            ),
            SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.color1, //=================
              ),
            ),
          ],
        ),
        Obx(
          () => Switch(
            value: value.value,
            onChanged: onChanged,
            activeThumbColor: AppColors.color1, //========================
            activeTrackColor: AppColors.color2,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.color1, //=========================
            size: 22,
          ),
          SizedBox(width: 14),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.color1, //===================
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.color5.withValues(alpha: .20), //====================
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...children.map(
            (w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: w,
            ),
          ),
        ],
      ),
    );
  }
}
