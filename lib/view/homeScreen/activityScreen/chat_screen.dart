// import 'package:flutter/material.dart';
// import 'package:live_app/utils/icons_path.dart';
// import 'package:live_app/utils/images_path.dart';

// import '../../../custom_widgets/custom_text.dart';

// class ChatScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Row(
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage(applegImage), 
//             ),
//             SizedBox(width: 10),
//             CustomText(text: "company_name", color: Colors.black),
//           ],
//         ),
//         actions: [
//           IconButton(icon: Icon(Icons.more_horiz, color: Colors.black), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.all(16),
//               children: [
//                 Center(
//                   child: Text(
//                     "22.01.2025, 19:30",
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.purple,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Hello!",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     margin: EdgeInsets.symmetric(vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       "Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna.",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Text(
//                     "22.01.2025, 19:30",
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ),
               
//               ],
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
    
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Row(
//         children: [
        
//           SizedBox(width: 8),
         
       
//         Image.asset(galleryIcon),
//           SizedBox(width: 8),
//         Icon(Icons.camera_alt_outlined,size: 30,),
//           SizedBox(width: 8),
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: "Send message...",
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           CircleAvatar(
//             backgroundColor: Colors.purple,
//             child: Icon(Icons.arrow_upward, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:live_app/utils/icons_path.dart';
import 'package:live_app/utils/images_path.dart';
import '../../../custom_widgets/custom_text.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  File? _selectedImage;

  // Function to pick an image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to take a picture using the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(applegImage),
            ),
            SizedBox(width: 10),
            CustomText(text: "company_name", color: Colors.black),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.more_horiz, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Text(
                    "22.01.2025, 19:30",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Hello!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna.",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "22.01.2025, 19:30",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                // Display selected image
                if (_selectedImage != null)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImageFromGallery,
            child: Image.asset(galleryIcon, width: 30, height: 30),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _pickImageFromCamera,
            child: Icon(Icons.camera_alt_outlined, size: 30, color: Colors.black),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Send message...",
                border: InputBorder.none,
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.purple,
            child: Icon(Icons.arrow_upward, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
