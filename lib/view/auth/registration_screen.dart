import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Registration',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Name field
              CustomTextField(hintText: 'First Name'),
              SizedBox(height: 20),
              // Last Name field
              CustomTextField(hintText: 'Last Name'),
              SizedBox(height: 20),
              // Email field
              CustomTextField(hintText: 'Email'),
              SizedBox(height: 20),
              // Password field
              CustomTextField(
                hintText: 'Password',
                suffixIcon: CustomContainer(
                  height: 18,
                  width: 18,
                  image: DecorationImage(image: AssetImage(eyeCloseIcon),scale: 3),
                ),
              ),
              SizedBox(height: 20),
              // Gender dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                  ),
                  fillColor: Colors.white,
                  filled: true
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              // Country dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                  ),
                    fillColor: Colors.white,
                    filled: true
                ),

                items: ['Russia', 'USA', 'India']
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              // Terms and conditions
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Expanded(
                    child: CustomText(
                      text:
                          'I agree to the Terms of Service and Privacy Policy',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  Expanded(
                    child: CustomText(
                      text: 'I confirm that I am over 18 years old',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Continue button
              CustomGradientButton(
                text: 'Continue',
                onPressed: () {
                  Get.to(()=> DeliveryAddressScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
} 