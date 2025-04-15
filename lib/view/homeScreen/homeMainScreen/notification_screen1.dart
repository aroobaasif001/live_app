// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class NotificationScreen1 extends StatelessWidget {
//   const NotificationScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Notifications",style: TextStyle(color: Colors.white),)),
//         body: Center(child: Text("Please login to view notifications.")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text("Notifications",style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.deepPurple,
//       ),
//       backgroundColor: Colors.grey[100],
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('notifications')
//            // .where('receiverId', isEqualTo: currentUser.uid)
//             .where('senderId', isEqualTo: currentUser.uid)
//             //.orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No Notifications Found'));
//           }

//           final notifications = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: notifications.length,
//             itemBuilder: (context, index) {
//               final notification = notifications[index];
//               final title = notification['title'] ?? 'No Title';
//               final body = notification['body'] ?? '';
//               final timestamp = (notification['timestamp'] as Timestamp).toDate();

//               return ListTile(
//                 leading: Icon(Icons.notifications, color: Colors.deepPurple),
//                 title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(body),
//                     Text(
//                       "${timestamp.toLocal()}",
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationScreen1 extends StatelessWidget {
  const NotificationScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Notifications", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(child: Text("Please login to view notifications.")),
      );
    }

    final uid = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: uid)
            .snapshots(),
        builder: (context, receiverSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('senderId', isEqualTo: uid)
                .snapshots(),
            builder: (context, senderSnapshot) {
              if (receiverSnapshot.connectionState == ConnectionState.waiting ||
                  senderSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final receiverDocs = receiverSnapshot.data?.docs ?? [];
              final senderDocs = senderSnapshot.data?.docs ?? [];

              // 🔁 Combine both
              final allNotifications = [...receiverDocs, ...senderDocs];

              if (allNotifications.isEmpty) {
                return const Center(child: Text('No Notifications Found'));
              }

              // 📅 Sort by timestamp descending
              allNotifications.sort((a, b) {
                final aTime = (a['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                final bTime = (b['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                return bTime.compareTo(aTime);
              });

              return ListView.builder(
                itemCount: allNotifications.length,
                itemBuilder: (context, index) {
                  final notification = allNotifications[index];
                  final title = notification['title'] ?? 'No Title';
                  final body = notification['body'] ?? '';
                  final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();

                  return ListTile(
                    leading: Icon(Icons.notifications, color: Colors.deepPurple),
                    title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(body),
                        if (timestamp != null)
                          Text(
                            "${timestamp.toLocal()}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
