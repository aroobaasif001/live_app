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
import 'package:live_app/view/livestreaming/widgets/joinrequest_bottomsheet.dart';
import 'package:live_app/view/livestreaming/widgets/music_bottomsheet.dart';
import 'package:live_app/view/livestreaming/widgets/text_field.dart';
import 'package:live_app/view/livestreaming/widgets/viewers_bottomsheet.dart';
import 'package:live_app/view/livestreaming/widgets/voiceeffect_bottomsheet.dart';
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
  String? currentlyPlayingMusic; // To track the current music
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
    Get.to(() =>  BottomNavigationBarWidget());
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
                color:Colors.blue,
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
                  backgroundColor:Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Go to Home",
                  style: TextStyle(fontSize: 16 , color: Colors.black),
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
    photo = 'https://images.unsplash.com/photo-1541516160071-4bb0c5af65ba?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dGFraW5nJTIwcGhvdG98ZW58MHx8MHx8fDA%3D';

    print("Name: $name, Photo: $photo, Email: $email");
  }
  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller to prevent memory leaks
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
      startHeartbeat();
    }
    monitorDocument();

    // TODO: implement initState
   // checkUserDetails();
_controller.initializeAgora(widget.channelId, uid, widget.isAdmin,  adminUid ?? 0);
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
          Get.offAll(() =>  BottomNavigationBarWidget()); // Redirect to Home Page
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          return Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('livestreams')
                    .doc(widget.channelId)
                    .collection('cohosts')
                    .snapshots(),
                builder: (context, snapshot) {
                  // Handle the connection state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox
                        .shrink(); // Show nothing while loading
                  }

                  // Check if there are cohosts available
                  final hasCohost =
                      snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                  // Check if the current user is a cohost
                  final isCohost = snapshot.hasData &&
                      snapshot.data!.docs.any((doc) => doc['uid'] == uid);
                  final isPk = snapshot.hasData &&
                      snapshot.data!.docs.any((doc) => doc['isPk'] == true);
                  // Update the reactive state safely after the build phase
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_controller.hasCohosts.value != hasCohost) {
                      _controller.hasCohosts.value =
                          hasCohost; // Update only if the value changes
                    }
                    _controller.isPk.value = isPk;
                    // Switch the client role if needed
                    _controller.switchClientRole(isCohost);
                    if (widget.isAdmin) {
                      _controller.switchClientRole(true);
                    }
                  });

                  print(isPk);

                  // Optionally return UI
                  return SizedBox(); // Replace with your desired UI
                },
              ),
              // Agora Video View (Local or Remote User)

              Positioned.fill(
                child: _controller.isJoined.value
                    ? Stack(
                        children: [
                          // Center(child: Text(adminUid.toString())),

                          (!_controller.hasCohosts.value)
                              ? (widget.isAdmin)
                                  ? StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('livestreams')
                                          .doc(widget.channelId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          final filterString =
                                              snapshot.data!['currentFilter'];
                                          print(
                                              "Filter string from Firestore: $filterString");

                                          if (filterString != null &&
                                              filterString.isNotEmpty) {
                                            final filterColor =
                                                parseColorFromString(
                                                    filterString);
                                            print('colors');
                                            return Stack(
                                              children: [
                                                AgoraVideoView(
                                                  controller:
                                                      VideoViewController(
                                                    rtcEngine: _controller
                                                        .agoraEngine!,
                                                    canvas: const VideoCanvas(
                                                        uid: 0),
                                                  ),
                                                ),
                                                Container(
                                                  height: Get.height,
                                                  width: Get.width,
                                                  color: filterColor,
                                                )
                                              ],
                                            );
                                          }
                                        }

                                        return AgoraVideoView(
                                          controller: VideoViewController(
                                            rtcEngine: _controller.agoraEngine!,
                                            canvas: const VideoCanvas(uid: 0),
                                          ),
                                        ); // Default UI
                                      },
                                    )
                                  : StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('livestreams')
                                          .doc(widget.channelId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null) {
                                          final filterString =
                                              snapshot.data!['currentFilter'];

                                          if (filterString != null) {
                                            // Parse the filter from the string
                                            final filterColor =
                                                parseColorFromString(
                                                    filterString);

                                            return Stack(
                                              children: [
                                                AgoraVideoView(
                                                  controller:
                                                      VideoViewController
                                                          .remote(
                                                    rtcEngine: _controller
                                                        .agoraEngine!,
                                                    canvas: VideoCanvas(
                                                        uid: adminUid),
                                                    // Replace with remote user UID
                                                    connection: RtcConnection(
                                                        channelId:
                                                            widget.channelId),
                                                  ),
                                                ),
                                                Container(
                                                  height: Get.height,
                                                  width: Get.width,
                                                  color: filterColor,
                                                )
                                              ],
                                            );
                                          }
                                        }

                                        return AgoraVideoView(
                                          controller:
                                              VideoViewController.remote(
                                            rtcEngine: _controller.agoraEngine!,
                                            canvas: VideoCanvas(
                                                uid:
                                                    adminUid), // Replace with remote user UID
                                            connection: RtcConnection(
                                                channelId: widget.channelId),
                                          ),
                                        ); // Default UI
                                      },
                                    )
                              : Padding(
                                  padding:
                                      EdgeInsets.only(top: Get.height * .16),
                                  child: Column(
                                    children: [
                                      (_controller.isPk.value == true)
                                          ? StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('livestreams')
                                                  .doc(widget.channelId)
                                                  .collection('battles')
                                                  .doc('currentBattle')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }

                                                var battleData = snapshot.data!
                                                        .data()
                                                    as Map<String, dynamic>?;
                                                if (battleData == null ||
                                                    battleData[
                                                            'participants'] ==
                                                        null) {
                                                  return Center(
                                                      child: Text(
                                                          'Battle data not available'));
                                                }

                                                // Extract scores
                                                var adminScore =
                                                    battleData['adminScore'] ??
                                                        0;
                                                var cohostScore =
                                                    battleData['cohostScore'] ??
                                                        0;
                                                int totalScore =
                                                    adminScore + cohostScore;
                                                double adminProgress =
                                                    totalScore > 0
                                                        ? adminScore /
                                                            totalScore
                                                        : 0.5;

                                                // Extract participant details
                                                var participants =
                                                    battleData['participants']
                                                        as List<dynamic>;
                                                var admin =
                                                    participants.firstWhere(
                                                  (participant) =>
                                                      participant['uid'] ==
                                                      'adminUid',
                                                  orElse: () => {
                                                    'name': 'Admin',
                                                    'photo': '',
                                                    'uid': 'adminUid'
                                                  },
                                                );
                                                var cohost =
                                                    participants.firstWhere(
                                                  (participant) =>
                                                      participant['uid'] ==
                                                      'cohostUid',
                                                  orElse: () => {
                                                    'name': 'Cohost',
                                                    'photo': '',
                                                    'uid': 'cohostUid'
                                                  },
                                                );

                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    // Progress Bars
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        LinearProgressIndicator(
                                                            value: 1.0,
                                                            color: Colors.cyan,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            minHeight: 25),
                                                        LinearProgressIndicator(
                                                          value: adminProgress,
                                                          color: Colors.blue,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          minHeight: 25,
                                                        ),
                                                      ],
                                                    ),

                                                    // Diamond counts and labels
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Admin
                                                        Text(
                                                          adminScore.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),

                                                        // Cohost
                                                        Text(
                                                          cohostScore
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          : SizedBox(),
                                      Container(
                                        height: Get.height * .5,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (widget.isAdmin)
                                                    ? SizedBox(
                                                        width: Get.width * .5,
                                                        child: AgoraVideoView(
                                                          controller:
                                                              VideoViewController(
                                                            rtcEngine: _controller
                                                                .agoraEngine!,
                                                            canvas:
                                                                const VideoCanvas(
                                                                    uid: 0),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: Get.width * .5,
                                                        child: AgoraVideoView(
                                                          controller:
                                                              VideoViewController
                                                                  .remote(
                                                            rtcEngine: _controller
                                                                .agoraEngine!,
                                                            canvas: VideoCanvas(
                                                                uid: adminUid),
                                                            // Replace with remote user UID
                                                            connection: RtcConnection(
                                                                channelId: widget
                                                                    .channelId),
                                                          ),
                                                        )),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('livestreams')
                                                      .doc(widget.channelId)
                                                      .collection('cohosts')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center();
                                                    }

                                                    if (snapshot.hasError ||
                                                        !snapshot.hasData ||
                                                        snapshot.data!.docs
                                                            .isEmpty) {
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        _controller.hasCohosts
                                                                .value =
                                                            false; // True if cohosts available, false otherwise
                                                      });
                                                      return const Center(
                                                        child: Text(
                                                          'No Cohosts Available',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      );
                                                    }

                                                    // Cohosts exist
                                                    // _controller.hasCohosts.value = true; // Update reactive state

                                                    // Get the first cohost's UID
                                                    cohostUid = snapshot.data!
                                                        .docs.first['uid'];

                                                    return SizedBox(
                                                      width: Get.width * .5,
                                                      child: (uid == cohostUid)
                                                          ? AgoraVideoView(
                                                              controller:
                                                                  VideoViewController(
                                                                rtcEngine:
                                                                    _controller
                                                                        .agoraEngine!,
                                                                canvas:
                                                                    const VideoCanvas(
                                                                        uid: 0),
                                                              ),
                                                            )
                                                          : AgoraVideoView(
                                                              controller:
                                                                  VideoViewController
                                                                      .remote(
                                                                rtcEngine:
                                                                    _controller
                                                                        .agoraEngine!,
                                                                canvas: VideoCanvas(
                                                                    uid:
                                                                        cohostUid),
                                                                connection:
                                                                    RtcConnection(
                                                                        channelId:
                                                                            widget.channelId),
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                            (_controller.isPk.value == true)
                                                ? Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: StreamBuilder<
                                                        DocumentSnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'livestreams')
                                                          .doc(widget.channelId)
                                                          .collection('battles')
                                                          .doc('currentBattle')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        }

                                                        var battleData =
                                                            snapshot.data!
                                                                    .data()
                                                                as Map<String,
                                                                    dynamic>?;
                                                        if (battleData ==
                                                                null ||
                                                            battleData[
                                                                    'status'] !=
                                                                'ongoing') {
                                                          return Center(
                                                              child: Text(
                                                                  'No ongoing battle'));
                                                        }

                                                        int remainingTime =
                                                            battleData[
                                                                    'timer'] ??
                                                                0;
                                                        String formattedTime =
                                                            _formatTime(
                                                                remainingTime);

                                                        // End the battle if the timer reaches 0
                                                        // if (remainingTime <= 0) {
                                                        //   _controller.endBattle(widget.channelId , cohostUid.toString());
                                                        // }

                                                        return Container(
                                                          width:
                                                              Get.width * .25,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                  'assets/icons/box1.png'),
                                                              Image.asset(
                                                                  'assets/icons/box2.png'),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                formattedTime,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize:
                                                                        18.r),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ))
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      )
                    : const Center(),
              ),

              // Top Streamer Info
              if (widget.isAdmin || cohostUid == uid)
                Positioned(
                    bottom: !_controller.hasCohosts.value
                        ? MediaQuery.of(context).size.height * 0.45
                        : MediaQuery.of(context).size.height * 0.38,

                    // Adjust top position based on screen height
                    // Adjust left margin
                    right: MediaQuery.of(context).size.width * 0.015,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_controller.hasCohosts.value)
                          GestureDetector(
                              onTap: () {
                                _controller.startBattleDialog(
                                    context,
                                    widget.channelId,
                                    adminUid.toString(),
                                    cohostUid.toString());
                              },
                              child: Image.asset(
                                'assets/icons/live_startbattle.png',
                                height: 32.r,
                              )),
                        GestureDetector(
                          onTap: () {
                            showMusicSelectionSheet(context, widget.channelId);
                          },
                          child: Image.asset(
                            'assets/icons/live_music.png',
                            height: 50.r,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
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
                          height: _controller.isCameraOn.value ? 10 : 2,
                        ),
                        GestureDetector(
                            onTap: () {
                              _controller.switchCamera();
                            },
                            child: Image.asset(
                              'assets/icons/live_rotate.png',
                              height: 50.r,
                            )),
                        SizedBox(height: 5,),
                        GestureDetector(
                            onTap: () {
                              _showVoiceEffectsBottomSheet(context);
                            },
                            child: Image.asset(
                              'assets/icons/live_voicefilters.png',
                              height: 35.r,
                            )),
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
                                color: (!_controller.hasCohosts.value)
                                    ? Colors.black.withOpacity(0.4)
                                    : Colors.blue.withOpacity(0.7),
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

                                  child: Row(children: [Image.asset('assets/icons/live.png' , width: 25,),
                                SizedBox(width: 2,),
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
                                ],),),
                                SizedBox(width: 5,),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.isAdmin
                                          ? showCohostsAndViewersBottomSheet(
                                              context, widget.channelId)
                                          : SizedBox();
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
                                        const SizedBox(width: 5),
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('livestreams')
                                              .doc(widget.channelId)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text(
                                                "0",
                                                // Placeholder until data loads
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                ),
                                              );
                                            }

                                            if (snapshot.hasError) {
                                              return Text(
                                                "",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                ),
                                              );
                                            }

                                            final data = snapshot.data?.data()
                                                as Map<String, dynamic>?;
                                            final viewsCount =
                                                data?['viewsCount'] ?? 0;

                                            return Text(
                                              viewsCount.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins'),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () {
                                    shareLiveStream(widget.channelId);
                                  },
                                  child: Column(
                                    children: [
                                     Icon(Icons.share , color: Colors.white,)
                                      // SizedBox(
                                      //   height: 2,
                                      // ),
                                      // Text(
                                      //   'Share',
                                      //   style: TextStyle(
                                      //       fontFamily: 'Poppins',
                                      //       color: Colors.white,
                                      //       fontSize: 13.r),
                                      // )
                                    ],
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
                    height: !_controller.hasCohosts.value ? 220 : 150,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _controller.comments.isNotEmpty
                        ? ListView.builder(
                      controller: _scrollController, // Attach the scroll controller
                      itemCount: _controller.comments.length,
                      itemBuilder: (context, index) {
                        final comment = _controller.comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                backgroundImage: NetworkImage(comment['photo']),
                                radius: 22,
                              ),
                              const SizedBox(width: 10),
                              // Comment Bubble
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
            name, photo, widget.channelId);          },
            ),
          ),

                        SizedBox(
                          width: 3,
                        ),
                        if (widget.isAdmin)
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.black.withOpacity(0.8),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: JoinRequestsBar(
                                    channelId: widget.channelId,
                                    onAccept: (userId, name, photo) {
                                      _controller.acceptJoinRequest(
                                          widget.channelId, userId);
                                    },
                                    onReject: (userId) {
                                      _controller.rejectJoinRequest(
                                          widget.channelId, userId);
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset('assets/icons/live_requests.png',
                                    height: 50.r),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Requests',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 13.r),
                                )
                              ],
                            ),
                          ),

                        if (!widget.isAdmin)
                          GestureDetector(
                            onTap: () {
                              _controller.requestToJoinStream(widget.channelId,
                                  uid.toString(), name, photo);
                              if(widget.isAdmin)
                              Get.snackbar(
                                'Request Received',
                                '$name requested to join the live',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.black.withOpacity(0.9),
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(10),
                                borderRadius: 12,
                                duration: const Duration(seconds: 4),
                                icon: const Icon(Icons.person_add,
                                    color: Colors.white),
                                mainButton: TextButton(
                                  onPressed: () {
                                    Get.back(); // Close snackbar
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: JoinRequestsBar(
                                          channelId: widget.channelId,
                                          onAccept: (userId, name, photo) {
                                            _controller.acceptJoinRequest(
                                              widget.channelId,
                                              userId,
                                            );
                                            print('Accepted: $userId, $name');
                                            Get.back();
                                          },
                                          onReject: (userId) {
                                            _controller.rejectJoinRequest(
                                                widget.channelId, userId);
                                            print('Rejected: $userId');
                                            Get.back();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 500),
                                barBlur: 10,
                                overlayBlur: 2,
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/icons/live_requests.png',
                                  height: 50.r,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Request',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 13.r),
                                )
                              ],
                            ),
                          ),
SizedBox(width: 5,),
SizedBox(width: 5,),

                        SizedBox(
                          width: 3,
                        ),


                        // if (!widget.isAdmin)
                        //   GestureDetector(
                        //     onTap: () {
                        //       showModalBottomSheet(
                        //         context: context,
                        //         isScrollControlled: true,
                        //         backgroundColor: Colors.black.withOpacity(0.8),
                        //         builder: (context) => GiftsBottomSheet(
                        //           roomId: widget.channelId ?? '',
                        //           isBattleSatrted:
                        //               _controller.isPk.value ?? false,
                        //         ),
                        //       );
                        //     },
                        //     child: Column(
                        //       children: [
                        //         Image.asset('assets/icons/live_gift.png',
                        //             height: 50.r),
                        //         SizedBox(
                        //           height: 2,
                        //         ),
                        //         Text(
                        //           'Gifts',
                        //           style: TextStyle(
                        //               fontFamily: 'Poppins',
                        //               color: Colors.white,
                        //               fontSize: 13.r),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        SizedBox(
                          width: 3,
                        ),


                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('livestreams')
                    .doc(widget.channelId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final musicPath = snapshot.data!['currentmusic'];
                    final musicId = snapshot.data!['currentmusic_id'];

                    if (musicPath != null) {
                      // Check if the music is new
                      if (currentlyPlayingMusic != musicPath) {
                        currentlyPlayingMusic = musicPath; // Update the flag

                        // Play music from the path
                        _controller.playMusic(musicId, widget.channelId);
                      }
                    } else {
                      // Stop the music if currentmusic is null
                      if (currentlyPlayingMusic != null) {
                        currentlyPlayingMusic = null; // Reset the flag

                        // Send a message indicating the music has stopped

                        _controller.stopMusic();
                      }
                    }
                  }
                  return Container(); // UI for your users
                },
              ),

              // Center(
              //     child: RecentGiftsWidget(
              //   roomId: widget.channelId ?? '',
              // )),
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
            borderRadius: BorderRadius.circular(10), // Adjusted border radius
          ),
          backgroundColor:HexColor('#2C2D2A'), // Set background to match the image
          child: Padding(
            padding: const EdgeInsets.only(top: 40 , left: 20 , right: 20 , bottom: 40), // Add padding around content
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
                    backgroundColor: Colors.blue, // Button color to match the image
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Match button style
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10), // Adjust padding
                  ),
                  onPressed: () async {
                    heartbeatTimer?.cancel(); // Cancel the timer when the widget is disposed
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


  void showCohostsAndViewersBottomSheet(
      BuildContext context, String channelId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FullScreenBottomSheetContent(channelId: channelId),
    );
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

  void _showVoiceEffectsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return VoiceEffectsBottomSheet(
          onEffectSelected: (AudioEffectPreset? effect) {
            _applyVoiceEffect(effect);
          },
        );
      },
    );
  }
  void _applyVoiceEffect(AudioEffectPreset? effect) async {
    if (_controller
        .agoraEngine == null) return;

    if (effect == null || effect == AudioEffectPreset.audioEffectOff) {
      await _controller
          .agoraEngine?.setAudioEffectPreset(AudioEffectPreset.audioEffectOff);
    } else {
      await _controller
          .agoraEngine?.setAudioEffectPreset(effect);
    }
  }

}
