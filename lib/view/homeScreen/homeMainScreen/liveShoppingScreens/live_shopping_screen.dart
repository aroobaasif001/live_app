import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/view/homeScreen/widgets/show_user_agrement_bottom.dart';
import 'package:live_app/view/homeScreen/widgets/show_winner_pop_up.dart';
import '../../../../custom_widgets/custom_text.dart';
import '../../widgets/show_bet_bottom_sheet.dart';
import '../../widgets/show_custom_bottom_sheet.dart';
import '../../widgets/view_note_popup.dart';

class LiveShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bgimage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showCustomBottomSheet(
                            context,
                            companyName: "Apple Inc.",
                            rating: 4.7,
                            profileIcon: Icons.apple,
                            actions: [
                              {
                                "icon": 'assets/icons/reward.png',
                                "text": "Reward",
                                "onTap": () {
                                   Get.back();
                                  showSendRewardBottomSheet(context);
                                 
                                }
                              },
                              {
                                "icon": 'assets/icons/profile1.png',
                                "text": "View profile",
                                "onTap": () {
                                  print("View Profile Clicked");
                                }
                              },
                              {
                                "icon": 'assets/icons/message.png',
                                "text": "Message",
                                "onTap": () {
                                  print("Message Clicked");
                                }
                              },
                              {
                                "icon": 'assets/icons/chat.png',
                                "text": "Mention in chat",
                                "onTap": () {
                                  print("Mention in Chat Clicked");
                                }
                              },
                              {
                                "icon": 'assets/icons/block.png',
                                "text": "Block",
                                "onTap": () {
                                  print("User Blocked");
                                }
                              },
                              {
                                "icon": 'assets/icons/report.png',
                                "text": "Report abuse",
                                "onTap": () {
                                  print("Report Abuse Clicked");
                                }
                              },
                            ],
                          );
                        },
                        child:
                            Image.asset('assets/icons/apple1.png', height: 30)),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "company_name",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 16),
                            Text("4.7",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            SizedBox(width: 5),
                            SizedBox(
                                height: 25,
                                width: 70,
                                child: CustomGradientButton(
                                  text: 'Subscribe',
                                  onPressed: () {
                                    showWinnerPopup(context, 'M');
                                  },
                                  fontSize: 10,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/view.png'),
                    SizedBox(width: 10),
                    Text("87",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Image.asset('assets/icons/arrow_downward.png'),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            child: GestureDetector(
              onTap: () {
                ViewNoteButton.showNotePopup(context);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/icons/view_note.png',
                    height: 50,
                    width: 80,
                  ),
                  Text(
                    "View\n Note",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 15,
            top: screenHeight * 0.3,
            child: Column(
              children: [
                _buildFloatingActionButton('assets/icons/more.png', "More", () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
                _buildFloatingActionButton('assets/icons/boost.png', "Boost",
                    () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
                _buildFloatingActionButton('assets/icons/clip.png', "Clip", () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
                _buildFloatingActionButton('assets/icons/share.png', "Share",
                    () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
                _buildFloatingActionButton('assets/icons/wallet.png', "Wallet",
                    () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
                _buildFloatingActionButton('assets/icons/shop.png', "Shop", () {
                  showUserAgreementBottomSheet(
                    context,
                  );
                }),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text("a",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("nickname25",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                Text("Lorem ipsum dolor sit am...",
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Message...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lorem ipsum dolor sit.",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery & Payment",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                         CustomText(text: '1000',fontFamily: 'Gilroy-Bold',fontSize: 18,color: Colors.white,)
                  ],
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showBetBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("We are waiting for the next lot",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(
      String icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              onPressed: onTap,
              child: Image.asset(icon)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
