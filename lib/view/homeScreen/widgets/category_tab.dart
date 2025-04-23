import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/registration_entity.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';

class CategoryTabs extends StatefulWidget {
  final Function(String?) onCategorySelected; // Accepts null for "All"

  const CategoryTabs({required this.onCategorySelected, Key? key}) : super(key: key);

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  int selectedIndex = 0;
  List<String> categories = ['All']; // Start with "All"

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<RegistrationEntity>>(
      stream: RegistrationEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Center(child: Text('No interests found'));
        }

        final interests = snapshot.data!.data()!.interests ?? [];

        // Only update once to prevent constant rebuilds
        if (categories.length == 1 || categories.length != interests.length + 1) {
          categories = ['All', ...interests];
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(min(5, categories.length), (index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CustomGradiantTabButton(
                  text: category.tr,
                  isSelected: selectedIndex == index,
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onCategorySelected(category == 'All' ? null : category);
                  },
                ),
              );
            }),
          ),
        );
      },
    );
  }
}


// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/entities/registration_entity.dart';
// import '../../../custom_widgets/custom_gradiant_tab_button.dart';

// class CategoryTabs extends StatelessWidget {
//   final RxInt selectedIndex = 0.obs;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot<RegistrationEntity>>(
//       stream: RegistrationEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid)
//           .snapshots(),
//       builder: (context, snapshot) {
//         // Show a loading indicator while waiting for data.
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         // Check for errors or missing data.
//         if (!snapshot.hasData || snapshot.data?.data() == null) {
//           return Center(child: Text('No data available'));
//         }

//         // Safely retrieve the registration entity.
//         final registrationEntity = snapshot.data!.data()!;
//         final interests = registrationEntity.interests;

//         // Check if interests exist.
//         if (interests == null || interests.isEmpty) {
//           return Center(child: Text('No interests found'));
//         }

//         // Generate tabs for a maximum of 4 interests.
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               min(4, interests.length),
//                   (index) {
//                 return Obx(() => Padding(
//                   padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
//                   child: CustomGradiantTabButton(
//                     text: interests[index].tr,
//                     isSelected: selectedIndex.value == index,
//                     onPressed: () => selectedIndex.value = index,
//                   ),
//                 ));
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }



///


// import 'dart:math';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/entities/registration_entity.dart';
// import '../../../custom_widgets/custom_gradiant_tab_button.dart';
//
//
// class CategoryTabs extends StatelessWidget {
//   final RxInt selectedIndex = 0.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: RegistrationEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid).snapshots(),
//       builder: (context, snapshot) {
//         var registrationEntity = snapshot.data!.data();
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//                 min(4, registrationEntity!.interests!.length),
//                     (index) {
//               return Obx(() => Padding(
//                     padding: EdgeInsets.only(right: 10,top: 10,bottom: 10),
//                     child: CustomGradiantTabButton(
//                       text: registrationEntity.interests![index],
//                       isSelected: selectedIndex.value == index,
//                       onPressed: () => selectedIndex.value = index,
//                     ),
//                   ));
//             }),
//           ),
//         );
//       }
//     );
//   }
// }