// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/utils/images_path.dart';
// import 'package:live_app/view/homeScreen/activityScreen/chat_screen.dart';

// import '../../../../custom_widgets/custom_text.dart';
// import '../../../../utils/colors.dart';

// class NewMessageBottomSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.9,
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
         
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("New message", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               IconButton(
//                 icon: Icon(Icons.close),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           Divider(),
        
//           Row(
//             children: [
//               Text("To whom: ", style: TextStyle(fontWeight: FontWeight.bold)),
//               Expanded(
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Nickname",
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Divider(),
       
//           Expanded(
//             child: ListView.builder(
//               itemCount: 5,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   onTap: (){
//                     //Get.to(()=>ChatScreen(receiver: ?'',));
//                   },
//                   leading: Image.asset(applegImage),
//                   title: CustomText(text:"company_name", fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',fontSize: 16,),
//           subtitle: CustomText(text:"You are Subscribed",fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',fontSize: 16,color: textColor),
//           trailing: CustomText(text: "4 d.",fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',fontSize: 16,color: textColor,),
//                 );
//               },
//             ),
//           ),
  
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.text_format),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
              
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../custom_widgets/custom_text.dart';
import '../../../../entities/registration_entity.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/images_path.dart';
import '../../../homeScreen/activityScreen/chat_screen.dart';

void showNewMessageBottomSheet(BuildContext context) {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Header (Title + Close Button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "New message".tr,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),

                // Search Bar
                Row(
                  children: [
                    Text("To whom: ".tr, style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Nickname".tr,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),

                // User List (Fetched from Firestore)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('UserEntity').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No users available".tr));
                      }

                      List<RegistrationEntity> users = snapshot.data!.docs
                          .map((doc) => RegistrationEntity.fromJson(doc.data() as Map<String, dynamic>))
                          .where((user) => user.firstName != null && user.firstName!.toLowerCase().contains(searchQuery))
                          .toList();

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return buildUserItem(context, users[index]);
                        },
                      );
                    },
                  ),
                ),

                // Message Input Field (Kept for future implementation)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.text_format),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Type a message...".tr,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Function to build a single user item
Widget buildUserItem(BuildContext context, RegistrationEntity user) {
  return ListTile(
    onTap: () {
      Get.to(() => ChatScreen(receiver: user));
    },
    leading: Image.asset(applegImage),
    title: CustomText(
      text: user.firstName ?? "Unknown User",
      fontWeight: FontWeight.w500,
      fontFamily: 'Gilroy-Bold',
      fontSize: 16,
    ),
    subtitle: CustomText(
      text: "You are Subscribed".tr,
      fontWeight: FontWeight.w400,
      fontFamily: 'Gilroy-Bold',
      fontSize: 16,
      color: textColor,
    ),
    trailing: CustomText(
      text: "4 d.",
      fontWeight: FontWeight.w500,
      fontFamily: 'Gilroy-Bold',
      fontSize: 16,
      color: textColor,
    ),
  );
}
