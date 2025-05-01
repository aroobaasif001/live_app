import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/auth/interests_screen.dart';

class DeliveryAddressUpdateScreen extends StatefulWidget {
  final String? country;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final bool? isSignUpWithGoogle;

  const DeliveryAddressUpdateScreen({
    super.key,
    this.gender,
    this.country,
    this.isSignUpWithGoogle,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
  });

  @override
  State<DeliveryAddressUpdateScreen> createState() => _DeliveryAddressUpdateScreen();
}

class _DeliveryAddressUpdateScreen extends State<DeliveryAddressUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  Future<void> _fetchUserAddress() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await RegistrationEntity.doc(userId: userId).get();

      if (userDoc.exists) {
        final registrationData = userDoc.data();
        if (registrationData != null) {
          setState(() {
            _countryController.text = registrationData.country ?? widget.country ?? '';
            _cityController.text = registrationData.city ?? '';
            _streetController.text = registrationData.street ?? '';
            _houseController.text = registrationData.house ?? '';
            _apartmentController.text = registrationData.apartment ?? '';
            _entranceController.text = registrationData.entrance ?? '';
            _indexController.text = registrationData.index ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching address: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Create a RegistrationEntity with updated address data
      final updatedData = RegistrationEntity(
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        street: _streetController.text.trim(),
        house: _houseController.text.trim(),
        apartment: _apartmentController.text.trim(),
        entrance: _entranceController.text.trim(),
        index: _indexController.text.trim(),
      );

      // Update using the model's document reference
      await RegistrationEntity.doc(userId: userId).update(updatedData.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address saved successfully')),
      );

      // Navigate back instead of going to next screen
      Navigator.pop(context);
      
    } catch (e) {
      print('Error saving address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: CustomText(
          text: 'delivery_address'.tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
      ),
      body: SafeArea(
        child: isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        CustomTextField(
                          controller: _countryController,
                          hintText: 'country'.tr,
                          readOnly: true,
                          validator: (value) =>
                              value!.isEmpty ? 'enter_country'.tr : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'city'.tr,
                          controller: _cityController,
                          validator: (value) =>
                              value!.isEmpty ? 'enter_city'.tr : null,
                        ),
                        SizedBox(height: 20),
                        CustomTextField(
                          hintText: 'street'.tr,
                          controller: _streetController,
                          validator: (value) =>
                              value!.isEmpty ? 'enter_street'.tr : null,
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: CustomTextField(
                                  hintText: 'house'.tr,
                                  controller: _houseController,
                                  validator: (value) =>
                                      value!.isEmpty ? 'enter_house'.tr : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: CustomTextField(
                                  hintText: 'apartment'.tr,
                                  controller: _apartmentController,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: CustomTextField(
                                  hintText: 'entrance'.tr,
                                  controller: _entranceController,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: CustomTextField(
                                  hintText: 'index'.tr,
                                  controller: _indexController,
                                  validator: (value) =>
                                      value!.isEmpty ? 'enter_index'.tr : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CustomGradientButton(
                  text: 'save'.tr,
                  onPressed: _saveAddress,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}