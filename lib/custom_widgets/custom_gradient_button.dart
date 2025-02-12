import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;

  const CustomGradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 52,
    this.borderRadius = 10,
    this.fontSize=16
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [blueLiteColor, purpleLiteColor,deepPurpleColor],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent, // Makes sure ripple effect is visible
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Center(
            child: Text(
              text,
              style:  TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,


              ),
            ),
          ),
        ),
      ),
    );
  }
}
