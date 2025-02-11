import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/colors.dart';

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
    'Shoes': ['Sneakers', 'Trainers', 'Boots', 'Sandals'],
    'Electronics': [
      'Smartphones',
      'Headphones',
      'Computers',
      'Tablets',
      'Cameras',
      'Speakers',
      'Monitors'
    ],
    'Beauty': [
      'Skincare',
      'Makeup',
      'Fragrances',
      'Haircare',
      'Nail Care',
      'Tools',
      'Accessories'
    ],
  };

  final Set<String> selectedDetailedInterests = {};
  bool isLoading = false;

  /// **📝 Save detailed interests to Firestore**
  Future<void> _updateUserInterests() async {
    if (selectedDetailedInterests.isEmpty) {
      Get.snackbar("Error", "Please select at least one detailed interest.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // **Get current user ID**
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // **Update Firestore document**
      await RegistrationEntity.doc(userId: userId).update({
        'detailedInterests': selectedDetailedInterests.toList(), // ✅ New field
      });

      Get.snackbar("Success", "Interests updated successfully!");


    } catch (e) {
      Get.snackbar("Error", "Failed to update interests: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  /// **🚀 Skip and move forward without saving interests**
  void _skipAndContinue() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Back',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFProRounded',
        ),
        actions: [
          GestureDetector(
            onTap: _skipAndContinue, // ✅ Skip without updating Firestore
            child: Row(
              children: [
                CustomText(
                  text: 'Skip',
                  fontSize: 16,
                  color: Colors.black,
                ),
                Icon(Icons.keyboard_double_arrow_right_rounded),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Tell us a little more',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProRounded',
              ),
              SizedBox(height: 8),
              CustomText(
                text: 'Choose what interests you',
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'MontserratAlternates',
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: widget.interests!
                      .where((category) =>
                      detailedInterestOptions.containsKey(category))
                      .map((category) {
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
                          children: detailedInterestOptions[category]!
                              .map((item) {
                            final isSelected =
                            selectedDetailedInterests.contains(item);
                            return ChoiceChip(
                              label: CustomText(
                                text: item,
                                fontSize: 14,
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
              CustomGradientButton(
                text: isLoading ? "Updating..." : "Continue",
                onPressed: isLoading ? () {} : _updateUserInterests, // ✅ Save only if items are selected
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}



///

// import 'package:flutter/material.dart';
// import 'package:live_app/custom_widgets/custom_gradient_button.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import 'package:live_app/utils/colors.dart';
//
// class InterestsDetailScreen extends StatefulWidget {
//   final String? country;
//   final String? gender;
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? password;
//   final String? city;
//   final String? street;
//   final String? house;
//   final String? apartment;
//   final String? entrance;
//   final String? index;
//   final List<String>? interests;
//
//   const InterestsDetailScreen({
//     super.key,
//     this.country,
//     this.gender,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.password,
//     this.city,
//     this.street,
//     this.house,
//     this.apartment,
//     this.entrance,
//     this.index,
//     this.interests,
//   });
//
//   @override
//   _InterestsDetailScreenState createState() => _InterestsDetailScreenState();
// }
//
// class _InterestsDetailScreenState extends State<InterestsDetailScreen> {
//   final Map<String, List<String>> interests = {
//     'Shoes': ['Sneakers', 'Trainers', 'Boots', 'Sandals'],
//     'Electronics': [
//       'Smartphones',
//       'Headphones',
//       'Computers',
//       'Tablets',
//       'Cameras',
//       'Speakers',
//       'Monitors'
//     ],
//     'Beauty': [
//       'Skincare',
//       'Makeup',
//       'Fragrances',
//       'Haircare',
//       'Nail Care',
//       'Tools',
//       'Accessories'
//     ],
//   };
//
//   final Set<String> selectedItems = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: CustomText(
//           text: 'Back',
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           fontFamily: 'SFProRounded',
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               // Skip action
//             },
//             child: Row(
//               children: [
//                 CustomText(
//                   text: 'Skip',
//                   fontSize: 16,
//                   color: Colors.black,
//                 ),
//                 Icon(Icons.keyboard_double_arrow_right_rounded),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               CustomText(
//                 text: 'Tell us a little more',
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'SFProRounded',
//               ),
//               SizedBox(height: 8),
//               // Subtitle
//               CustomText(
//                 text: 'Choose what interests you',
//                 fontSize: 16,
//                 color: Colors.grey,
//                 fontFamily: 'MontserratAlternates',
//               ),
//               SizedBox(height: 20),
//               // Interests list
//               Expanded(
//                 child: ListView(
//                   children: interests.entries.map((entry) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text: entry.key,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         SizedBox(height: 10),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: entry.value.map((item) {
//                             final isSelected = selectedItems.contains(item);
//                             return ChoiceChip(
//                               label: CustomText(
//                                 text: item,
//                                 fontSize: 14,
//                               ),
//                               selected: isSelected,
//                               onSelected: (selected) {
//                                 setState(() {
//                                   if (selected) {
//                                     selectedItems.add(item);
//                                   } else {
//                                     selectedItems.remove(item);
//                                   }
//                                 });
//                               },
//                               selectedColor: Colors.blueAccent.withOpacity(0.2),
//                               backgroundColor: Color(0xff000000).withOpacity(0.03),
//                             );
//                           }).toList(),
//                         ),
//                         SizedBox(height: 20),
//                       ],
//                     );
//                   }).toList(),
//                 ),
//               ),
//               // Continue button
//               CustomGradientButton(
//                 text: 'Continue',
//                 onPressed: () {
//                   // Continue action
//                 },
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
