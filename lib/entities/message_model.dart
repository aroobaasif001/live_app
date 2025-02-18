import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final String? imageUrl; 
  final Timestamp timestamp;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    this.imageUrl, 
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json["senderId"] ?? "",
      receiverId: json["receiverId"] ?? "",
      text: json["text"] ?? "",
      imageUrl: json["imageUrl"],
      timestamp: json["timestamp"] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "text": text,
      "imageUrl": imageUrl, 
      "timestamp": timestamp,
    };
  }
}
