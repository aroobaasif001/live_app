import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/auth/delivery_address_screen.dart';
import 'package:live_app/view/profile_views/create_streem_screen.dart';
import 'package:live_app/view/profile_views/edit_trade_profile.dart';
import 'package:live_app/view/profile_views/item_for_auction.dart';
import 'package:live_app/view/profile_views/statistic_screen.dart';
import 'package:live_app/view/profile_views/wallet_screen.dart';
import '../../custom_widgets/custom_review.dart';
import '../../custom_widgets/custom_text.dart';
import '../../entities/registration_entity.dart';
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

  /// Fetches User Profile from Firestore
  // Future<void> _fetchUserProfile() async {
  //   try {
  //     DocumentSnapshot<RegistrationEntity> userSnapshot =
  //         await RegistrationEntity.doc(userId: widget.userId).get();

  //     if (mounted) {
  //       setState(() {
  //         userProfile = userSnapshot.exists ? userSnapshot.data() : null;
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching user profile: $e");
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }
Future<void> _fetchUserProfile() async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("UserEntity")
        .doc(widget.userId)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        print("🔥 Firestore Data: $userData"); // Debugging Firestore response

        setState(() {
          userProfile = RegistrationEntity.fromJson(userData);
          _isLoading = false;
        });

        // ✅ Debugging - Print Image URLs
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
                  Stack(
                    children: [
                      Container(
                        height: 220,
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
                                Icon(Icons.arrow_back,
                                    color: Colors.white, size: 24),
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
                                    child: const Icon(Icons.edit_outlined,
                                        color: Colors.black87, size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
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
                                    CustomText(
                                      text:
                                          "${userProfile?.email ?? "Email Not Available"}",
                                      fontSize: 12,
                                      color: Colors.white70,
                                      fontFamily: "Gilroy-Bold",
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
                                  value: userProfile?.rating?.toString() ?? '0',
                                  label: 'Rating',
                                  iconPath: 'assets/icons/star.png'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value: userProfile?.reviews?.toString() ?? '0',
                                  label: 'Reviews'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value: userProfile?.sold?.toString() ?? '0',
                                  label: 'Sold'),
                              VerticalDivider(color: conLineColor),
                              CustomReview(
                                  value: userProfile?.delivery?.toString() ?? '0',
                                  label: 'Delivery'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            actionBox(Icons.shopping_bag, 'goods'.tr, () {
                              Get.to(() => MyProductsScreen());
                            }),
                            const SizedBox(width: 10),
                            actionBox(Icons.stream, 'streams'.tr, () {
                              Get.to(() => CreateStreamScreen());
                            }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            actionBox(
                                Icons.account_balance_wallet, 'wallet'.tr, () {
                              Get.to(() => WalletScreen());
                            }),
                            const SizedBox(width: 10),
                            actionBox(Icons.list_alt, 'orders'.tr, () {
                              Get.to(()=>ItemAuctionScreen());
                            },
                                badgeCount: 1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),

                  // Invite Friends Section
                  inviteFriendBox(),
                  const SizedBox(height: 10),

                  // Bottom Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        optionTile(Icons.attach_money, "tips".tr,onTap: () {

                        },),
                        optionTile(Icons.local_shipping, "delivery".tr,onTap: () {
                          Get.to(()=> DeliveryAddressScreen());
                        },),
                        optionTile(Icons.analytics, "analytics".tr,onTap: () {
                          Get.to(()=> StatisticsScreen());
                        },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget profileStatBox(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: "Gilroy-Bold",
        ),
        const SizedBox(height: 2),
        CustomText(
          text: label,
          fontSize: 12,
          color: Colors.grey,
          fontFamily: "Gilroy-Bold",
        ),
      ],
    );
  }

  Widget verticalDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }


  Widget actionBox(IconData icon, String title, VoidCallback ontap,
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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 28, color: Colors.black),
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

  Widget optionTile(IconData icon, String title,{void Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black),
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
