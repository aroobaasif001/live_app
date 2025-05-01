import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';
import 'package:live_app/view/profile_views/create_streem_screen.dart';
import 'package:live_app/view/profile_views/delivery_address_update_screen.dart';
import 'package:live_app/view/profile_views/edit_trade_profile.dart';
import 'package:live_app/view/profile_views/item_for_auction.dart';
import 'package:live_app/view/profile_views/statistic_screen.dart';
import 'package:live_app/view/profile_views/tips_screen.dart';
import 'package:live_app/view/profile_views/wallet_screen.dart';
import '../../custom_widgets/custom_review.dart';
import '../../custom_widgets/custom_text.dart';
import '../../entities/registration_entity.dart';
import 'invite_friend_screen.dart';
import 'my_products_screen.dart';

class TradeProfileScreen extends StatefulWidget {
  final String userId;

  const TradeProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  _TradeProfileScreenState createState() => _TradeProfileScreenState();
}

class _TradeProfileScreenState extends State<TradeProfileScreen> {
  RegistrationEntity? userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  /// Fetches the User Profile from Firestore with conversion fixes
  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("UserEntity")
          .doc(widget.userId)
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          print("🔥 Firestore Data: $userData");

          // Convert fields that are expected as String but may come as int
          final fieldsToConvert = ['rating', 'reviews', 'sold', 'delivery'];
          for (final field in fieldsToConvert) {
            if (userData.containsKey(field) && userData[field] is int) {
              userData[field] = userData[field].toString();
            }
          }

          setState(() {
            userProfile = RegistrationEntity.fromJson(userData);
            _isLoading = false;
          });

          print("Profile Image URL: ${userProfile?.image}");
          print("Cover Image URL: ${userProfile?.coverImage}");
        } else {
          print("Firestore returned null data.");
          setState(() => _isLoading = false);
        }
      } else {
        print("User document does not exist");
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Cover Image and User Info Section
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: userProfile?.coverImage != null &&
                                    userProfile!.coverImage!.isNotEmpty
                                ? NetworkImage(userProfile!.coverImage!)
                                    as ImageProvider
                                : const AssetImage(
                                    companyProfileBackgroundImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white, size: 24),
                                ),
                                CustomContainer(
                                  height: 32,
                                  width: 32,
                                  shape: BoxShape.circle,
                                  conColor: Colors.white,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => EditTradeProfile(
                                          userId: widget.userId));
                                    },
                                    child: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.black87,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 37.5,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: userProfile?.image != null &&
                                          userProfile!.image!.isNotEmpty
                                      ? NetworkImage(userProfile!.image!)
                                      : null,
                                  child: (userProfile?.image == null ||
                                          userProfile!.image!.isEmpty)
                                      ? Icon(Icons.person,
                                          size: 40, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: userProfile?.firstName ??
                                          "User First Name",
                                      fontFamily: "Gilroy-Bold",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    CustomText(
                                      text: userProfile?.lastName ??
                                          "User Last Name",
                                      fontFamily: "Gilroy-Bold",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              text:
                                                  "${userProfile?.subscribers ?? "00kk "}",
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontFamily: "Gilroy-Bold",
                                            ),
                                            CustomText(
                                              text: "Subcribers",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontFamily: "Gilroy-Bold",
                                            ),
                                          ],
                                        ),
                                        CustomText(
                                          text: " - ",
                                          fontSize: 12,
                                          color: Colors.green.shade400,
                                          fontFamily: "Gilroy-Bold",
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                              text:
                                                  "${userProfile?.subscribers ?? "00kk "}",
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontFamily: "Gilroy-Bold",
                                            ),
                                            CustomText(
                                              text: "Subscriptions",
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontFamily: "Gilroy-Bold",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats Container
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomContainer(
                      height: 68,
                      width: double.infinity,
                      conColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: conLineColor),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomReview(
                                  value:
                                      userProfile?.rating?.toString() ?? '0.0',
                                  label: 'Rating',
                                  iconPath: 'assets/icons/Star.png'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value:
                                      userProfile?.reviews?.toString() ?? '0k',
                                  label: 'Reviews'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value: userProfile?.sold?.toString() ?? '0k',
                                  label: 'Sold'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value:
                                      userProfile?.delivery?.toString() ?? '± 0d',
                                  label: 'Delivery'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Action Boxes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            actionBox(
                                "assets/images/user group icon.png", 'goods'.tr,
                                () {
                              Get.to(() => WalletScreen());
                            }),
                            const SizedBox(width: 10),
                            actionBox(
                                "assets/images/stream icon.png", 'stream'.tr,
                                () {
                              Get.to(() => ItemAuctionScreen());
                            }, badgeCount: 1),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            actionBox(
                                "assets/images/wallet icon.png", 'wallet'.tr,
                                () {
                              Get.to(() => WalletScreen());
                            }),
                            const SizedBox(width: 10),
                            actionBox(
                                "assets/images/order icon.png", 'orders'.tr,
                                () {
                              Get.to(() => ItemAuctionScreen());
                            }, badgeCount: 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Get.to(() => InviteFriendScreen());
                          },
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/user group icon.png",
                                height: 25,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                child: CustomText(
                                  text: "Invite a friend and get up to 10,000P",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Gilroy-Bold",
                                ),
                              ),
                              CustomText(
                                text: "Balance: 0 P",
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Gilroy-Bold",
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Colors.black),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        optionTile("assets/images/tips icon.png", "tips".tr, onTap: () {
                          Get.to(() => TipsScreen());
                        }),
                        optionTile("assets/images/delivery icon.png", "delivery".tr,
                            onTap: () {
                          Get.to(() => DeliveryAddressUpdateScreen());
                        }),
                        optionTile("assets/images/analytics icon.png", "analytics".tr, onTap: () {
                          Get.to(() => StatisticsScreen());
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget actionBox(String iconImage, String title, VoidCallback ontap,
      {int badgeCount = 0}) {
    return Expanded(
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 5),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconImage,
                      height: 28,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gilroy-Bold",
                    ),
                  ],
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 10,
                  right: 15,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: CustomText(
                      text: badgeCount.toString(),
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inviteFriendBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'invite_friend_title'.tr,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gilroy-Bold",
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: 'balance_amount'.tr,
                    fontSize: 12,
                    color: Colors.grey,
                    fontFamily: "Gilroy-Bold",
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  Widget optionTile(String iconImage, String title, {void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle
          ),
          child: Center(
            child: Image.asset(
              iconImage,
              height: 25,
            ),
          ),
        ),
        title: CustomText(
          text: title,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: "Gilroy-Bold",
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.black),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
