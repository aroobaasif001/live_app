import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/registration_entity.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';


class CategoryTabs extends StatelessWidget {
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: RegistrationEntity.doc(userId: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        var registrationEntity = snapshot.data!.data();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                min(4, registrationEntity!.interests!.length),
                    (index) {
              return Obx(() => Padding(
                    padding: EdgeInsets.only(right: 10,top: 10,bottom: 10),
                    child: CustomGradiantTabButton(
                      text: registrationEntity.interests![index],
                      isSelected: selectedIndex.value == index,
                      onPressed: () => selectedIndex.value = index,
                    ),
                  ));
            }),
          ),
        );
      }
    );
  }
}