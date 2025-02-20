import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';

class CategoryTabs extends StatelessWidget {
  final RxInt selectedIndex = 0.obs; 

  final List<String> categories = [
    "for_you".tr,
    "subscriptions".tr,
    "electronics".tr,
    "cloth_category".tr
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Obx(() => Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CustomGradiantTabButton(
                    text: categories[index],
                    isSelected: selectedIndex.value == index,
                    onPressed: () => selectedIndex.value = index,
                  ),
                ));
          }),
        ),
      ),
    );
  }
} 