import 'dart:math';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection("UserEntity")
          .doc(FirebaseAuth.instance.currentUser!.uid) // Use dynamic user ID here
          .get();

      if (userDoc.exists) {
        var interests = userDoc.data()?['interests'] ?? [];
        if (interests is List) {
          setState(() {
            categories = List<String>.from(interests);
            applyFilter(0); // Default filter (Recommended)
          });
        }
      }
    } catch (e) {
      print("Error fetching interests: $e");
    }
  }

  void applyFilter(int index) {
    setState(() {
      selectedTabIndex = index;
      if (index == 0) {
        // Recommended: Pick random items (for now)
        filteredCategories = categories..shuffle();
      } else if (index == 1) {
        // Popular: Simulate popularity filter
        filteredCategories = categories..shuffle();
      } else {
        // A-Z: Sort alphabetically
        filteredCategories = List.from(categories)..sort();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCategoriesTab();
  }

  Widget _buildCategoriesTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "Search by category",
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 8),
            ButtonsTabBar(
              unselectedBackgroundColor: Colors.white,
              borderWidth: 0,
              unselectedBorderColor: Colors.transparent,
              borderColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: primaryGradientColor,
              ),
              tabs: [
                Tab(text: "Recommended"),
                Tab(text: "Popular"),
                Tab(text: "A-Z"),
              ],
              onTap: applyFilter, // Apply filter on tab change
            ),
            SizedBox(
              height: 500,
              child: _buildCategoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return filteredCategories.isEmpty
        ? const Center(child: CircularProgressIndicator()) // Show loading indicator
        : ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductsPage(category: filteredCategories[index]),
              ),
            );
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
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          watchVerticalImage,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: filteredCategories[index],
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xffFFFFFF),
                            ),
                          ],
                        ),
                        const Spacer(),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
