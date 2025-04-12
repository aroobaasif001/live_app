import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class CustomReview extends StatelessWidget {
  final String value;
  final String label;
  final String? iconPath;

  const CustomReview({
    super.key,
    required this.value,
    required this.label,
    this.iconPath,  // Optional icon
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            if (iconPath != null)
              CustomContainer(
                width: 18,
                height: 18,
                image: DecorationImage(image: AssetImage(iconPath!),),
              ),  // Show icon only if it's provided
            if (iconPath != null) SizedBox(width: 3), // Space between icon and value if icon is shown
            CustomText(
              text: value,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        CustomText(
          text: label,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
