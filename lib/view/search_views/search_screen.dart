import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/view/find_friendsd.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';
import 'package:live_app/view/market/tabs/product_detail/product_detail_screen.dart';
import 'package:live_app/view/search_views/search_by_application.dart';
import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/icons_path.dart';
import '../../utils/images_path.dart';
import '../category_tab.dart';
import '../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import '../homeScreen/widgets/live_video_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // Search Bar
              Container(
                //height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  onTap: () {
                    // Opens "SearchByApplication" screen
                    Get.to(() => const SearchByProduct());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'search'.tr,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                  textAlignVertical: TextAlignVertical.center, // Vertically center the text
                ),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 12),
              Expanded(
                child: CategoriesTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }



}




