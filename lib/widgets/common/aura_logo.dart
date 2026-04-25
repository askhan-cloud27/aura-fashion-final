import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/app_colors.dart';

class AuraLogo extends StatelessWidget {
  final double fontSize;
  final Color? color;

  const AuraLogo({
    super.key,
    this.fontSize = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'AURA',
      style: GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.accent,
        letterSpacing: 12,
      ),
    );
  }
}
