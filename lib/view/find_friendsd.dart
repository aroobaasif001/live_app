import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';

class FindFriendsScreen extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Find Friends")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('UserEntity').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Users Found"));
          }

          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>?;

              // Extract user details safely
              String userId = users[index].id;
              if (userId == currentUserId) return Container(); // Skip current user

              String userName = userData?['firstName'] ?? 'Unknown';
              String userImage = userData?['image'] ??
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6vBz9VgjksAaZZkWOm8Lk3ZSb7gO25eP0-Q&s';

              List<dynamic> subscribersList = userData?['subscribers'] != null
                  ? List<dynamic>.from(userData?['subscribers'])
                  : [];

              bool isSubscribed = subscribersList.contains(currentUserId);
              int subscriberCount = subscribersList.length;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 25,
                ),
                title: CustomText(
                  text: userName,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                subtitle: CustomText(
                  text: "$subscriberCount Subscribers",
                  fontSize: 12,
                  color: Colors.grey,
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    if (isSubscribed) {
                      await _unsubscribeUser(userId, currentUserId);
                    } else {
                      await _subscribeUser(userId, currentUserId);
                    }
                  },
                  child: CustomGradientButton(
                    text: isSubscribed ? "Unsubscribe" : "Subscribe",
                    height: 35,
                    width: 120,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// **Function to handle subscription logic**
  Future<void> _subscribeUser(String userId, String currentUserId) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) return;

        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

        List<dynamic> subscribersList = userData?['subscribers'] != null
            ? List<dynamic>.from(userData?['subscribers'])
            : [];

        if (!subscribersList.contains(currentUserId)) {
          subscribersList.add(currentUserId);
          transaction.update(userDoc, {'subscribers': subscribersList});
        }
      });

      Get.snackbar("Success", "You have subscribed successfully!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to subscribe: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _unsubscribeUser(String userId, String currentUserId) async {
    DocumentReference userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);

        if (!snapshot.exists) return;

        Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

        List<dynamic> subscribersList = userData?['subscribers'] != null
            ? List<dynamic>.from(userData?['subscribers'])
            : [];

        if (subscribersList.contains(currentUserId)) {
          subscribersList.remove(currentUserId);
          transaction.update(userDoc, {'subscribers': subscribersList});
        }
      });

      Get.snackbar("Success", "You have unsubscribed successfully!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to unsubscribe: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
