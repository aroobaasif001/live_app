import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/view/find_friendsd.dart';
import '../../../custom_widgets/custom_text.dart';
import 'message_list_screen.dart';
import 'feature_activity_screen.dart';
import 'purchase_activity_screen.dart';
import 'rates_activity_search_screen.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          text: "activity".tr,
          color: Colors.black,
          fontFamily: 'SF Pro Rounded',
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(()=>FindFriendsScreen());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 1, color: Color(0xffCACACA)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Image.asset(findfriendsIcon, height: 18),
                    SizedBox(width: 10),
                    CustomText(text: 'find_friends'.tr),
                  ],
                ),
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(child: CustomText(text: "purchases".tr, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Gilroy-Bold')),
            Tab(child: CustomText(text: "rates".tr, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Gilroy-Bold')),
            Tab(child: CustomText(text: "messages".tr, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Gilroy-Bold')),
            Tab(child: CustomText(text: "featured".tr, fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Gilroy-Bold')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PurchaseActivityScreen(currentUserId: FirebaseAuth.instance.currentUser!.uid,
          ),
          RatesActivitySearchScreen(),
          MessagesList(),
          FeatureActivityScreen()
        ],
      ),
    );
  }
}