import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String iconPath;
  final Color? backgroundColor;
  final Color? textColor;
  final double width;
  final double height;
  final double borderRadius;

  const CustomIconButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.iconPath,
    this.backgroundColor = Colors.white,
    this.textColor,
    this.width = 300,
    this.height = 50,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      onPressed: onPressed,
      height: height,
      minWidth: width,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(iconPath)),
            ),
          ),
          const SizedBox(width: 10),
          CustomText(
            text: text,
              fontFamily: 'Gilroy',
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
          ),
        ],
      ),
    );
  }
}
