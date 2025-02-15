import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'live_streaming.dart';

class LiveStreamViewScreen extends StatelessWidget {
  final CollectionReference livestreams =
  FirebaseFirestore.instance.collection('livestreams');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('live_streams'.tr),
        centerTitle: true,
        backgroundColor: Colors.blue
      ),
      body: FutureBuilder(
        future: livestreams.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('error_fetching_data'.tr));
          }

          final data = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return LiveStreamCard(
                title: item['title'] ?? 'No Title',
                adminName: item['adminName'] ?? 'Unknown',
                viewers: item['viewsCount'] ?? 0, channelId: item['channelId'].toString(), adminPhoto: item['adminPhoto'],
              );
            },
          );
        },
      ),
    );
  }
}

class LiveStreamCard extends StatelessWidget {
  final String title;
  final String adminName;
  final int viewers;
  final String channelId;
  final String adminPhoto;

  LiveStreamCard({
    required this.title,
    required this.adminName,
    required this.viewers,
    required this.channelId,
    required this.adminPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await joinLiveStreamingWithPrefs(channelId);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  adminPhoto,
                  fit: BoxFit.cover,
                ),
              ),
              // Live Badge
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 1.5,         // Border width
                    ),
                  ),
                  child: Text(
                    'Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // Viewers Count
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.white, size: 18),
                      SizedBox(width: 5),
                      Text(
                        '$viewers',
                        style: TextStyle(color: Colors.white, fontSize: 16 ,                     fontFamily: 'Poppins'
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Admin Name
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  adminName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



  /// Function to get data from SharedPreferences and call joinLiveStreaming
  Future<void> joinLiveStreamingWithPrefs(String channelId) async {
    try {
      // Retrieve data from SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      final uid = 10000 + Random().nextInt(90000); ;
      final name =  'Guest';
      final photo = 'https://www.shutterstock.com/image-photo/blond-hair-girl-taking-photo-260nw-2492842415.jpg';

      if (uid == 0) {
        print('[ERROR] UID is not available in SharedPreferences.');
        return;
      }

      await joinLiveStreaming(channelId, uid, name, photo);
    } catch (e) {
      print('[ERROR] Failed to retrieve data from SharedPreferences: $e');
    }
  }

  /// Function to join live streaming
  Future<void> joinLiveStreaming(
      String channelId, int uid, String name, String photo) async {
    try {
      // Add the user to the "participants" subcollection in Firestore
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .collection('participants')
          .doc(uid.toString())
          .set({
        'name': name,
        'photo': photo,
        'uid': uid,
        'role': 'guest', // Default role for users joining the stream
        'timestamp': FieldValue.serverTimestamp(), // Time when the user joined
      });

      // Optionally, you can update the user count in the main document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final viewsCount = (data['viewsCount'] ?? 0) + 1; // Increment views count

        await FirebaseFirestore.instance
            .collection('livestreams')
            .doc(channelId)
            .update({'viewsCount': viewsCount});
      }

      print('[INFO] User $name joined the stream.');
      Get.to(() => LiveStreamingScreen(
        channelId: channelId,
        isAdmin: false,
      ));
    } catch (e) {
      print('[ERROR] Failed to join the stream: $e');
    }
  }

