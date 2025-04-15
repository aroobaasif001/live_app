import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_app/entities/notification_entity.dart';
import 'package:live_app/services/send_notification_service.dart';
import 'package:live_app/utils/colors.dart';
import '../../../custom_widgets/custom_text.dart';
import '../../../entities/message_model.dart';
import '../../../entities/registration_entity.dart';
import '../../../utils/icons_path.dart';
import '../../../utils/images_path.dart';

class ChatScreen extends StatefulWidget {
  final RegistrationEntity receiver;

  ChatScreen({required this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    print("Chat with: ${widget.receiver.firstName} (${widget.receiver.regId})");
  }
bool _isSendingImage = false;

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _sendImageMessage();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _sendImageMessage();
    }
  }

  // void _sendMessage() {
  //   String text = _messageController.text.trim();
  //   if (text.isEmpty) return;

  //   MessageModel message = MessageModel(
  //     senderId: currentUser!.uid,
  //     receiverId: widget.receiver.regId!,
  //     text: text,
  //     imageUrl: null,
  //     timestamp: Timestamp.now(),
  //   );

  //   FirebaseFirestore.instance.collection('messages').add({
  //     ...message.toJson(),
  //     "participants": [currentUser!.uid, widget.receiver.regId],
  //   });

  //   _messageController.clear();
  // }



  void _sendMessage() async {
  String text = _messageController.text.trim();
  if (text.isEmpty) return;

  MessageModel message = MessageModel(
    senderId: currentUser!.uid,
    receiverId: widget.receiver.regId!,
    text: text,
    imageUrl: null,
    timestamp: Timestamp.now(),
  );

  // 1. Save message
  await FirebaseFirestore.instance.collection('messages').add({
    ...message.toJson(),
    "participants": [currentUser!.uid, widget.receiver.regId],
  });

  // 2. Save notification to Firestore
  final userDoc = await FirebaseFirestore.instance
    .collection('UserEntity')
    .doc(currentUser!.uid)
    .get();

final userName = userDoc.data()?['firstName'] ?? 'Someone';
  final notificationDoc = FirebaseFirestore.instance.collection('notifications').doc();
  final notification = NotificationEntity(
    id: notificationDoc.id,
    title: "New message",
    body: text,
    receiverId: widget.receiver.regId!,
    senderId: currentUser!.uid,
    timestamp: DateTime.now(),
    data: {
      "screen": "chat",
      "senderId": currentUser!.uid,
    },
  );
  await notificationDoc.set(notification.toMap());

  // 3. Fetch receiver's token and send push notification
  final receiverDoc = await FirebaseFirestore.instance
      .collection('UserEntity')
      .doc(widget.receiver.regId)
      .get();

  final fcmToken = receiverDoc.data()?['fcmToken'];
  if (fcmToken != null && fcmToken.toString().isNotEmpty) {
    await SendNotificationService.sendNotificationUsingApi(
      token: fcmToken,
      title: notification.title,
      body: notification.body,
      data: notification.data,
    );
  }

  _messageController.clear();
}

Future<void> _sendImageMessage() async {
  if (_selectedImage == null) return;

  setState(() {
    _isSendingImage = true;
  });

  try {
    // Upload image to Firebase Storage
    String fileName =
        "${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference storageRef =
        FirebaseStorage.instance.ref().child("chat_images/$fileName");

    UploadTask uploadTask = storageRef.putFile(_selectedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Save message to Firestore
    MessageModel message = MessageModel(
      senderId: currentUser!.uid,
      receiverId: widget.receiver.regId!,
      text: "",
      imageUrl: imageUrl,
      timestamp: Timestamp.now(),
    );

    await FirebaseFirestore.instance.collection('messages').add({
      ...message.toJson(),
      "participants": [currentUser!.uid, widget.receiver.regId],
    });

    // Save notification to Firestore
    final notificationDoc = FirebaseFirestore.instance.collection('notifications').doc();
    final notification = NotificationEntity(
      id: notificationDoc.id,
      title: "Image",
      body: "Image You Recieved",
      receiverId: widget.receiver.regId!,
      senderId: currentUser!.uid,
      timestamp: DateTime.now(),
      data: {
        "screen": "chat",
        "senderId": currentUser!.uid,
        "imageUrl": imageUrl,
      },
    );
    await notificationDoc.set(notification.toMap());

    // Send notification to receiver
    final receiverDoc = await FirebaseFirestore.instance
        .collection('UserEntity')
        .doc(widget.receiver.regId)
        .get();

    final fcmToken = receiverDoc.data()?['fcmToken'];
    if (fcmToken != null && fcmToken.toString().isNotEmpty) {
      await SendNotificationService.sendNotificationUsingApi(
        token: fcmToken,
        title: notification.title,
        body: notification.body,
        data: notification.data ?? {},
      );
    }

    setState(() {
      _selectedImage = null;
      _isSendingImage = false;
    });
  } catch (e) {
    print("Image upload error: $e");
    setState(() {
      _isSendingImage = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send image')),
    );
  }
}

// Future<void> _sendImageMessage() async {
//   if (_selectedImage == null) return;

//   setState(() {
//     _isSendingImage = true;
//   });

//   try {
//     String fileName =
//         "${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
//     Reference storageRef =
//         FirebaseStorage.instance.ref().child("chat_images/$fileName");

//     UploadTask uploadTask = storageRef.putFile(_selectedImage!);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     String imageUrl = await taskSnapshot.ref.getDownloadURL();

//     MessageModel message = MessageModel(
//       senderId: currentUser!.uid,
//       receiverId: widget.receiver.regId!,
//       text: "",
//       imageUrl: imageUrl,
//       timestamp: Timestamp.now(),
//     );

//     await FirebaseFirestore.instance.collection('messages').add({
//       ...message.toJson(),
//       "participants": [currentUser!.uid, widget.receiver.regId],
//     });

//     setState(() {
//       _selectedImage = null;
//       _isSendingImage = false;
//     });
//   } catch (e) {
//     print("Image upload error: $e");
//     setState(() {
//       _isSendingImage = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Failed to send image')),
//     );
//   }
// }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(applegImage),
            ),
            SizedBox(width: 10),
            CustomText(
                text: widget.receiver.firstName ?? "", color: Colors.black),
          ],
        ),

      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          if (_isSendingImage)
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("Sending image..."),
          ],
        ),
      ),
          _buildMessageInput(),
        ],
      ),
    );
  } 
final ScrollController _scrollController = ScrollController();


  Widget _buildMessagesList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('messages')
        .where('participants', arrayContains: currentUser!.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No messages yet"));
      }

      List<MessageModel> messages = snapshot.data!.docs
          .map((doc) =>
              MessageModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((msg) =>
              (msg.senderId == currentUser!.uid &&
                  msg.receiverId == widget.receiver.regId) ||
              (msg.senderId == widget.receiver.regId &&
                  msg.receiverId == currentUser!.uid))
          .toList();

      // 🔃 Sort by timestamp manually
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // 🔽 Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return buildMessageItem(messages[index]);
        },
      );
    },
  );
}


  Widget buildMessageItem(MessageModel message) {
    bool isMe = message.senderId == currentUser!.uid;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              backgroundImage: widget.receiver.image != null &&
                      widget.receiver.image!.isNotEmpty
                  ? NetworkImage(widget.receiver.image!)
                  : AssetImage(applegImage) as ImageProvider,
              radius: 18,
            ),
          SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.purple : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : Radius.circular(12),
                    ),
                  ),
                  child: message.imageUrl != null
                      ? Image.network(message.imageUrl!,
                          width: 200, height: 200, fit: BoxFit.cover)
                      : Text(
                          message.text,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                ),
                SizedBox(height: 4),
                Text(
                  message.timestamp
                      .toDate()
                      .toLocal()
                      .toString()
                      .substring(0, 16), // Format timestamp
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildMessageItem(MessageModel message) {
  //   bool isMe = message.senderId == currentUser!.uid;

  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Center(
  //           child: Text(
  //             "${message.timestamp.toDate()}",
  //             style: TextStyle(color: Colors.grey, fontSize: 12),
  //           ),
  //         ),
  //         Container(
  //           padding: EdgeInsets.all(10),
  //           margin: EdgeInsets.symmetric(vertical: 4),
  //           decoration: BoxDecoration(
  //             color: isMe ? Colors.purple : Colors.grey[200],
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: message.imageUrl != null
  //               ? Image.network(message.imageUrl!, width: 200)
  //               : Text(
  //                   message.text,
  //                   style: TextStyle(color: isMe ? Colors.white : Colors.black),
  //                 ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
            child:
                Icon(Icons.camera_alt_outlined, size: 30, color: Colors.black),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Send message..",
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: primaryGradientColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_upward, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
