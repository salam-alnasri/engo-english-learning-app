import 'package:engo/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFab extends StatelessWidget {
  const CustomFab({super.key, required this.onPressed, this.label});

  final String? label;

  final dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.color1, //=========================
      child: const Icon(Icons.arrow_back, color: AppColors.color5), //========
    );
  }
}

class Note extends StatelessWidget {
  const Note({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Text(
        '© 2024 Engo. جميع الحقوق محفوظة.',
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.color1, //=========================
        ),
      ),
    );
  }
}
