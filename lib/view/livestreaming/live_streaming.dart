import 'dart:async';
import 'dart:math'; // Import for mathematical functions like sin

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';
import 'package:live_app/view/livestreaming/widgets/current_product.dart';
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
    name = 'Test';
    photo =
        'https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dGFraW5nJTIwcGhvdG98ZW58MHx8MHx8fDA%3D';

    print("Name: $name, Photo: $photo, Email: $email");
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkUserDetails();
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
    monitorDocument();

    // TODO: implement initState
    // checkUserDetails();
    _controller.initializeAgora(
        widget.channelId, uid, widget.isAdmin, adminUid ?? 0);
    initializeFirestore(widget.channelId);
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
                              :AgoraVideoView(
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
                Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.45,

                    // Adjust top position based on screen height
                    // Adjust left margin
                    right: MediaQuery.of(context).size.width * 0.015,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () {
                              _controller.toggleMute();
                            },
                            child: Image.asset(
                              _controller.isMuted.value
                                  ? 'assets/icons/live_micoff.png'
                                  : 'assets/icons/live_micon.png',
                              height: 35.r,
                            )),
                        SizedBox(
                          height: _controller.isCameraOn.value ? 20 : 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              _controller.toggleCamera();
                            },
                            child: Image.asset(
                              _controller.isCameraOn.value
                                  ? 'assets/icons/live_cameraon.png'
                                  : 'assets/icons/live_cameraoff.png',
                              height:
                                  _controller.isCameraOn.value ? 22.r : 35.r,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              showUserProductsBottomSheet(
                                  context, widget.channelId);
                            },
                            child: Icon(
                              Icons.shop,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        GestureDetector(
                            onTap: () {
                              _controller.switchCamera();
                            },
                            child: Image.asset(
                              'assets/icons/live_rotate.png',
                              height: 50.r,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
              Positioned(
                top: MediaQuery.of(context).size.height *
                    0.02, // Adjust top position based on screen height
                left: MediaQuery.of(context).size.width *
                    0.02, // Adjust left margin
                right: MediaQuery.of(context).size.width *
                    0.02, // Adjust right margin
                child: FutureBuilder<Map<String, String>>(
                  future: fetchAdminDetails(widget.channelId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center();
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error loading admin details',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      final adminName = snapshot.data!['adminName']!;
                      final adminPhoto = snapshot.data!['adminPhoto']!;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Admin Info
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(adminPhoto),
                                    radius: MediaQuery.of(context).size.width *
                                        0.04, // Adjust size
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.25,
                                            child: Text(
                                              adminName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Viewer Count and Action Buttons
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/live.png',
                                        width: 25,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        'Live'.tr,
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.025,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      // widget.isAdmin
                                      //     ? showCohostsAndViewersBottomSheet(
                                      //         context, widget.channelId)
                                      //     : SizedBox();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.white,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06,
                                        ),
                                        // const SizedBox(width: 5),
                                        // StreamBuilder<DocumentSnapshot>(
                                        //   stream: FirebaseFirestore.instance
                                        //       .collection('livestreams')
                                        //       .doc(widget.channelId)
                                        //       .snapshots(),
                                        //   builder: (context, snapshot) {
                                        //     if (snapshot.connectionState ==
                                        //         ConnectionState.waiting) {
                                        //       return Text(
                                        //         "0",
                                        //         // Placeholder until data loads
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontSize:
                                        //               MediaQuery.of(context)
                                        //                       .size
                                        //                       .width *
                                        //                   0.035,
                                        //         ),
                                        //       );
                                        //     }
                                        //
                                        //     if (snapshot.hasError) {
                                        //       return Text(
                                        //         "",
                                        //         style: TextStyle(
                                        //           color: Colors.red,
                                        //           fontSize:
                                        //               MediaQuery.of(context)
                                        //                       .size
                                        //                       .width *
                                        //                   0.035,
                                        //         ),
                                        //       );
                                        //     }
                                        //
                                        //     final data = snapshot.data?.data()
                                        //         as Map<String, dynamic>?;
                                        //     final viewsCount =
                                        //         data?['viewsCount'] ?? 0;
                                        //
                                        //     return Text(
                                        //       viewsCount.toString(),
                                        //       style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontSize:
                                        //               MediaQuery.of(context)
                                        //                       .size
                                        //                       .width *
                                        //                   0.04,
                                        //           fontWeight: FontWeight.bold,
                                        //           fontFamily: 'Poppins'),
                                        //     );
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 5),
                                // Close Button
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                                      onPressed: () async {
                                        await _showExitConfirmationDialog(
                                            context, widget.isAdmin);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text(
                        'no_data_available'.tr,
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),
              ),

              //commentmessage

              Positioned(
                bottom: 120,
                left: 10,
                right: 10,
                child: Obx(() {
                  return Container(
                    height: 220,
                    padding: const EdgeInsets.all(10),
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
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                            color: HexColor('#7A7274'),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comment['message'],
                                          style: TextStyle(
                                            fontSize: 18.r,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    // Chat Input Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Chat Input Field
                        InkWell(
                          onTap: () {
                            _controller.addFloatingHeart(widget.channelId);
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Column(
                            children: [
                              Image.asset('assets/icons/live_heart.png',
                                  height: 40.r),
                              Text(
                                'Like',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 13.r),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),
                        Expanded(
                          child: ChatInputField(
                            chatController: _controller.chatController,
                            focusNode: _focusNode,
                            onSend: (message) {
                              _controller.sendMessage(
                                  name, photo, widget.channelId);
                            },
                          ),
                        ),



                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(left: Get.width * .5 , bottom: Get.height * .1),
                  child: CurrentProductContainer(channelId: widget.channelId,),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(
      BuildContext context, bool isAdmin) async {
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
                      'Do you want to end Live video?', // Static text as shown in image
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

  // void showCohostsAndViewersBottomSheet(
  //     BuildContext context, String channelId) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => FullScreenBottomSheetContent(channelId: channelId),
  //   );
  // }

  void shareLiveStream(String channelId) {
    // Use a web-based URL instead of a custom scheme
    final String link = 'https://yourapp.com/live/$channelId?isAdmin=false';

    // Share the link with an inviting message
    Share.share(
      'Join my live stream here: $link',
      subject: 'Live Stream Invitation',
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  static Color parseColorFromString(String colorName) {
    switch (colorName.trim().toLowerCase()) {
      case 'black':
        return Colors.black.withOpacity(0.9);
      case 'yellow':
        return Colors.yellow.withOpacity(0.2);
      case 'red':
        return Colors.red.withOpacity(0.2);
      case 'green':
        return Colors.green.withOpacity(0.2);
      case 'blue':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.transparent; // Default or no filter
    }
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

  void _applyVoiceEffect(AudioEffectPreset? effect) async {
    if (_controller.agoraEngine == null) return;

    if (effect == null || effect == AudioEffectPreset.audioEffectOff) {
      await _controller.agoraEngine
          ?.setAudioEffectPreset(AudioEffectPreset.audioEffectOff);
    } else {
      await _controller.agoraEngine?.setAudioEffectPreset(effect);
    }
  }
}
