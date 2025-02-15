import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:just_audio/just_audio.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


import 'package:get/get_connect/http/src/response/response.dart';
import 'package:live_app/view/homeScreen/homeMainScreen/home_main_screen.dart';

import '../../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';
import '../services/audioplayer_service.dart';



class LiveStreamController extends GetxController {
  RtcEngine? _rtcEngine; // Agora RTC Engine
  int? streamId; // Stream ID for sending messages
  var isJoined = false.obs; // Track stream joined status
  var isMuted = false.obs; // Track mute/unmute status
  var isCameraOn = true.obs; // Track camera on/off status
  var _allUserLeft = false.obs; // Track camera on/off status

  var floatingHearts = <HeartEmoji>[].obs;
      var remoteUids = <int>[].obs; // List to store Agora remote UIDs
  var userCount = 0.obs; // Real-time user count

  var hasCohosts = false.obs;
  var isPk = false.obs;
  var isMusicPlayerVisible = false.obs; // Controls the visibility of the music widget
  String? currentMusicPath; // Stores the current music file path
  Duration currentPosition = Duration.zero; // Tracks the current playback position
  Duration totalDuration = Duration.zero; // Tracks the total duration of the music
  final AudioPlayer audioPlayer = AudioPlayer(); // Instance of AudioPlayer




  final chatController = TextEditingController(); // Chat input controller
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var comments = <Map<String, dynamic>>[].obs; // Store real-time comments


  @override
  void onInit() {
    super.onInit();


  }




  @override
  void onClose() {
    leaveStream();
    audioPlayer.dispose(); // Dispose of the audio player

    chatController.dispose();

    super.onClose();
  }

  // **Getter for Agora RTC Engine**
  RtcEngine? get agoraEngine => _rtcEngine;


  bool _isSendingHeart = false; // Add a flag to prevent spamming

  Future<void> addFloatingHeart(String channelId) async {
    if (_isSendingHeart) {
      // If the user is still in cooldown, do nothing
      print("Spam prevention: Please wait before sending another heart.");
      return;
    }

    // Set the flag to true to prevent further calls
    _isSendingHeart = true;

    final randomLeft = Random().nextDouble() * 200; // Random left position for variation

    // Add heart data to Firestore
    final heartData = {
      'left': randomLeft,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      // Add the heart to Firestore and get the document reference
      final heartRef = await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId) // Use live stream document ID
          .collection('hearts') // Subcollection for hearts
          .add(heartData);

      // Wait for 1 second before allowing the next heart
      Future.delayed(const Duration(seconds: 1), () async {
        _isSendingHeart = false; // Reset the flag after the cooldown
        try {
          await heartRef.delete(); // Delete the heart after 1 second
        } catch (e) {
          print("Error deleting heart: $e");
        }
      });
    } catch (e) {
      print("Error adding heart: $e");
      _isSendingHeart = false; // Reset the flag in case of an error
    }
  }





  Future<String?> generateAgoraToken(int uid, String channelName, int expireTime) async {
    // API endpoint
    final String url = "http://141.98.153.237:3000/api/generate-token";
    print("[DEBUG] API URL: $url");

    // Request payload
    final Map<String, dynamic> payload = {
      "uid": uid,
      "channel_name": channelName,
      "expire_time": expireTime,
    };
    print("[DEBUG] Request Payload: ${json.encode(payload)}");

    // Headers
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };
    print("[DEBUG] Request Headers: $headers");

    try {
      // Send POST request
      print("[DEBUG] Sending POST request...");
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(payload),
      );
      print("[DEBUG] Response Status Code: ${response.statusCode}");
      print("[DEBUG] Response Body: ${response.body}");

      // Check the response status
      if (response.statusCode == 200) {
        print("[DEBUG] Response is successful (200). Parsing body...");
        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (responseBody.containsKey("token")) {
          print("[DEBUG] Token found in response: ${responseBody["token"]}");
          return responseBody["token"]; // Return the token
        } else {
          print("[ERROR] Token not found in the response: $responseBody");
        }
      } else {
        print("[ERROR] Failed to generate token.");
        print("[ERROR] Status Code: ${response.statusCode}");
        print("[ERROR] Response Body: ${response.body}");
      }
    } catch (e) {
      print("[EXCEPTION] Error generating Agora token: $e");
    }
    return null;
  }


  Future<void> initializeAgora(String channelId , int uid , bool isAdmin , int adminId ) async {
    try {
      print('uidid $uid chnn $channelId ' );
      String? token = '007eJxTYAhbHnLzDJdK1KYZp1e+/VRbbrpT/Xyf7ILfdY9UND3a1DsUGFIsU8xNDMyNLS3NEk3SLFIsUgwTDY2SDVIt04xNzQ2MV35Zl94QyMjgGljOwsgAgSA+N0NJanFJckZiXl5qDgMDAInDIyI=';
      print('tokenn $token');
      _rtcEngine = createAgoraRtcEngine();

      await _rtcEngine?.initialize(
        const RtcEngineContext(appId: 'd9d74073996a4f8d8d1a12c0e9f35703' ,         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      // Register event handlers with logs
      _rtcEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            print('[INFO] Joined channel: ${connection.channelId}');
              updateUserCount(connection.channelId!);
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            print('[INFO] Left channel: ${connection.channelId}');
              updateUserCount(connection.channelId!);
          },
          onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
            remoteUids.add(rUid);
            print('[INFO] Remote user $rUid joined channel: ${connection.channelId}');
              updateUserCount(connection.channelId!);
          },
          onUserOffline: (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
            print('offlineee');
            remoteUids.removeWhere((element) => element == rUid);
            _allUserLeft.value  =true;

            print('[INFO] Remote user $rUid left channel: ${connection.channelId}, Reason: $reason');
            if(adminId == rUid)
              {
                deleteLiveStream(channelId);
              }
              updateUserCount(connection.channelId!);
          },
          

        ),
      );

      streamId = await _rtcEngine?.createDataStream(
        const DataStreamConfig(syncWithAudio: false),
      );

      if (streamId == null) {
        print('[ERROR] Failed to create data stream');
      } else {
        print('[INFO] Data stream created with streamId: $streamId');
      }

      await _rtcEngine?.setClientRole(
        role :isAdmin
            ? ClientRoleType.clientRoleBroadcaster // Admin can speak
            : ClientRoleType.clientRoleAudience,  // Others can only listen
      );

      await _rtcEngine?.enableVideo();
      await _rtcEngine?.enableAudio();

      if (isAdmin) {
        await _rtcEngine?.enableLocalAudio(true); // Admin can capture and send audio
      } else {
        await _rtcEngine?.enableLocalAudio(false); // Audience cannot send audio
      }

      await _rtcEngine?.enableLocalVideo(true);

      await _rtcEngine?.startPreview();



      await _rtcEngine?.setAudioProfile(
        profile: AudioProfileType.audioProfileMusicHighQuality,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );
      await _rtcEngine?.joinChannel(
        token: token ?? '',
        channelId: channelId,
        uid: uid,
        options: ChannelMediaOptions(
         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
         clientRoleType:  ClientRoleType.clientRoleBroadcaster
        ),
      );

      // await _rtcEngine?.enableVideo();
      // await _rtcEngine?.startPreview();
      await Future.delayed(const Duration(seconds: 2));
     print('yey0');
      await _rtcEngine?.enableLocalVideo(false);
      await _rtcEngine?.enableLocalVideo(true);

    } catch (e) {
      print('[ERROR] Agora initialization error: $e');
    }
  }

  Future<void> switchClientRole(bool isBroadcaster) async {
    try {
      // final newRole = isBroadcaster
      //     ? ClientRoleType.clientRoleBroadcaster
      //     : ClientRoleType.clientRoleAudience;
      //
      // await _rtcEngine?.setClientRole(role :newRole);

      print('[INFO] Switched role to: ${isBroadcaster ? 'Broadcaster' : 'Audience'}');

      if (isBroadcaster) {
        // Enable local video and audio for the broadcaster
        await _rtcEngine?.enableLocalVideo(true);
        await _rtcEngine?.enableAudio();

        await _rtcEngine?.startPreview();
        await Future.delayed(const Duration(seconds: 3));
        print('yey0');
        await _rtcEngine?.enableLocalVideo(false);
        await _rtcEngine?.enableLocalVideo(true);
        await _rtcEngine?.enableAudio();

      } else {
        // Disable local video and audio for the audience
        await _rtcEngine?.enableLocalVideo(false);
        await _rtcEngine?.disableAudio();

        await _rtcEngine?.stopPreview();
      }
    } catch (e) {
      print('[ERROR] Failed to switch client role: $e');
    }
  }


  void updateUserCount(String channelId) async {
    // Total users include local user (1) + remote users
    userCount.value = isJoined.value ? remoteUids.length + 1 : 0;
    print('[INFO] User count updated: ${userCount.value}');

    // Add a slight delay to ensure state consistency
    await Future.delayed(Duration(seconds: 1));

    if (userCount.value == 0) {
      print('[INFO] No users in the channel. Deleting the live stream...');
      // await deleteLiveStream(channelId);
      return; // Exit early
    }

    try {
      // Update the viewsCount in Firestore
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .update({
        'viewsCount': userCount.value,
      });
      print('[INFO] Firestore viewsCount updated: ${userCount.value}');
    } catch (e) {
      print('[ERROR] Failed to update viewsCount in Firestore: $e');
    }
  }


  Future<void> leaveStream() async {
    try {
      await _rtcEngine?.leaveChannel();
      print('[INFO] Successfully left the channel');
    } catch (e) {
      print('[ERROR] Failed to leave the channel: $e');
    }
    await _rtcEngine?.release();
    _rtcEngine = null;
  }

  Future<void> sendStreamMessage(String message) async {
    if (streamId == null) {
      print('[ERROR] Data stream not initialized.');
      return;
    }

    Uint8List messageBytes = Uint8List.fromList(message.codeUnits);
    int length = messageBytes.length;

    try {
      await _rtcEngine?.sendStreamMessage(
        streamId: streamId!,
        data: messageBytes,
        length: length,
      );
      print('[INFO] Sent message: $message');
    } catch (e) {
      print('[ERROR] Failed to send message: $e');
    }
  }

  void toggleMute() async {
    isMuted.value = !isMuted.value;
    await _rtcEngine?.muteLocalAudioStream(isMuted.value);
    print('[INFO] Microphone ${isMuted.value ? "muted" : "unmuted"}');
    await sendStreamMessage(isMuted.value ? 'User muted audio' : 'User unmuted audio');
  }

void toggleCamera() async {
    try {
      if (isCameraOn.value) {
        await _rtcEngine?.enableLocalVideo(false);  // Disable local video
        isCameraOn.value = false;
        print('[INFO] Camera turned OFF');

        // Notify other users about video toggle
        await sendStreamMessage('User turned off camera');
      } else {
        await _rtcEngine?.enableLocalVideo(true);  // Enable local video
        await _rtcEngine?.startPreview();  // Start video preview
        isCameraOn.value = true;
        print('[INFO] Camera turned ON');

        // Notify other users about video toggle
        await sendStreamMessage('User turned on camera');
      }
    } catch (e) {
      print('[ERROR] Camera toggle failed: $e');
    }
  }

  void switchCamera() async {
    await _rtcEngine?.switchCamera();
    print('[INFO] Camera switched');
    await sendStreamMessage('User switched camera');
  }


   Future<void> initializeFirestore( String channelId) async {
    try {
      // Create a unique document for the livestream if it doesn't exist
      // DocumentReference docRef = _firestore.collection('livestreams').doc('testchannel');
      // await docRef.set({'createdAt': FieldValue.serverTimestamp()}, SetOptions(merge: true));
      // livestreamDocId = 'testchannel';

      // Listen to comments in the "comments" subcollection
      _firestore
          .collection('livestreams')
          .doc(channelId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        comments.value = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });

      print('[INFO] Firestore initialized and listening for comments');
    } catch (e) {
      print('[ERROR] Firestore initialization error: $e');
    }
  }

  void sendMessage(String name , String photo , String channelId) async {
    if (chatController.text.trim().isNotEmpty && channelId != null) {
      try {
        await _firestore
            .collection('livestreams')
            .doc(channelId)
            .collection('comments')
            .add({
          'message': chatController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'user': name,
          'photo': photo, // Random user identifier
        });
        chatController.clear();
        print('[INFO] Comment added');
      } catch (e) {
        print('[ERROR] Failed to add comment: $e');
      }
    }
  }
  Future<void> deleteLiveStream(String channelId) async {
  try {
    // Reference to the live stream document
    final liveStreamDoc = _firestore.collection('livestreams').doc(channelId);

    // Specify known subcollection names
    final subcollectionNames = ['comments', 'gifts' , 'participants' , 'cohosts' , 'battles' , 'joinRequests']; // Replace with your actual subcollection names

    // Delete all subcollections and their documents
    for (var subcollectionName in subcollectionNames) {
      final subcollection = liveStreamDoc.collection(subcollectionName);
      final subcollectionDocs = await subcollection.get();
      for (var doc in subcollectionDocs.docs) {
        await doc.reference.delete();
      }
    }

    // Delete the document itself
    await liveStreamDoc.delete();
    Get.snackbar(
      "Success",
      "Live stream successfully deleted",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.offAll(() =>  BottomNavigationBarWidget()); //
  } catch (e) {
    Get.snackbar(
      "Error",
      "Failed to delete live stream: $e",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
  Future<void> requestToJoinStream(String channelId, String userId, String name, String photo) async {
    await FirebaseFirestore.instance
        .collection('livestreams')
        .doc(channelId)
        .collection('joinRequests')
        .doc(userId)
        .set({
      'name': name,
      'uid' :userId,
      'photo': photo,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> rejectJoinRequest(String channelId, String userId) async {
    try {
      // Remove the join request
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .collection('joinRequests')
          .doc(userId)
          .delete();

      print('[INFO] Rejected request for $userId');
    } catch (e) {
      print('[ERROR] Failed to reject request: $e');
    }
  }


  Future<void> acceptJoinRequest(String channelId, String userId) async {
    try {
      // Fetch the join request details
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .collection('joinRequests')
          .doc(userId)
          .get();

      if (requestDoc.exists) {
        final data = requestDoc.data() as Map<String, dynamic>;
        final name = data['name'] ?? 'Unknown';
        final photo = data['photo'] ?? 'https://via.placeholder.com/150';
        final uidString = data['uid'] ?? '0'; // Get UID as a string
        final uid = int.tryParse(uidString) ?? 0; // Convert to int or default to 0

        // Add user to cohosts
        await FirebaseFirestore.instance
            .collection('livestreams')
            .doc(channelId)
            .collection('cohosts')
            .doc(userId)
            .set({
          'name': name,
          'photo': photo,
          'uid': uid,
          'isPk' : false,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Remove the join request
        await FirebaseFirestore.instance
            .collection('livestreams')
            .doc(channelId)
            .collection('joinRequests')
            .doc(userId)
            .delete();

        print('[INFO] Accepted request for $name ($userId) and added to cohosts');
      } else {
        print('[WARNING] Join request does not exist for user $userId');
      }
    } catch (e) {
      print('[ERROR] Failed to accept request: $e');
    }
  }


  Future<void> leaveStreamUser(String channelId, String userId) async {
    try {
      // Reference to the live stream document
      final liveStreamRef = FirebaseFirestore.instance.collection('livestreams').doc(channelId);

      // Subcollections to check
      final subCollections = ['participants', 'cohosts', 'joinedRequests'];

      for (final subCollection in subCollections) {
        final userDoc = await liveStreamRef
            .collection(subCollection)
            .doc(userId)
            .get(); // Check if the user exists in the subcollection

        if (userDoc.exists) {
          // If the document exists, delete it
          await liveStreamRef.collection(subCollection).doc(userId).delete();
          print('Removed user $userId from $subCollection');
        }
      }

      print('User $userId successfully left the stream.');
      Get.offAll(() =>  BottomNavigationBarWidget()); //

    } catch (e) {
      print('Error while leaving the stream: $e');
    }
  }




  Future<void> startBattleDialog(BuildContext context, String roomId, String adminUid, String cohostUid) {
    double selectedTime = 5.0; // Default time in minutes

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Set Battle Time",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Select the duration for the battle",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                    Slider(
                      value: selectedTime,
                      min: 1,
                      max: 60,
                      divisions: 59,
                      label: "${selectedTime.toInt()} minutes",
                      activeColor: Colors.white,
                      inactiveColor: Colors.white54,
                      onChanged: (value) {
                        setState(() {
                          selectedTime = value;
                        });
                      },
                    ),
                    Text(
                      "${selectedTime.toInt()} minutes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close the dialog
                        await startBattle(
                          roomId,
                          adminUid,
                          cohostUid,
                          selectedTime.toInt() * 60, // Convert minutes to seconds
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        "Start Battle",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> startBattle(String roomId, String adminUid, String cohostUid, int duration) async {
    final battleDoc = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(roomId)
        .collection('battles')
        .doc('currentBattle');

    final cohostDoc = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(roomId)
        .collection('cohosts')
        .doc(cohostUid);

    try {
      // Create or update the battle document
      await battleDoc.set({
        'timer': duration, // Set the timer dynamically
        'status': 'ongoing',
        'participants': [
          {
            'uid': adminUid,
            'name': 'Admin',
            'photo': 'adminPhotoUrl', // Replace with actual admin photo URL
          },
          {
            'uid': cohostUid,
            'name': 'Cohost',
            'photo': 'cohostPhotoUrl', // Replace with actual cohost photo URL
          },
        ],
      });

      // Set isPk for the cohost
      await cohostDoc.update({'isPk': true});

      // Start countdown timer
      await startCountdownTimer(roomId, cohostUid);
      AudioPlayerService().playSound('start.mp3');
    } catch (e) {
      print('Error starting battle: $e');
      Get.snackbar(
        "Error",
        "Failed to start the battle. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }





  Future<void> endBattle(String roomId, String cohostUid) async {
    final battleDoc = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(roomId)
        .collection('battles')
        .doc('currentBattle');

    final cohostDoc = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(roomId)
        .collection('cohosts')
        .doc(cohostUid);

    try {
      // Fetch battle data
      final snapshot = await battleDoc.get();
      if (!snapshot.exists) {
        throw Exception("Battle document does not exist.");
      }

      final data = snapshot.data()!;
      int adminScore = data['adminScore'] ?? 0; // Default to 0
      int cohostScore = data['cohostScore'] ?? 0; // Default to 0

      String winner = adminScore > cohostScore
          ? 'Admin Wins!'
          : adminScore < cohostScore
          ? 'Cohost Wins!'
          : 'It\'s a Tie!';
      chatController.text = winner;


       adminScore > cohostScore
          ? AudioPlayerService().playSound('win.mp3')
          : adminScore < cohostScore
          ? AudioPlayerService().playSound('win.mp3')
          : AudioPlayerService().playSound('tie.mp3');
      // Update battle status
      await battleDoc.update({
        'status': 'ended',
        'winner': winner,
      });

      // Reset isPk field for the cohost
      await cohostDoc.update({'isPk': false});

      Get.snackbar(
        "Battle Ended",
        winner,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      AudioPlayerService().playSound('assets/tie.mp3');

      sendMessage('Official', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTAQf5Apq3RmNQA1fxFN80R2uOQgyYpkgR2-g&s', roomId);
    } catch (e) {
      print('Error ending battle: $e');
      Get.snackbar(
        "Error",
        "Failed to end the battle. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> startCountdownTimer(String roomId , String cohostuid) async {
    final battleDoc = FirebaseFirestore.instance
        .collection('livestreams')
        .doc(roomId)
        .collection('battles')
        .doc('currentBattle');

    Timer.periodic(Duration(seconds: 1), (timer) async {
      final snapshot = await battleDoc.get();
      if (!snapshot.exists) {
        timer.cancel();
        return;
      }

      final data = snapshot.data()!;
      int remainingTime = data['timer'] ?? 0;

      if (remainingTime > 0) {
        await battleDoc.update({'timer': remainingTime - 1});
      } else {
        timer.cancel();
        await endBattle(roomId , cohostuid);
      }
    });
  }



  Future<String?> fetchFreshDeezerUrl(String trackId) async {
    final String deezerTrackUrl = "https://api.deezer.com/track/$trackId";

    try {
      print("Fetching fresh Deezer preview URL for track ID: $trackId...");
      final response = await http.get(Uri.parse(deezerTrackUrl));

      print("Deezer API Response Status: ${response.statusCode}");
      print("Deezer API Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('preview')) {
          final previewUrl = data['preview'];
          print("Fetched fresh preview URL: $previewUrl");
          return previewUrl;
        } else {
          print("Error: Deezer API response does not contain 'preview' field.");
        }
      } else {
        print("Error: Deezer API returned status ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching Deezer preview: $e");
    }

    return null; // Return null if no valid URL is found
  }

  /// Play Deezer preview music
  Future<void> playMusic(String trackId, String channelId) async {
    try {
      print("Fetching fresh URL for trackId: $trackId...");
      String? freshUrl = await fetchFreshDeezerUrl(trackId);

      if (freshUrl == null || freshUrl.isEmpty) {
        print("Error: Unable to fetch fresh preview URL.");
        return;
      }

      print("Using fresh URL: $freshUrl");

      print("Attempting to set URL...");
      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(freshUrl)));
      print("URL set successfully.");

      print("Player state before play: ${audioPlayer.playerState.processingState}");

      print("Attempting to play audio...");
      await audioPlayer.play();

      print("Music is now playing...");

      // Wait for completion
      await audioPlayer.processingStateStream.firstWhere((state) => state == ProcessingState.completed);

      print("Music playback completed.");
    } catch (e) {
      print("Error playing music: $e");
    }
  }




  /// Get Deezer preview URL from the track ID
  // Future<String?> _extractAudioStreamUrl(String trackId) async {
  //   try {
  //     // Fetch track details from Deezer API
  //     final url = Uri.parse("$deezerBaseUrl/track/$trackId");
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return data['preview']; // Deezer provides a 30-sec preview URL
  //     } else {
  //       print("Failed to fetch track details: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error fetching Deezer preview URL: $e");
  //     return null;
  //   }
  // }
  //
  // /// Play audio from a URL using just_audio
  // Future<bool> _playAudioStream(String audioStreamUrl) async {
  //   try {
  //     await audioPlayer.setUrl(audioStreamUrl); // Use setUrl() instead of setAudioSource()
  //     await audioPlayer.play(); // Ensure play() is called properly
  //     return true;
  //   } catch (e) {
  //     print("Error while playing audio: $e");
  //     return false;
  //   }
  // }

  /// Reset the current music field in Firebase to null
  Future<void> resetCurrentMusic(String channelId) async {
    try {
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .update({'currentmusic': null});
      print("Music reset in Firebase for channel: $channelId");
    } catch (e) {
      print("Error resetting current music in Firebase: $e");
    }
  }

  void stopMusic() {
    audioPlayer.stop();
  }

}

class SharedPreferences {
}



class HeartEmoji {
  final double left;
  final double size;
  final double duration;
  HeartEmoji({required this.left, this.size = 30, this.duration = 3000, required double opacity});
}