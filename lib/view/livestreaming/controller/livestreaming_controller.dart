import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';


import '../../homeScreen/bottomNaviagtionBar/bottom_nav_bar.dart';

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

  final chatController = TextEditingController(); // Chat input controller
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var comments = <Map<String, dynamic>>[].obs; // Store real-time comments


  @override
  void onClose() {
    leaveStream();

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

    final randomLeft =
        Random().nextDouble() * 200; // Random left position for variation

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

  Future<String> generateToken(String channelName, int uid) async {
    if (FirebaseAuth.instance.currentUser != null) {
      HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('generateAgoraToken');
      final response = await callable.call({
        'channelName': channelName,
        'uid': uid,
      });
      return response.data['token'];
    } else {

      throw Exception('User is not authenticated');
    }
  }


  Future<void> initializeAgora(
      String channelId, int uid, bool isAdmin, int adminId) async {
    try {
      // Initial debug logs
      print('[DEBUG] initializeAgora() called with:');
      print('  channelId: $channelId');
      print('  uid: $uid');
      print('  isAdmin: $isAdmin');
      print('  adminId: $adminId');

      // Generate token and log its value
      print('[DEBUG] Calling generateToken with channelId: $channelId and uid: $uid');
      String token = await generateToken(channelId, uid);
      print('[DEBUG] Received token: $token');

      // Create and initialize the RTC engine
      print('[DEBUG] Creating RTC engine...');
      _rtcEngine = createAgoraRtcEngine();
      if (_rtcEngine == null) {
        print('[ERROR] Failed to create RTC engine.');
        return;
      }
      print('[DEBUG] RTC engine created successfully.');

      print('[DEBUG] Initializing RTC engine...');
      await _rtcEngine?.initialize(
        const RtcEngineContext(
          appId: '0f0b7dc97d754349a53fa35ee828ab03',
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      print('[DEBUG] RTC engine initialized successfully.');

      // Register event handlers
      print('[DEBUG] Registering event handlers...');
      _rtcEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined.value = true;
            print('[INFO] Joined channel: ${connection.channelId}, uid: $uid, elapsed: $elapsed');
            updateUserCount(connection.channelId!);
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            isJoined.value = false;
            print('[INFO] Left channel: ${connection.channelId}');
            updateUserCount(connection.channelId!);
          },
          onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
            remoteUids.add(rUid);
            print('[INFO] Remote user $rUid joined channel: ${connection.channelId}, elapsed: $elapsed');
            updateUserCount(connection.channelId!);
          },
          onUserOffline: (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
            print('[INFO] Remote user $rUid went offline, Reason: $reason');
            remoteUids.removeWhere((element) => element == rUid);
            _allUserLeft.value = true;

            if (adminId == rUid) {
              print('[DEBUG] Admin ($adminId) went offline, deleting live stream for channel: ${connection.channelId}');
              deleteLiveStream(channelId);
            }
            updateUserCount(connection.channelId!);
          },
        ),
      );
      if (_rtcEngine == null) {
        print('[ERROR] _rtcEngine is null. Initialization might have failed.');
        return;
      }

      print('[DEBUG] Event handlers registered successfully.');

      // Create data stream
      print('[DEBUG] Creating data stream...');
      streamId = await _rtcEngine?.createDataStream(
        const DataStreamConfig(syncWithAudio: false),
      );
      if (streamId == null) {
        print('[ERROR] Failed to create data stream.');
      } else {
        print('[INFO] Data stream created successfully with streamId: $streamId');
      }

      // Set client role
      print('[DEBUG] Setting client role...');
      await _rtcEngine?.setClientRole(
        role: isAdmin
            ? ClientRoleType.clientRoleBroadcaster // Admin can speak
            : ClientRoleType.clientRoleAudience, // Others can only listen
      );
      print('[DEBUG] Client role set: ${isAdmin ? "Broadcaster" : "Audience"}');

      // Enable video and audio
      print('[DEBUG] Enabling video and audio...');
      await _rtcEngine?.enableVideo();
      await _rtcEngine?.enableAudio();
      await _rtcEngine?.enableLocalVideo(true);
      await _rtcEngine?.startPreview();
      print('[DEBUG] Video and audio enabled.');

      // Set audio profile
      print('[DEBUG] Setting audio profile...');
      await _rtcEngine?.setAudioProfile(
        profile: AudioProfileType.audioProfileMusicHighQuality,
        scenario: AudioScenarioType.audioScenarioGameStreaming,
      );
      print('[DEBUG] Audio profile set.');

      // Join channel
      print('[DEBUG] Joining channel with token: $token, channelId: $channelId, uid: $uid');
      await _rtcEngine?.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: isAdmin
              ? ClientRoleType.clientRoleBroadcaster
              : ClientRoleType.clientRoleAudience,
        ),
      );
      print('[INFO] Successfully joined channel: $channelId');
      isJoined.value = true;

    } catch (e) {
      print('[ERROR] Agora initialization error: $e');
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
    await sendStreamMessage(
        isMuted.value ? 'User muted audio' : 'User unmuted audio');
  }

  void toggleCamera() async {
    try {
      if (isCameraOn.value) {
        await _rtcEngine?.enableLocalVideo(false); // Disable local video
        isCameraOn.value = false;
        print('[INFO] Camera turned OFF');

        // Notify other users about video toggle
        await sendStreamMessage('User turned off camera');
      } else {
        await _rtcEngine?.enableLocalVideo(true); // Enable local video
        await _rtcEngine?.startPreview(); // Start video preview
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

  Future<void> initializeFirestore(String channelId) async {
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
        comments.value = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });

      print('[INFO] Firestore initialized and listening for comments');
    } catch (e) {
      print('[ERROR] Firestore initialization error: $e');
    }
  }

  void sendMessage(String name, String photo, String channelId) async {
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
  void sendBidMessage(String name, String photo, String channelId, String message, double bid, String productDocId, String currentUserId) async {
    try {
      // Add bid message to the comments collection in livestreams
      await _firestore
          .collection('livestreams')
          .doc(channelId)
          .collection('comments')
          .add({
        'message': message,
        'bid': bid,
        'timestamp': FieldValue.serverTimestamp(),
        'user': name,
        'photo': photo, // User photo
      });

      // Update the product document with bidder information
      await _firestore.collection('products').doc(productDocId).set({
        'bidders': {currentUserId: bid}
      }, SetOptions(merge: true)); // Merge to avoid overwriting existing data

      chatController.clear();
      print('[INFO] Bid message added and product updated');
    } catch (e) {
      print('[ERROR] Failed to add bid: $e');
    }
  }


  Future<void> deleteLiveStream(String channelId) async {
    try {
      // Reference to the live stream document
      final liveStreamDoc = _firestore.collection('livestreams').doc(channelId);

      // Specify known subcollection names
      final subcollectionNames = [
        'comments',
        'participants',
      ]; // Replace with your actual subcollection names

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
      Get.offAll(() => BottomNavigationBarWidget()); //
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

  Future<void> leaveStreamUser(String channelId, String userId) async {
    try {
      // Reference to the live stream document
      final liveStreamRef =
          FirebaseFirestore.instance.collection('livestreams').doc(channelId);

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
      Get.offAll(() => BottomNavigationBarWidget()); //
    } catch (e) {
      print('Error while leaving the stream: $e');
    }
  }

  /// Play Deezer preview music
}

class HeartEmoji {
  final double left;
  final double size;
  final double duration;
  HeartEmoji(
      {required this.left,
      this.size = 30,
      this.duration = 3000,
      required double opacity});
}
