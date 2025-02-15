import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FullScreenBottomSheetContent extends StatefulWidget {
  final String channelId;

  FullScreenBottomSheetContent({required this.channelId});

  @override
  _FullScreenBottomSheetContentState createState() => _FullScreenBottomSheetContentState();
}

class _FullScreenBottomSheetContentState extends State<FullScreenBottomSheetContent> {
  late Future<List<List<Map<String, dynamic>>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<List<Map<String, dynamic>>>> _fetchUsers() {
    return Future.wait([
      fetchUsers('cohosts', widget.channelId),
      fetchUsers('participants', widget.channelId),
    ]);
  }

  void _removeUser(String subcollection, String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(widget.channelId)
          .collection(subcollection)
          .doc(userId)
          .delete();

      // Refresh the UI after deletion
      setState(() {
        _usersFuture = _fetchUsers();
      });

      debugPrint('User removed successfully');
    } catch (e) {
      debugPrint('Error removing user: $e');
    }
  }

  @override

  Future<List<Map<String, dynamic>>> fetchUsers(String subcollection, String channelId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .collection(subcollection)
          .get();
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return data;
      }).toList();

      // Remove duplicates based on 'id'
      final uniqueUsers = {for (var user in users) user['id']: user}.values.toList();
      return uniqueUsers;
    } catch (e) {
      debugPrint('Error fetching users: $e');
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersFuture,
      builder: (context, AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 200,
                        height: 16.0,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final cohosts = snapshot.data?[0] ?? [];
        final viewers = snapshot.data?[1] ?? [];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    'participants'.tr,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (cohosts.isNotEmpty) ...[
               
                Row(children: [  Text(
                  'cohost'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),)
                  ,

                  SizedBox(width: 10,),
                  Icon(Icons.star , color: Colors.blue,size: 20,weight: 30, )
                
                
                ],),
                const SizedBox(height: 8),
                ...cohosts.map((user) => Dismissible(
                  key: ValueKey('cohost-${user['id']}'), // Ensures unique keys
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeUser('cohosts', user['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['photo'] ?? ''),
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        user['name'] ?? 'Unknown',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )),
              ],
              if (viewers.isNotEmpty) ...[
                const SizedBox(height: 16),
                 Text(
                  'viewers'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...viewers.map((user) => Dismissible(
                  key: ValueKey('viewer-${user['id']}'), // Ensures unique keys
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeUser('participants', user['id']);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user['photo'] ?? ''),
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        user['name'] ?? 'Unknown',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )),
              ],
            ],
          ),
        );
      },
    );
  }

}
