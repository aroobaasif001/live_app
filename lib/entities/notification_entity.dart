import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String receiverId;
  final String? senderId;
  final DateTime timestamp;
  final Map<String, dynamic>? data;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.receiverId,
    required this.timestamp,
    this.senderId,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'receiverId': receiverId,
      'senderId': senderId,
      'timestamp': timestamp,
      'data': data,
    };
  }

  factory NotificationEntity.fromMap(Map<String, dynamic> map) {
    return NotificationEntity(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      receiverId: map['receiverId'],
      senderId: map['senderId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
    );
  }
}