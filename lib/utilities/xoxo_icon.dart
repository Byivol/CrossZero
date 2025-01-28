import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class XoxoIcon extends StatelessWidget {
  const XoxoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => RadialGradient(
        colors: [Color(0xFFEB0057), Color(0xFFE38BAC)],
        radius: 1.0,
        center: Alignment.center,
      ).createShader(bounds),
      child: Text(
        'xoxo',
        style: GoogleFonts.varelaRound(
            fontWeight: FontWeight.normal, fontSize: 24, color: Colors.white),
      ),
    );
  }
}
