import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';
import '../../livestreaming/live_streaming.dart';
import '../../profile_views/create_a_product_screen.dart';
import '../../profile_views/my_products_screen.dart';
import '../../profile_views/profile_screen.dart';
import '../activityScreen/activity_screen.dart';
import '../../search_views/search_screen.dart';
import '../bottomNaviagtionBar/custom_bottom_bar.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  final RxInt selectedIndex = 0.obs;
  String? userId;
  int? uid;
  String? ChannelId;
  final List<Widget> screens = [
    HomeMainScreen(),
    SearchScreen(),
    SizedBox(), // Placeholder for the bottom sheet
    ActivityScreen(),
    ProfileScreen(),
  ];

  void _showSellBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Sell",
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GestureDetector(
                onTap: (){
                  Get.to(()=>CreateProductScreen());
                },
                  child: _buildOption(
                      context, Icons.local_offer, "Create a Product")),
              GestureDetector(
                  onTap: () async {
                    String title = 'Live Streaming';

                    if (title.isEmpty) {
                      // If title is empty, set a default title.
                      title = 'Live Streaming';
                    }

                    // Store live stream details in Firebase Firestore
                    try {
                      final liveStreamData = {
                        "title": title,
                        "adminName": 'Admin',
                        "adminPhoto":
                            'https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dGFraW5nJTIwcGhvdG98ZW58MHx8MHx8fDA%3D',
                        "adminUid": uid,
                        "isAdmin": true,
                        "channelId": ChannelId,
                        'viewsCount': 0,
                        'currentmusic': null,
                        'currentFilter': null,
                        'currentmusic_id': null,
                        'heartbeat': null,
                        "timestamp": FieldValue.serverTimestamp(),
                      };

                      await FirebaseFirestore.instance
                          .collection('livestreams')
                          .doc(ChannelId)
                          .set(liveStreamData);

                      // Navigate to LiveStreamingScreen
                      // _cameraController?.dispose();
                      // _titleController.dispose();
                      Get.to(() => LiveStreamingScreen(
                            channelId: ChannelId ?? '',
                            isAdmin: true,
                            uid: uid ?? 0,
                          ));
                    } catch (e) {
                      Get.snackbar(
                        "error".tr,
                        "live_stream_error".tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: _buildOption(
                      context, Icons.play_circle_fill, "Schedule a Show")),
              GestureDetector(
                onTap: (){
                  Get.to(() => MyProductsScreen());
                },
                child: _buildOption(context, Icons.store, "Seller Hub",
                    subtitle: "Manage Inventory, Orders and more"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String title,
      {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(title,
          style:
              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey))
          : null,
      // onTap: () {
      //   Navigator.pop(context); // Close the bottom sheet on tap
      //   // Handle navigation or action here
      // },
    );
  }

  @override
  void initState() {
    uid = 10000 + Random().nextInt(90000); // Generates a 5-digit number
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    ChannelId =
        List.generate(5, (index) => chars[Random().nextInt(chars.length)])
            .join();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: selectedIndex.value,
            children: screens,
          )),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _showSellBottomSheet(context);
          } else {
            selectedIndex.value = index;
          }
        },
      ),
    );
  }
}
