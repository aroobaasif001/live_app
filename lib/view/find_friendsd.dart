import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/colors.dart';

import '../services/send_notification_service.dart';

class FindFriendsScreen extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Find Friends"),
            backgroundColor: Colors.white,),
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
                   
                  },
                  child: CustomGradientButton(
                    text: isSubscribed ? "Unsubscribe" : "Subscribe",
                    height: 35,
                    width: 120,
                    onPressed: ()async{
                       if (isSubscribed) {
                      await _unsubscribeUser(userId, currentUserId);
                    } else {
                      await _subscribeUser(userId, currentUserId);
                    }
                    },
                    
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
  // Future<void> _subscribeUser(String userId, String currentUserId) async {
  //   DocumentReference userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);

  //   try {
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(userDoc);

  //       if (!snapshot.exists) return;

  //       Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

  //       List<dynamic> subscribersList = userData?['subscribers'] != null
  //           ? List<dynamic>.from(userData?['subscribers'])
  //           : [];

  //       if (!subscribersList.contains(currentUserId)) {
  //         subscribersList.add(currentUserId);
  //         transaction.update(userDoc, {'subscribers': subscribersList});
  //       }
  //     });

  //     Get.snackbar("Success", "You have subscribed successfully!",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to subscribe: ${e.toString()}",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  //   }
  // }




Future<void> _subscribeUser(String userId, String currentUserId) async {
  final userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);
  final currentUserDoc = FirebaseFirestore.instance.collection('UserEntity').doc(currentUserId);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userSnap = await transaction.get(userDoc);
      final currentSnap = await currentUserDoc.get();

      if (!userSnap.exists || !currentSnap.exists) return;

      final userData = userSnap.data() as Map<String, dynamic>;
      final currentUserData = currentSnap.data() as Map<String, dynamic>;

      List<dynamic> subscribers = List.from(userData['subscribers'] ?? []);

      if (!subscribers.contains(currentUserId)) {
        subscribers.add(currentUserId);
        transaction.update(userDoc, {'subscribers': subscribers});
      }

      /// 1. Notify the **user being followed**
      final toReceiver = FirebaseFirestore.instance.collection('notifications').doc();
      await toReceiver.set({
        'id': toReceiver.id,
        'title': "New Follower",
        'body': "${currentUserData['firstName']} subscribed to you.",
        'senderId': currentUserId,
        'receiverId': userId,
        'timestamp': DateTime.now(),
        'data': {
          'type': 'subscription',
          'screen': 'profile',
          'userId': currentUserId,
        }
      });

      /// 2. Notify the **current user (who followed)**
      final toCurrentUser = FirebaseFirestore.instance.collection('notifications').doc();
      await toCurrentUser.set({
        'id': toCurrentUser.id,
        'title': "Subscription Successful",
        'body': "You subscribed to ${userData['firstName']}.",
        'senderId': currentUserId,
        'receiverId': currentUserId,
        'timestamp': DateTime.now(),
        'data': {
          'type': 'subscription',
          'screen': 'profile',
          'userId': userId,
        }
      });

      /// 3. Push notification to the other user
      final fcmToken = userData['fcmToken'];
      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        await SendNotificationService.sendNotificationUsingApi(
          token: fcmToken,
          title: "New Follower",
          body: "${currentUserData['firstName']} subscribed to you.",
          data: {
            'type': 'subscription',
            'screen': 'profile',
            'userId': currentUserId,
          },
        );
      }
    });

    Get.snackbar("Subscribed", "You subscribed to this user.",
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

  // Future<void> _unsubscribeUser(String userId, String currentUserId) async {
  //   DocumentReference userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);

  //   try {
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       DocumentSnapshot snapshot = await transaction.get(userDoc);

  //       if (!snapshot.exists) return;

  //       Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

  //       List<dynamic> subscribersList = userData?['subscribers'] != null
  //           ? List<dynamic>.from(userData?['subscribers'])
  //           : [];

  //       if (subscribersList.contains(currentUserId)) {
  //         subscribersList.remove(currentUserId);
  //         transaction.update(userDoc, {'subscribers': subscribersList});
  //       }
  //     });

  //     Get.snackbar("Success", "You have unsubscribed successfully!",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to unsubscribe: ${e.toString()}",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  //   }
  // }



  Future<void> _unsubscribeUser(String userId, String currentUserId) async {
  final userDoc = FirebaseFirestore.instance.collection('UserEntity').doc(userId);
  final currentUserDoc = FirebaseFirestore.instance.collection('UserEntity').doc(currentUserId);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final userSnap = await transaction.get(userDoc);
      final currentSnap = await currentUserDoc.get();

      if (!userSnap.exists || !currentSnap.exists) return;

      final userData = userSnap.data() as Map<String, dynamic>;
      final currentUserData = currentSnap.data() as Map<String, dynamic>;

      List<dynamic> subscribers = List.from(userData['subscribers'] ?? []);

      if (subscribers.contains(currentUserId)) {
        subscribers.remove(currentUserId);
        transaction.update(userDoc, {'subscribers': subscribers});
      }

      /// 1. Notify the unsubscribed user
      final toReceiver = FirebaseFirestore.instance.collection('notifications').doc();
      await toReceiver.set({
        'id': toReceiver.id,
        'title': "Unsubscribed",
        'body': "${currentUserData['firstName']} unsubscribed from you.",
        'senderId': currentUserId,
        'receiverId': userId,
        'timestamp': DateTime.now(),
        'data': {
          'type': 'unsubscription',
          'screen': 'profile',
          'userId': currentUserId,
        }
      });

      /// 2. Notify the current user
      final toCurrentUser = FirebaseFirestore.instance.collection('notifications').doc();
      await toCurrentUser.set({
        'id': toCurrentUser.id,
        'title': "✅ Unsubscribed",
        'body': "You unsubscribed from ${userData['firstName']}.",
        'senderId': currentUserId,
        'receiverId': currentUserId,
        'timestamp': DateTime.now(),
        'data': {
          'type': 'unsubscription',
          'screen': 'profile',
          'userId': userId,
        }
      });

      /// 3. Push notification to the unsubscribed user
      final fcmToken = userData['fcmToken'];
      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        await SendNotificationService.sendNotificationUsingApi(
          token: fcmToken,
          title: "Unsubscribed",
          body: "${currentUserData['firstName']} just unsubscribed from you.",
          data: {
            'type': 'unsubscription',
            'screen': 'profile',
            'userId': currentUserId,
          },
        );
      }
    });

    Get.snackbar("Unsubscribed", "You have unsubscribed from this user.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white);
  } catch (e) {
    Get.snackbar("Error", "Failed to unsubscribe: \${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }
}

}