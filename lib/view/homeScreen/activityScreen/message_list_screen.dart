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
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No users available".tr));
          }

          List<RegistrationEntity> users = snapshot.data!.docs
              .map((doc) => RegistrationEntity.fromJson(
                  doc.data() as Map<String, dynamic>))
              .where((user) => user.regId != currentUser!.uid)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return buildUserItem(context, users[index]);
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
      leading: Image.asset(applegImage),
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
