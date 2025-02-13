import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/images_path.dart';

class CustomTable extends StatelessWidget {
  final String leftText;
  final String rightText;
  final Color? conColor;
  final String? image;

  // Constructor with an optional color
  CustomTable({
    super.key,
    required this.leftText,
    required this.rightText,
    this.conColor,
    this.image, // Optional color
  });

  @override
  Widget build(BuildContext context) {
    // Set default color if conColor is null
    Color backgroundColor = (conColor ?? const Color(0xff000000)).withOpacity(0.03);

    return Row(
      children: [
        Flexible(
          flex: 1,
          child: CustomContainer(
            height: 44,
            conColor: backgroundColor, // Apply the resolved color
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: leftText,
              fontSize: 14,
              fontFamily: 'Gilroy',
            ),
          ),
        ),
        Flexible(
          child: CustomContainer(
            height: 44,
            conColor: backgroundColor, // Apply the same resolved color
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image != null?CustomContainer(
                  height: 20,
                  width: 20,
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage(appleGBlackImage)),
                ):SizedBox(),
                image != null?SizedBox(width: 5):SizedBox(),
                CustomText(
                  text: rightText,
                  fontSize: 14,
                  color: image != null? Color(0xff815BFF):null,
                  fontFamily: 'Gilroy',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
