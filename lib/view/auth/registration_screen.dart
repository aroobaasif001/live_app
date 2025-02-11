import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';



class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? country;
  String? gender;
  bool isAgreedToTerms = false;
  bool isAbove18 = false;

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!isAgreedToTerms || !isAbove18) {
      Get.snackbar("Error", "You must accept the terms and confirm your age.");
      return;
    }

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String docId = userCredential.user!.uid;
      RegistrationEntity registrationEntity = RegistrationEntity(
        regId: docId,
        country: country,
        gender: gender,
        email: _emailController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      await RegistrationEntity.doc(userId: docId).set(registrationEntity);

      Get.snackbar("Success", "Registration completed successfully!");
      setState(() {
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        country = null;
        gender = null;
        isAgreedToTerms = false;
        isAbove18 = false;
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'First Name',
                  controller: _firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Last Name',
                  controller: _lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                        .hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true, // ✅ Enables visibility toggle
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: InputDecoration(
                    hintText: "Select Gender",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: country,
                  decoration: InputDecoration(
                    hintText: "Select Country",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  items: ['Russia', 'USA', 'India']
                      .map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      country = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAgreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          isAgreedToTerms = value!;
                        });
                      },
                    ),
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
                    Checkbox(
                      value: isAbove18,
                      onChanged: (value) {
                        setState(() {
                          isAbove18 = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: CustomText(
                        text: 'I confirm that I am over 18 years old',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'Continue',
                  onPressed: _registerUser,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

