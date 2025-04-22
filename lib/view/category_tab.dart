import 'dart:math';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../categorize_prod.dart';
import '../custom_widgets/custom_text.dart';
import '../utils/colors.dart';
import '../utils/images_path.dart';



class CategoriesTab extends StatefulWidget {
  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<String> categories = [];
  List<String> filteredCategories = [];
  Map<String, String> categoryImages = {}; // <category, imageURL>
  int selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategoriesFromProducts();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> fetchCategoriesFromProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("products").get();
      final docs = snapshot.docs;

      final Map<String, String> tempCategoryImages = {};
      final Set<String> tempCategories = {};

      for (var doc in docs) {
        final category = doc['category']?.toString();
        final images = (doc['images'] as List?)?.cast<String>() ?? [];

        if (category != null && category.isNotEmpty) {
          tempCategories.add(category);
          if (!tempCategoryImages.containsKey(category) && images.isNotEmpty) {
            tempCategoryImages[category] = images[0];
          }
        }
      }

      setState(() {
        categories = tempCategories.toList();
        categoryImages = tempCategoryImages;
        applyFilter(0);
      });
    } catch (e) {
      print("Error fetching categories from products: $e");
    }
  }

  // void applyFilter(int index) {
  //   setState(() {
  //     selectedTabIndex = index;

  //     if (index == 0) {
  //       filteredCategories = List.from(categories)..shuffle();
  //     } else if (index == 1) {
  //       filteredCategories = List.from(categories)..shuffle();
  //     } else {
  //       filteredCategories = List.from(categories)..sort();
  //     }

  //     _filterSearch(_searchController.text); // Re-apply search after filtering
  //   });
  // }
void applyFilter(int index) {
  setState(() {
    selectedTabIndex = index;

    if (index == 0) {
      // 🟢 Recommended: Shuffle (random order)
      filteredCategories = List.from(categories)..shuffle();
    } else if (index == 1) {
      // 🔴 Popular: Reverse order (simulate most viewed)
      filteredCategories = List.from(categories.reversed);
    } else {
      // 🔵 A-Z: Alphabetical sort
      filteredCategories = List.from(categories)..sort((a, b) => a.compareTo(b));
    }

    // 🔁 Apply search filter again to current list
    _filterSearch(_searchController.text);
  });
}


void _filterSearch(String query) {
  final lowerQuery = query.toLowerCase();

  List<String> baseList;
  if (selectedTabIndex == 0) {
    baseList = List.from(categories)..shuffle();
  } else if (selectedTabIndex == 1) {
    baseList = List.from(categories.reversed);
  } else {
    baseList = List.from(categories)..sort();
  }

  setState(() {
    filteredCategories = baseList.where((cat) => cat.toLowerCase().contains(lowerQuery)).toList();
  });
}

// void _filterSearch(String query) {
//   if (query.isEmpty) {
//     setState(() {
//       filteredCategories = List.from(categories);
//     });
//     return;
//   }

//   final lowercaseQuery = query.toLowerCase();
//   setState(() {
//     filteredCategories = categories.where((category) {
//       return category.toLowerCase().contains(lowercaseQuery);
//     }).toList();
//   });
// }


  @override
Widget build(BuildContext context) {
  return DefaultTabController(
    length: 3,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: _searchController,
            onChanged: _filterSearch,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search by category',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: 'Gilroy-Medium',
                color: Colors.grey,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomText(
            text: "search_by_category".tr,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),

        ButtonsTabBar(
          unselectedBackgroundColor: Colors.white,
          borderWidth: 0,
          borderColor: Colors.transparent,
          unselectedBorderColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: primaryGradientColor,
          ),
          tabs: [
            Tab(text: "recommended".tr),
            Tab(text: "popular".tr),
            Tab(text: "a_z".tr),
          ],
          onTap: applyFilter,
        ),

        const SizedBox(height: 8),

        // 🟢 Scrollable list
        Expanded(
          child: filteredCategories.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final imageUrl = categoryImages[category];

                    return GestureDetector(
                      onTap: () {
                        Get.to(()=> ProductsPage(category: category));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: primaryGradientColor,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        width: 100,
                                        height: 95,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        watchVerticalImage,
                                        width: 100,
                                        height: 95,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: category,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xffFFFFFF),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/wave.png',
                                          height: 20,
                                        ),
                                        const SizedBox(width: 40),
                                        const CustomText(
                                          text: '1.3k',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffFFFFFF),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
}