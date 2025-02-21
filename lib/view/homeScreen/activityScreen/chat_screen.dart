import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  void _sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    MessageModel message = MessageModel(
      senderId: currentUser!.uid,
      receiverId: widget.receiver.regId!,
      text: text,
      imageUrl: null,
      timestamp: Timestamp.now(),
    );

    FirebaseFirestore.instance.collection('messages').add({
      ...message.toJson(),
      "participants": [currentUser!.uid, widget.receiver.regId],
    });

    _messageController.clear();
  }

  Future<void> _sendImageMessage() async {
    if (_selectedImage == null) return;

    String fileName =
        "${currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference storageRef =
        FirebaseStorage.instance.ref().child("chat_images/$fileName");

    UploadTask uploadTask = storageRef.putFile(_selectedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    MessageModel message = MessageModel(
      senderId: currentUser!.uid,
      receiverId: widget.receiver.regId!,
      text: "",
      imageUrl: imageUrl,
      timestamp: Timestamp.now(),
    );

    FirebaseFirestore.instance.collection('messages').add({
      ...message.toJson(),
      "participants": [currentUser!.uid, widget.receiver.regId],
    });

    setState(() {
      _selectedImage = null;
    });
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
            CustomText(
                text: widget.receiver.firstName ?? "", color: Colors.black),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.black),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('participants', arrayContains: currentUser!.uid)
          //.orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
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

        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.all(16),
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
                hintText: "Send message...",
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
