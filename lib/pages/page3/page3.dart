import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// "رحلتك التعليمية" — vertical scrollable list of monthly learning
/// blocks. Each block is a [MonthSection] built from the data in
/// `lib/data/months_data.dart`.
///
/// To add a new month, append a new [MonthData] entry to the `months`
/// list inside `months_data.dart`.
class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F8FC),

      body: Center(
        child: Text(
          "...قريبا",
          style: GoogleFonts.cairo(fontSize: 30, color: AppColors.color1),
        ),
      ),
    );
  }
}
