import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Terms And Conditions'),
      ),
    );
  }
}