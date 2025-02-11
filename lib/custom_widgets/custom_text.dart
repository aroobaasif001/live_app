import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? height;
  final double? wordSpacing;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecorationStyle? decorationStyle;
  final String? fontFamily;

  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,
    this.color,
    this.textAlign,
    this.letterSpacing,
    this.maxLines,
    this.decorationStyle,
    this.overflow,
    this.height,
    this.wordSpacing,
    this.fontFamily = "MontserratAlternates",
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    // Use the specified font family
    switch (fontFamily) {
      case 'SFProRounded':
        textStyle = sfProRoundedTextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          wordSpacing: wordSpacing,
        );
        break;
      case 'MontserratAlternates':
        textStyle = montserratAlternatesTextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          wordSpacing: wordSpacing,
        );
        break;
      case 'Gilroy':
        textStyle = gilroyTextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          wordSpacing: wordSpacing,
        );
        break;
      default:
        textStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height,
          wordSpacing: wordSpacing,
        );
    }

    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle,
    );
  }

  // Helper method for SFProRounded text style
  static TextStyle sfProRoundedTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
  }) {
    return TextStyle(
      fontFamily: 'SFProRounded',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
    );
  }

  // Helper method for Montserrat Alternates text style
  static TextStyle montserratAlternatesTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
  }) {
    return GoogleFonts.montserratAlternates(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
    );
  }

  // Helper method for Gilroy text style
  static TextStyle gilroyTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    double? wordSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Gilroy',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      wordSpacing: wordSpacing,
    );
  }
}
