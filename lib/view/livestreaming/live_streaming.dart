import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:live_app/user_profile.dart';
import 'package:live_app/view/livestreaming/widgets/current_product.dart';

import 'package:live_app/view/livestreaming/widgets/products_pick.dart';
import 'package:live_app/view/livestreaming/widgets/text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';


import '../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import '../profile_views/wallet_screen.dart';
import 'controller/livestreaming_controller.dart';

// Redirect to Home Page

class LiveStreamingScreen extends StatefulWidget {
  final String channelId;
  final bool isAdmin;
  final int uid;

  LiveStreamingScreen({
    required this.channelId,
    required this.isAdmin, required this.uid,
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

  String name = '';
  String email = '';

  String photo = '';

  int? adminUid;
  int? cohostUid;
  bool isSubscribed = false;
  int subscriberCount = 0;
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";
  void checkSubscriptionStatus() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('UserEntity')
        .doc(widget.channelId) // Assuming channelId is the admin's user ID
        .get();

    if (userDoc.exists) {
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      List<dynamic> subscribersList = userData?['subscribers'] ?? [];

      setState(() {
        isSubscribed = subscribersList.contains(currentUserId);
        subscriberCount = subscribersList.length;
      });
    }
  }

  Future<void> toggleSubscription() async {
    if (isSubscribed) {
      await _unsubscribeUser(widget.channelId, currentUserId);
      setState(() {
        isSubscribed = true;
      });
    } else {
      await _subscribeUser(widget.channelId, currentUserId);
      setState(() {
        isSubscribed = true;
      });
    }

    checkSubscriptionStatus(); // Refresh the UI
  }
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
  Future<void> captureAndStoreSnapshot() async {
    try {
      // Get a temporary directory to store the snapshot locally.
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/snapshot_${DateTime.now().millisecondsSinceEpoch}.png';

      // Capture the snapshot from Agora's engine (assumes uid 0 for admin's stream).
      await _controller.agoraEngine?.takeSnapshot(uid: 0  , filePath: filePath);

      print("Snapshot requested at $filePath");

      File snapshotFile = File(filePath);

      // Retry loop: Check if the file exists, wait a bit if it doesn't.
      int retries = 5;
      while (!(await snapshotFile.exists()) && retries > 0) {
        await Future.delayed(Duration(milliseconds: 500));
        retries--;
      }

      // If file still doesn't exist, log and exit.
      if (!(await snapshotFile.exists())) {
        print("Snapshot file not found after waiting.");
        return;
      }
      print("Snapshot file exists. Proceeding with upload.");

      // Upload the file to Firebase Storage.
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('live_screenshots')
          .child('${widget.channelId}_${DateTime.now().millisecondsSinceEpoch}.png');

      await storageRef.putFile(snapshotFile);
      final downloadUrl = await storageRef.getDownloadURL();
      print("Snapshot uploaded. Download URL: $downloadUrl");

      // Update the Firestore livestreams document with the new image URL.
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(widget.channelId)
          .update({'liveImage': downloadUrl});
      print("Firestore updated with new live image.");
    } catch (e) {
      print("Error capturing or uploading snapshot: $e");
    }
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
  Timer? snapshotTimer;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserDetails();
      monitorDocument();
      _controller.initializeAgora(widget.channelId, widget.uid, widget.isAdmin, adminUid ?? 0);
      initializeFirestore(widget.channelId);
    });
    checkSubscriptionStatus(); // Refresh the UI

    super.initState();
    requestCameraAndMicrophonePermissions();
    if (widget.isAdmin) {
      snapshotTimer = Timer.periodic(Duration(minutes: 1), (_) async {
        await captureAndStoreSnapshot();
      });
    }
    captureAndStoreSnapshot();

  //  WakelockPlus.enable();
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
        'adminFirebaseId': data?['adminFirebaseId'] ?? 'Unknown',
        'adminPhoto': data?['adminPhoto'] ??

            'https://via.placeholder.com/150', // Default image
      };
    } else {
      return {
        'adminName': 'Unknown',
        'adminFirebaseId': 'Unknown',
        'adminPhoto': 'https://via.placeholder.com/150', // Default image
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isAdmin) {
          await _controller.leaveStream();
          _controller.deleteLiveStream(widget.channelId);
        } else {
          await _controller.leaveStreamUser(widget.channelId, widget.uid.toString());
        }
        Get.offAll(() => BottomNavigationBarWidget());
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
              if (widget.isAdmin || cohostUid == widget.uid)

                Positioned(
                  right: MediaQuery
                      .of(context)
                      .size
                      .width * 0.015,
                  bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // More
                      // GestureDetector(
                      //   onTap: () {
                      //     // Handle 'More' tap
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/icons/ic_more.png', // Dummy icon
                      //         width: 40,
                      //         height: 40,
                      //       ),
                      //       const SizedBox(height: 5),
                      //       const Text(
                      //         'More',
                      //         style:
                      //         TextStyle(color: Colors.white, fontSize: 12),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20),

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
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 5),
                             Text(
                              'Shop'.tr,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.defaultDialog(
                            title: "Boost Video".tr,
                            middleText: "Do you want to boost your video?".tr,
                            textCancel: "No".tr,
                            textConfirm: "Yes".tr,
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              print("Boost video confirmed.".tr);
                              Get.back();
                            },
                            onCancel: () {
                              print("Boost video canceled.".tr);
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_boost.png', // Dummy icon
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 5),
                             Text(
                              'Boost'.tr,
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // GestureDetector(
                      //   onTap: () {
                      //     showUserProductsBottomSheet(context, widget.channelId);
                      //   },
                      //   child: Column(
                      //     children: [
                      //       Image.asset(
                      //         'assets/icons/ic_clip.png', // Dummy icon
                      //         width: 40,
                      //         height: 40,
                      //       ),
                      //       const SizedBox(height: 5),
                      //       const Text(
                      //         'Clip',
                      //         style:
                      //         TextStyle(color: Colors.white, fontSize: 12),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                   //   const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Handle 'Wallet' tap
                          Get.to(()=>WalletScreen());
                        },
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/ic_wallet.png', // Dummy icon
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(height: 5),
                             Text(
                              'Wallet'.tr,
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
SizedBox(height: 50,)
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
                          return  Text('Error loading admin details'.tr,
                              style: TextStyle(color: Colors.red));
                        }

                        final adminName = snapshot.data!['adminName']!;
                        final adminPhoto = snapshot.data!['adminPhoto']!;
                        final adminFirebaseId = snapshot.data!['adminFirebaseId']!;


                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // color: Colors.black.withOpacity(0.6),
                            //   borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap : (){
                                  Get.to(()=>UserProfile(userId: adminFirebaseId));

                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(adminPhoto),
                                  radius: 22,
                                ),
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
                                      GestureDetector(
                                        onTap : (){toggleSubscription();},
                                        child: Container(
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
                                          child:  Text(
                                                                isSubscribed ? "Unsubscribe" : "Subscribe",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                bottom: Get.height * .01,
                left: 10,
                right:  Get.width * .18,
                child: Obx(() {
                  return Column(
crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        height: 220,
                       // padding:  EdgeInsets.only(right:),
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
                      ),
                      ChatInputField(
                        chatController: _controller.chatController,
                        focusNode: _focusNode,
                        onSend: (message) {
                          _controller.sendMessage(name, photo, widget.channelId);
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CurrentProductContainer(

                          channelId: widget.channelId,
                          name: name,
                          photo: photo,
                          isAdmin: widget.isAdmin,
                        ),
                      ),
                    ],
                  );
                }),
              ),


              // Bottom Controls
              // Positioned(
              //   bottom: Get.height * .22,
              //   left: 5,
              //   child: Column(
              //     children: [
              //       // Chat Input Row
              //
              //
              //
              //     ],
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: CurrentProductContainer(
              //     channelId: widget.channelId,
              //     name: name,
              //     photo: photo,
              //   ),
              // )

            ],
          );
        }),
      ),
    );
  }


  Future<bool> _showExitConfirmationDialog(BuildContext context, bool isAdmin) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(10), // Adjusted border radius
          ),
          backgroundColor:
          HexColor('#2C2D2A'),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 40,
                left: 20,
                right: 20,
                bottom: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Do you want to end Live video?'.tr,

                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
                          widget.channelId, widget.uid.toString());
                    }
                  },
                  child: Text(
                    'Yes'.tr, // Button text
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
                    'No'.tr, // Button text
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
  Future<bool> requestCameraAndMicrophonePermissions() async {
    // Request camera permission
    var cameraStatus = await Permission.camera.request();
    // Request microphone permission
    var microphoneStatus = await Permission.microphone.request();

    // Check if both permissions are granted
    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> _unsubscribeUser(String userId, String currentUserId) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection(
        'UserEntity').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) return;

        Map<String, dynamic>? userData = snapshot.data() as Map<String,
            dynamic>?;

        List<dynamic> subscribersList = userData?['subscribers'] != null
            ? List<dynamic>.from(userData?['subscribers'])
            : [];

        if (subscribersList.contains(currentUserId)) {
          subscribersList.remove(currentUserId);
          transaction.update(userDoc, {'subscribers': subscribersList});
        }
      });

      Get.snackbar("Success", "You have unsubscribed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to unsubscribe: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  /// **Function to handle subscription logic**
  Future<void> _subscribeUser(String userId, String currentUserId) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection(
        'UserEntity').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) return;

        Map<String, dynamic>? userData = snapshot.data() as Map<String,
            dynamic>?;

        List<dynamic> subscribersList = userData?['subscribers'] != null
            ? List<dynamic>.from(userData?['subscribers'])
            : [];

        if (!subscribersList.contains(currentUserId)) {
          subscribersList.add(currentUserId);
          transaction.update(userDoc, {'subscribers': subscribersList});
        }
      });

      Get.snackbar("Success", "You have subscribed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to subscribe: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}


