import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Privacy Policy'),
      ),
    );
  }
}