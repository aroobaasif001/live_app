import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool isSignUpWithGoogle;

  const RegistrationScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.isSignUpWithGoogle = false,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  String? country;
  String? gender;
  bool isAgreedToTerms = false;
  bool isAbove18 = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.lastName ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _passwordController = TextEditingController(text: widget.password ?? '');
  }

  double _passwordStrength = 0.0;
  String _passwordStrengthText = "";
  void _updatePasswordStrength(String password) {
    if (password.isEmpty) {
      _passwordStrength = 0.0;
      _passwordStrengthText = "";
    } else if (password.length < 6) {
      _passwordStrength = 0.2;
      _passwordStrengthText = "Weak";
    } else if (password.length < 8) {
      _passwordStrength = 0.4;
      _passwordStrengthText = "Fair";
    } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
      _passwordStrength = 0.6;
      _passwordStrengthText = "Good";
    } else if (RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])')
        .hasMatch(password)) {
      _passwordStrength = 0.8;
      _passwordStrengthText = "Very Good";
    } else if (password.length >= 10 &&
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])')
            .hasMatch(password)) {
      _passwordStrength = 1.0;
      _passwordStrengthText = "Strong";
    }
  }

  void _storeUser() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "Error",
        "Please fix the errors in the form.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white, // 👈 Softer background
        colorText: Colors.red, // 👈 Red text for warning
        icon: const Icon(Icons.error_outline, color: Colors.red), // 👈 Red icon
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      return;
    }

    if (!isAgreedToTerms || !isAbove18) {
      Get.snackbar(
        "Error",
        "You must agree to the terms and confirm your age.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
        icon: const Icon(Icons.warning_amber_outlined, color: Colors.red),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );

      return;
    }

    try {
      Get.to(() => DeliveryAddressScreen(
            country: country,
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            gender: gender,
            password: _passwordController.text.trim(),
            isSignUpWithGoogle: widget.isSignUpWithGoogle,
          ));
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email.';
    if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
        .hasMatch(value)) {
      return 'Please enter a valid email.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password.';
    if (value.length < 8) return 'Password must be at least 8 characters.';
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one digit.';
    }
    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: CustomText(
          text: 'Register',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Get.back(),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  CustomTextField(
                    isRequired: true,
                    hintText: 'First Name',
                    controller: _firstNameController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter first name'
                        : null,
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    isRequired: true,
                    hintText: 'Last Name',
                    controller: _lastNameController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter last name'
                        : null,
                  ),
                  SizedBox(height: 15),
                  // CustomTextField(
                  //   isRequired: true,
                  //   hintText: 'Email',
                  //   controller: _emailController,
                  //   validator: _validateEmail,
                  // ),
                  CustomTextField(
                    isRequired: true,
                    hintText: 'Email',
                    controller: _emailController,
                    validator: _validateEmail,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => setState(() {}),
                  ),

                  SizedBox(height: 15),
                  if (!widget.isSignUpWithGoogle)
                    if (!widget.isSignUpWithGoogle)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            isRequired: true,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'Password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: _validatePassword,
                            onChanged: (value) {
                              setState(() {
                                _updatePasswordStrength(value);
                              });
                            },
                          ),

                          /// 👇 Password rule hint
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                            child: Text(
                              "Password must be at least 6 characters,\ninclude a capital letter and a special character.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                  SizedBox(
                    height: 10,
                  ),
                  // CustomTextField(
                  //   suffixIcon: IconButton(
                  //     onPressed: () {
                  //       setState(() {
                  //         _obscurePassword = !_obscurePassword;
                  //       });
                  //     },
                  //     icon: Icon(
                  //       _obscurePassword
                  //           ? Icons.visibility_off
                  //           : Icons.visibility,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  //   hintText: 'Password',
                  //   controller: _passwordController,
                  //  obscureText: _obscurePassword,
                  //   validator: _validatePassword,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _updatePasswordStrength(value);
                  //     });
                  //   },
                  // ),
                  LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _passwordStrength < 0.3
                          ? Colors.red
                          : _passwordStrength < 0.6
                              ? Colors.orange
                              : _passwordStrength < 0.9
                                  ? Colors.blue
                                  : Colors.green,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _passwordStrengthText,
                    style: TextStyle(
                      color: _passwordStrength < 0.3
                          ? Colors.red
                          : _passwordStrength < 0.6
                              ? Colors.orange
                              : _passwordStrength < 0.9
                                  ? Colors.blue
                                  : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: InputDecoration(
                      hintText: 'Select Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => gender = value),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: country,
                    decoration: InputDecoration(
                      hintText: 'Select Country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey[100],
                      filled: true,
                    ),
                    items: ['Russia', 'USA', 'India']
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => country = value),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      buildGradientCheckbox(isAgreedToTerms, () {
                        setState(() => isAgreedToTerms = !isAgreedToTerms);
                      }),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                    // decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy-Medium'),
                              ),
                              TextSpan(
                                text: ' and confirm I have read the ',
                                style: TextStyle(
                                    // decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    fontFamily: 'Gilroy-Medium'),
                              ),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Gilroy-Medium'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      buildGradientCheckbox(isAbove18, () {
                        setState(() => isAbove18 = !isAbove18);
                      }),
                      Expanded(
                        child: Text(
                          'I confirm that I am over 18 years of age',
                          style: TextStyle(
                              // decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              fontFamily: 'Gilroy-Medium'),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: isAgreedToTerms,
                  //       onChanged: (value) =>
                  //           setState(() => isAgreedToTerms = value!),
                  //     ),
                  //     Expanded(child: CustomText(text: 'Agree to terms')),
                  //   ],
                  // ),
                  // Row(
                  //   children: [
                  //     Checkbox(
                  //       value: isAbove18,
                  //       onChanged: (value) =>
                  //           setState(() => isAbove18 = value!),
                  //     ),
                  //     Expanded(child: CustomText(text: 'Confirm age')),
                  //   ],
                  // ),
                  SizedBox(height: 20),
                  CustomGradientButton(
                    text: 'Continue',
                    onPressed: _storeUser,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGradientCheckbox(bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // Outer ring is white
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [blueLiteColor, purpleLiteColor, deepPurpleColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
