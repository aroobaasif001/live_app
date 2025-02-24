import 'dart:math';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'live_streaming.dart';

class LivePreviewScreen extends StatefulWidget {
  final String name; // Parameter to receive the name
  final String photo; // Parameter to receive the photo

  LivePreviewScreen({
    required this.name,
    required this.photo,
  });

  @override
  _LivePreviewScreenState createState() => _LivePreviewScreenState();
}

class _LivePreviewScreenState extends State<LivePreviewScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isFrontCamera = true;
  final TextEditingController _titleController = TextEditingController();
  bool isAdmin = true; // isAdmin variable set to
  int? uid;
  String? ChannelId;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    uid = 10000 + Random().nextInt(90000); // Generates a 5-digit number
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    ChannelId =
        List.generate(5, (index) => chars[Random().nextInt(chars.length)]).join();
    // ChannelId = 'testchannel';
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = cameras.firstWhere(
          (camera) => _isFrontCamera
          ? camera.lensDirection == CameraLensDirection.front
          : camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _initializeCamera();
    });
  }

  Future<void> _startLiveStream() async {
    String title = _titleController.text.trim();

    if (title.isEmpty) {
      // If title is empty, set a default title.
      title = 'Live Streaming';
    }

    // Store live stream details in Firebase Firestore
    try {
      final liveStreamData = {
        "title": title,
        "adminName": widget.name,
        "adminPhoto": widget.photo,
        "adminUid": uid,
        "isAdmin": isAdmin,
        "channelId": ChannelId,
        'viewsCount': 0,
        'currentmusic': null,
        'currentFilter': null,
        'currentmusic_id': null,
        'heartbeat': null,
        "timestamp": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(ChannelId)
          .set(liveStreamData);

      // Navigate to LiveStreamingScreen
      _cameraController?.dispose();
      _titleController.dispose();
      Get.to(() => LiveStreamingScreen(
        channelId: ChannelId ?? '',
        isAdmin: true,
        uid: uid ?? 0,
      ));
    } catch (e) {
      Get.snackbar(
        "error".tr,
        "live_stream_error".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _titleController.dispose();
    super.dispose();
  }

  /// Wraps the camera preview with a RotatedBox to fix orientation.
  Widget _buildCameraPreview() {
    if (_cameraController?.value.isInitialized ?? false) {
      return RotatedBox(
        quarterTurns: 3, // Rotates the preview 270° clockwise to fix upside down
        child: CameraPreview(_cameraController!),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: _isCameraInitialized
                  ? _buildCameraPreview()
                  : const Center(child: CircularProgressIndicator()),
            ),
            // Top Section for Image, Title, and Close Button
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'enter_live_title'.tr,
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Circular Camera Switch Button
            Positioned(
              bottom: 150,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: _switchCamera,
                child: const Icon(Icons.cameraswitch, color: Colors.white),
              ),
            ),
            // Prominent Go Live Button
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _startLiveStream,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'go_live'.tr,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

