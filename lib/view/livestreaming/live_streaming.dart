import 'dart:async';
import 'dart:math'; // Import for mathematical functions like sin

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';
import 'package:live_app/view/livestreaming/widgets/current_product.dart';
import 'package:live_app/view/livestreaming/widgets/highest_bid.dart';
import 'package:live_app/view/livestreaming/widgets/joinrequest_bottomsheet.dart';
import 'package:live_app/view/livestreaming/widgets/products_pick.dart';
import 'package:live_app/view/livestreaming/widgets/text_field.dart';
import 'package:live_app/view/livestreaming/widgets/viewers_bottomsheet.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import 'controller/livestreaming_controller.dart';

// Redirect to Home Page

class LiveStreamingScreen extends StatefulWidget {
  final String channelId;
  final bool isAdmin;

  LiveStreamingScreen({
    required this.channelId,
    required this.isAdmin,
  });

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  // Parameter to receive the name
  final LiveStreamController _controller = Get.put(LiveStreamController());
  final FocusNode _focusNode = FocusNode();
  Timer? heartbeatTimer;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> documentStream;
  final ScrollController _scrollController = ScrollController();

  int uid = 0;
  String name = '';
  String email = '';

  String photo = '';

  int? adminUid;
  int? cohostUid;

  void monitorDocument() {
    documentStream = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(widget.channelId)
        .snapshots();

    documentStream.listen((snapshot) {
      if (!snapshot.exists) {
        // If the document is deleted, navigate to the homepage
        showLiveStreamEndedPopup();
      }
    });
  }

  void redirectToHomePage() {
    // Navigate to the homepage
    Get.to(() => BottomNavigationBarWidget());
  }

  void showLiveStreamEndedPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.live_tv,
                color: Colors.blue,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                "Live Stream Ended",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "The live stream you were watching has ended.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  redirectToHomePage();
                  //  _controller.postDelete(widget.channelId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Go to Home",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<Map<String, dynamic>> getUserDetails() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   // Fetch user details from SharedPreferences
  //   final String? name = prefs.getString("name");
  //   final String? photo = prefs.getString("user_image");
  //   final String? email = prefs.getString("email");
  //   final int? uid = prefs.getInt("uid");
  //
  //   return {
  //     "name": name,
  //     "photo": photo,
  //     "email": email,
  //     "uid": uid,
  //   };
  // }

  void checkUserDetails() async {
    // Assuming you're fetching from a 'users' collection, with a document that has the user's info
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('UserEntity')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userSnapshot.exists) {
      var userData = userSnapshot.data() as Map<String, dynamic>;
      name = userData['firstName'] ?? 'No name found';
      photo = userData['image'] ??
          'https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dGFraW5nJTIwcGhvdG98ZW58MHx8MHx8fDA%3D';

      print("Name: $name, Photo: $photo");
    } else {
      print("User not found!");
    }
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserDetails();
      monitorDocument();
      _controller.initializeAgora(widget.channelId, uid, widget.isAdmin, adminUid ?? 0);
      initializeFirestore(widget.channelId);
    });
    super.initState();
    WakelockPlus.enable();
    ever(_controller.comments, (_) {
      // Scroll to the bottom when a new comment is added
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
    if (widget.isAdmin) {
      //startHeartbeat();
    }

    // TODO: implement initState
    // checkUserDetails();

    FirebaseFirestore.instance
        .collection('livestreams')
        .doc(widget.channelId)
        .collection('hearts')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final left = data['left'] as double;

        // Avoid duplication by checking existing entries
        if (!_controller.floatingHearts.any((heart) => heart.left == left)) {
          _controller.floatingHearts.add(HeartEmoji(left: left, opacity: 0));

          // Remove the heart after animation duration
          Future.delayed(const Duration(milliseconds: 3000), () {
            _controller.floatingHearts
                .removeWhere((heart) => heart.left == left);
          });
        }
      }
    });
  }

  Future<void> initializeFirestore(String channelId) async {
    try {
      // Listen to comments in the "comments" subcollection
      FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        _controller.comments
          ..value = snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
      });

      print('[INFO] Firestore initialized and listening for comments');
    } catch (e) {
      print('[ERROR] Firestore initialization error: $e');
    }
  }

  Future<Map<String, String>> fetchAdminDetails(String channelId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('livestreams')
        .doc(channelId)
        .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      adminUid = data?['adminUid'];
      return {
        'adminName': data?['adminName'] ?? 'Unknown',
        'adminPhoto': data?['adminPhoto'] ??
            'https://via.placeholder.com/150', // Default image
      };
    } else {
      return {
        'adminName': 'Unknown',
        'adminPhoto': 'https://via.placeholder.com/150', // Default image
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitConfirmed =
        await _showExitConfirmationDialog(context, widget.isAdmin);
        if (exitConfirmed) {
          await _controller.leaveStream();
          _controller.deleteLiveStream(widget.channelId);
          Get.offAll(
                  () => BottomNavigationBarWidget()); // Redirect to Home Page
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          return Stack(
            children: [
              Positioned.fill(
                child: _controller.isJoined.value
                    ? Stack(
                  children: [
                    // Center(child: Text(adminUid.toString())),

                    (widget.isAdmin)
                        ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _controller.agoraEngine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                        : AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _controller.agoraEngine!,
                        canvas: VideoCanvas(
                            uid:
                            adminUid), // Replace with remote user UID
                        connection: RtcConnection(
                            channelId: widget.channelId),
                      ),
                    )
                  ],
                )
                    : const Center(),
              ),

              // Top Streamer Info
              if (widget.isAdmin || cohostUid == uid)
              // Positioned(
              //     bottom: MediaQuery.of(context).size.height * 0.55,
              //
              //     // Adjust top position based on screen height
              //     // Adjust left margin
              //     right: MediaQuery.of(context).size.width * 0.015,
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         GestureDetector(
              //             onTap: () {
              //               _controller.toggleMute();
              //             },
              //             child: Image.asset(
              //               _controller.isMuted.value
              //                   ? 'assets/icons/live_micoff.png'
              //                   : 'assets/icons/live_micon.png',
              //               height: 35.r,
              //             )),
              //         SizedBox(
              //           height: _controller.isCameraOn.value ? 20 : 10,
              //         ),
              //         GestureDetector(
              //             onTap: () {
              //               _controller.toggleCamera();
              //             },
              //             child: Image.asset(
              //               _controller.isCameraOn.value
              //                   ? 'assets/icons/live_cameraon.png'
              //                   : 'assets/icons/live_cameraoff.png',
              //               height:
              //                   _controller.isCameraOn.value ? 22.r : 35.r,
              //             )),
              //         SizedBox(
              //           height: 15,
              //         ),
              //         GestureDetector(
              //             onTap: () {
              //               showUserProductsBottomSheet(
              //                   context, widget.channelId);
              //             },
              //             child: Icon(
              //               Icons.shop,
              //               color: Colors.white,
              //             )),
              //         SizedBox(
              //           height: 2,
              //         ),
              //         GestureDetector(
              //             onTap: () {
              //               _controller.switchCamera();
              //             },
              //             child: Image.asset(
              //               'assets/icons/live_rotate.png',
              //               height: 50.r,
              //             )),
              //         SizedBox(
              //           height: 5,
              //         ),
              //       ],
              //     )),

                Positioned(
                  right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.015,
                  bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // More
                      GestureDetector(
                        onTap: () {
                          // Handle 'More' tap
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_more.png', // Dummy icon
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'More',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          showUserProductsBottomSheet(context, widget.channelId);


                          // });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ic_shop.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Shop',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Boost
                      GestureDetector(
                        onTap: () {
                          // Handle 'Boost' tap
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_boost.png', // Dummy icon
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Boost',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Clip
                      GestureDetector(
                        onTap: () {
                          // Handle 'Clip' tap
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_clip.png', // Dummy icon
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Clip',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Share
                      GestureDetector(
                        onTap: () {
                          // Handle 'Share' tap
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_share.png', // Dummy icon
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Share',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),



                      const SizedBox(height: 20),

                      // Shop



                      // Wallet
                      GestureDetector(
                        onTap: () {
                          // Handle 'Wallet' tap
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_wallet.png', // Dummy icon
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Wallet',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

              Positioned(
                top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.02,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,
                right: MediaQuery
                    .of(context)
                    .size
                    .width * 0.02,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<Map<String, String>>(
                      future: fetchAdminDetails(widget.channelId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError || !snapshot.hasData) {
                          return const Text('Error loading admin details',
                              style: TextStyle(color: Colors.red));
                        }

                        final adminName = snapshot.data!['adminName']!;
                        final adminPhoto = snapshot.data!['adminPhoto']!;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // color: Colors.black.withOpacity(0.6),
                            //   borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(adminPhoto),
                                radius: 22,
                              ),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    adminName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.white, size: 18),
                                      const SizedBox(width: 4),
                                      const Text("4.7",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          // Replace 'color' with a gradient
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(
                                                  0xFF3A8EF2),
                                              // Starting color (blueish)
                                              Color(
                                                  0xFFD53F8C),
                                              // Ending color (pink/purpleish)
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: const Text(
                                          "Subscribe",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/live_count.png',
                                width: 30,
                              ),
                              const SizedBox(width: 2),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('livestreams')
                                    .doc(widget.channelId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("0",
                                        style: TextStyle(color: Colors.white));
                                  }

                                  final data = snapshot.data?.data()
                                  as Map<String, dynamic>?;
                                  final viewsCount = data?['viewsCount'] ?? 0;

                                  return Text(
                                    viewsCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            await _showExitConfirmationDialog(
                                context, widget.isAdmin);
                          },
                          child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              radius: 18,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                                weight: 5,
                                size: 35,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //commentmessage

              Positioned(
                bottom: Get.height * .30,
                left: 10,
                right: 10,
                child: Obx(() {
                  return Container(
                    height: 220,
                    padding: const EdgeInsets.only(right: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _controller.comments.isNotEmpty
                        ? ListView.builder(
                      controller:
                      _scrollController, // Attach the scroll controller
                      itemCount: _controller.comments.length,
                      itemBuilder: (context, index) {
                        final comment = _controller.comments[index];
                        return Container(
                          decoration: BoxDecoration(
                              color:
                              (comment['message'].contains('Set Bid')
                                  ? Colors.purple
                                  : Colors.transparent)),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                // Profile Picture
                                CircleAvatar(
                                  backgroundImage:
                                  NetworkImage(comment['photo']),
                                  radius: 22,
                                ),
                                const SizedBox(width: 10),
                                // Comment Bubble
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['user'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      comment['message'],
                                      style: TextStyle(
                                        fontSize: 18.r,
                                        fontWeight: (comment['message']
                                            .contains('Set Bid')
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : const Center(),
                  );
                }),
              ),
              Obx(() {
                return Stack(
                  children: _controller.floatingHearts.map((heart) {
                    return Positioned(
                      bottom: 0,
                      right: 0,
                      // You can adjust this or use `left` for dynamic positioning
                      child: Lottie.asset(
                          'assets/heart.json', // Path to your Lottie file
                          width: 150, // Adjust size as needed
                          height: 350,
                          repeat: false),
                    );
                  }).toList(),
                );
              }),

              // Bottom Controls
              Positioned(
                bottom: Get.height * .22,
                left: 5,
                child: Column(
                  children: [
                    // Chat Input Row
                    ChatInputField(
                      chatController: _controller.chatController,
                      focusNode: _focusNode,
                      onSend: (message) {
                        _controller.sendMessage(name, photo, widget.channelId);
                      },
                    ),


                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CurrentProductContainer(
                  channelId: widget.channelId,
                  name: name,
                  photo: photo,
                ),
              )

            ],
          );
        }),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context,
      bool isAdmin) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10), // Adjusted border radius
          ),
          backgroundColor:
          HexColor('#2C2D2A'), // Set background to match the image
          child: Padding(
            padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 40), // Add padding around content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Do you want to end Live video?',
                  // Static text as shown in image
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 18, // Adjusted font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.blue, // Button color to match the image
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15), // Match button style
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10), // Adjust padding
                  ),
                  onPressed: () async {
                    heartbeatTimer
                        ?.cancel(); // Cancel the timer when the widget is disposed
                    await _controller.leaveStream();
                    if (isAdmin) {
                      _controller.deleteLiveStream(widget.channelId);
                    } else {
                      _controller.leaveStreamUser(
                          widget.channelId, uid.toString());
                    }
                  },
                  child: Text(
                    'Yes', // Button text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Adjust font size
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'No', // Button text
                    style: TextStyle(
                      color: Colors.white, // Match text color
                      fontSize: 18, // Adjust font size
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ) ??
        false;
  }


  void shareLiveStream(String channelId) {
    // Use a web-based URL instead of a custom scheme
    final String link = 'https://yourapp.com/live/$channelId?isAdmin=false';

    // Share the link with an inviting message
    Share.share(
      'Join my live stream here: $link',
      subject: 'Live Stream Invitation',
    );
  }


  void startHeartbeat() {
    heartbeatTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        final timestamp = DateTime.now().toIso8601String();

        // Update the heartbeat field in Firestore
        await FirebaseFirestore.instance
            .collection('livestreams')
            .doc(widget.channelId)
            .update({
          'heartbeat': timestamp,
        });

        print("Heartbeat updated: $timestamp");
      } catch (e) {
        print("Error updating heartbeat: $e");
      }
    });
  }
}


