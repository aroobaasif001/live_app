import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/services/notification_service.dart';
import 'package:live_app/view/auth/notification_screen.dart';

class InterestsDetailScreen extends StatefulWidget {
  final String? country;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? city;
  final String? street;
  final String? house;
  final String? apartment;
  final String? entrance;
  final String? index;
  final List<String>? interests; // ✅ General categories selected

  const InterestsDetailScreen({
    super.key,
    this.country,
    this.gender,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.city,
    this.street,
    this.house,
    this.apartment,
    this.entrance,
    this.index,
    this.interests,
  });

  @override
  _InterestsDetailScreenState createState() => _InterestsDetailScreenState();
}

class _InterestsDetailScreenState extends State<InterestsDetailScreen> {
  final Map<String, List<String>> detailedInterestOptions = {
    'shoes'.tr: ['sneakers', 'trainers', 'boots', 'sandals'],
    'electronics'.tr: [
      'smartphones',
      'headphones',
      'computers',
      'tablets',
      'cameras',
      'speakers',
      'monitors'
    ],
    'beauty'.tr: [
      'skincare',
      'makeup',
      'fragrances',
      'haircare',
      'nail_care',
      'tools',
      'beauty_accessories'
    ],
  };

  final Set<String> selectedDetailedInterests = {};
  bool isLoading = false;

  /// **📝 Save detailed interests to Firestore**
  Future<void> _updateUserInterests() async {
    if (selectedDetailedInterests.isEmpty) {
      Get.snackbar("Error", "select_detailed_interest".tr);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // **Get current user ID**
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // **Update Firestore document**
      NotificationService notificationService = NotificationService();
      String? deviceToken = await notificationService.getDeviceToken();
      await RegistrationEntity.doc(userId: userId).update({
        'detailedInterests': selectedDetailedInterests.toList(),
        'fcmToken': deviceToken, // ✅ New field
      });

      Get.snackbar("Success", "interests_updated".tr);
      Get.offAll(() => NotificationScreen());
    } catch (e) {
      Get.snackbar("Error", "${'update_failed'.tr} $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  /// **🚀 Skip and move forward without saving interests**
  void _skipAndContinue() {
    Get.offAll(() => NotificationScreen());
  }

  // Add a method to get the base category key
  String getBaseCategoryKey(String translatedCategory) {
    if (translatedCategory == 'Обувь' || translatedCategory == 'Shoes')
      return 'shoes';
    if (translatedCategory == 'Электроника' ||
        translatedCategory == 'Electronics') return 'electronics';
    if (translatedCategory == 'Красота' || translatedCategory == 'Beauty')
      return 'beauty';
    return translatedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'back'.tr,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          // GestureDetector(
          //   onTap: _skipAndContinue, // ✅ Skip without updating Firestore
          //   child: Row(
          //     children: [
          //       CustomText(
          //         text: 'skip'.tr,
          //         fontSize: 16,
          //         color: Colors.black,
          //       ),
          //       Icon(Icons.keyboard_double_arrow_right_rounded),
          //     ],
          //   ),
          // ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'tell_more'.tr,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'choose_interests'.tr,
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: widget.interests!.where((category) {
                    String baseCategory = getBaseCategoryKey(category);
                    return detailedInterestOptions.containsKey(baseCategory.tr);
                  }).map((category) {
                    String baseCategory = getBaseCategoryKey(category);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: category,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: detailedInterestOptions[baseCategory.tr]!
                              .map((item) {
                            final isSelected =
                                selectedDetailedInterests.contains(item);
                            return ChoiceChip(
                              side: BorderSide(color: Colors.white),
                              label: CustomText(
                                text: item.tr, // Translate the item text
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFProRounded',
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedDetailedInterests.add(item);
                                  } else {
                                    selectedDetailedInterests.remove(item);
                                  }
                                });
                              },
                              selectedColor: Colors.blueAccent.withOpacity(0.2),
                              backgroundColor:
                                  Color(0xff000000).withOpacity(0.03),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // CustomGradientButton(
              //   text: isLoading ? "updating".tr : "continue".tr,
              //   onPressed: isLoading ? null : _updateUserInterests, // ✅ Save only if items are selected
              // ),
              CustomGradientButton(
                text: isLoading ? "updating".tr : "continue".tr,
                onPressed: (selectedDetailedInterests.isEmpty || isLoading)
                    ? null
                    : _updateUserInterests, // 👈 disable when empty or loading
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
