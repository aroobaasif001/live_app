import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRequestsBar extends StatelessWidget {
  final String channelId;
  final Function(String userId, String name, String photo) onAccept;
  final Function(String userId) onReject;

  JoinRequestsBar({
    required this.channelId,
    required this.onAccept,
    required this.onReject,
  });

  Stream<List<Map<String, dynamic>>> getJoinRequests(String channelId) {
    return FirebaseFirestore.instance
        .collection('livestreams')
        .doc(channelId)
        .collection('joinRequests')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Include the document ID for accept/reject
      return data;
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getJoinRequests(channelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No join requests",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        final requests = snapshot.data!;

        return Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final userId = request['id'];
              final name = request['name'] ?? 'Unknown';
              final photo = request['photo'] ??
                  'https://via.placeholder.com/150'; // Fallback photo

              return Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(photo),
                    radius: 25,
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => onAccept(userId, name, photo),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => onReject(userId),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
