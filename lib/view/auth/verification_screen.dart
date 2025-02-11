import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              // Title
              CustomText(
                text: 'Enter Code',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 20),
              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: CustomContainer(
                      width: 53,
                      height: 68,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                        conColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      child: Center(
                        child: CustomText(
                          text: '0',
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 20),
              // Message
              CustomText(
                text: 'We have sent you a code via email',
                fontSize: 14,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              Spacer(),
              // Login button
              CustomGradientButton(
                text: 'Login', onPressed: () {
              },),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 