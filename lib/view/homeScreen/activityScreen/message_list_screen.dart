import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/entities/registration_entity.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/images_path.dart';
import '../../../custom_widgets/custom_text.dart';
import '../../../utils/icons_path.dart';
import 'chat_screen.dart';
import 'widget/new_message_bottom_sheet.dart';

class MessagesList extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Messages".tr)),
        body: Center(child: Text("Please log in to view messages".tr)),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('UserEntity').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users available".tr));
          }

          String currentUserId = currentUser!.uid;

          // Extract users who have currentUserId in their subscribers list
          List<RegistrationEntity> users = userSnapshot.data!.docs
              .map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            List<String> subscribers = List<String>.from(data['subscribers'] ?? []);
            return RegistrationEntity(
              regId: doc.id,
              firstName: data['firstName'] ?? 'Unknown',
              image: data['image'] ?? applegImage,
              subscribers: subscribers,
            );
          })
              .where((user) => user.regId != currentUserId && user.subscribers!.contains(currentUserId))
              .toList();

          if (users.isEmpty) {
            return Center(child: Text("No subscribers yet".tr));
          }

          // Fetch messages from Firestore
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('messages').snapshots(),
            builder: (context, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              List<String> usersWhoMessagedMe = chatSnapshot.hasData
                  ? chatSnapshot.data!.docs
                  .map((doc) => (doc.data() as Map<String, dynamic>)['senderId'] as String)
                  .toSet()
                  .toList()
                  : [];

              // Show users who are subscribers OR messaged first
              List<RegistrationEntity> filteredUsers = users.where((user) =>
              usersWhoMessagedMe.contains(user.regId) || // Sent message
                  user.subscribers!.contains(currentUserId) // Subscribed to me
              ).toList();

              if (filteredUsers.isEmpty) {
                return Center(child: Text("No messages from subscribers".tr));
              }

              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  return buildUserItem(context, filteredUsers[index]);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: primaryGradientColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            showNewMessageBottomSheet(context);
          },
          icon: Image.asset(penIcon),
          label: Text("Write".tr, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget buildUserItem(BuildContext context, RegistrationEntity user) {
    return ListTile(
      leading: Image.network(
        user.image ?? applegImage,
        height: 40,
        width: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(applegImage, height: 40, width: 40),
      ),
      title: CustomText(
        text: user.firstName ?? '',
        fontWeight: FontWeight.w500,
        fontFamily: 'Gilroy-Bold',
        fontSize: 16,
      ),
      subtitle: CustomText(
        text: "Tap to chat".tr,
        fontWeight: FontWeight.w400,
        fontFamily: 'Gilroy-Bold',
        fontSize: 16,
        color: Colors.grey,
      ),
      trailing: CustomText(
        text: "4 d.",
        fontWeight: FontWeight.w500,
        fontFamily: 'Gilroy-Bold',
        fontSize: 16,
        color: Colors.grey,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(receiver: user)),
        );
      },
    );
  }
}
