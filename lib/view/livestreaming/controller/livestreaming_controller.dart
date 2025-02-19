import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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



  Future<void> initializeAgora(
      String channelId, int uid, bool isAdmin, int adminId) async {
    try {
      print('uidid $uid chnn $channelId ');
      String? token =
          '007eJxTYAhbHnLzDJdK1KYZp1e+/VRbbrpT/Xyf7ILfdY9UND3a1DsUGFIsU8xNDMyNLS3NEk3SLFIsUgwTDY2SDVIt04xNzQ2MV35Zl94QyMjgGljOwsgAgSA+N0NJanFJckZiXl5qDgMDAInDIyI=';
      print('tokenn $token');
      _rtcEngine = createAgoraRtcEngine();

      await _rtcEngine?.initialize(
        const RtcEngineContext(
          appId: 'd9d74073996a4f8d8d1a12c0e9f35703',
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
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
            print(
                '[INFO] Remote user $rUid joined channel: ${connection.channelId}');
            updateUserCount(connection.channelId!);
          },
          onUserOffline: (RtcConnection connection, int rUid,
              UserOfflineReasonType reason) {
            print('offlineee');
            remoteUids.removeWhere((element) => element == rUid);
            _allUserLeft.value = true;

            print(
                '[INFO] Remote user $rUid left channel: ${connection.channelId}, Reason: $reason');
            if (adminId == rUid) {
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
        role: isAdmin
            ? ClientRoleType.clientRoleBroadcaster // Admin can speak
            : ClientRoleType.clientRoleAudience, // Others can only listen
      );

      await _rtcEngine?.enableVideo();
      await _rtcEngine?.enableAudio();

      if (isAdmin) {
        await _rtcEngine
            ?.enableLocalAudio(true); // Admin can capture and send audio
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
            clientRoleType: ClientRoleType.clientRoleBroadcaster),
      );


      await Future.delayed(const Duration(seconds: 2));
      print('yey0');
      await _rtcEngine?.enableLocalVideo(false);
      await _rtcEngine?.enableLocalVideo(true);
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
  void sendBidMessage(String name, String photo, String channelId , String message , double bid) async {

      try {
        await _firestore
            .collection('livestreams')
            .doc(channelId)
            .collection('comments')
            .add({
          'message': message,
          'bid': bid,

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
