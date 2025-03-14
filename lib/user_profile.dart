import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  final String userId;

  const UserProfile({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('UserEntity')
          .doc(widget.userId)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('[ERROR] Fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Gaming theme background
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.orbitron(color: Colors.purple, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : userData == null
          ? const Center(child: Text('User not found', style: TextStyle(color: Colors.white)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image Section
            _buildProfileImage(userData!['image']),
            const SizedBox(height: 20),

            // Name Display
            Text(
              '${userData!['firstName']} ${userData!['lastName']}',
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),

            // Email
            Text(
              userData!['email'] ?? 'No email provided',
              style: GoogleFonts.orbitron(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),

            // User Info Section
            _buildUserInfoCard('Gender', userData!['gender'], Icons.person),
            _buildUserInfoCard('City', userData!['city'], Icons.location_city),
            _buildUserInfoCard('Country', userData!['country'], Icons.public),
            _buildUserInfoCard('Street', userData!['street'], Icons.map),
            _buildUserInfoCard('House', userData!['house'], Icons.home),
            _buildUserInfoCard('Apartment', userData!['apartment'], Icons.apartment),
            _buildUserInfoCard('Entrance', userData!['entrance'], Icons.door_front_door),
            _buildUserInfoCard('Reg ID', userData!['regId'], Icons.badge),

            // Interests Section
            _buildUserInfoCard(
              'Interests',
              (userData!['interests'] as List<dynamic>).join(', '),
              Icons.interests,
            ),
            _buildUserInfoCard(
              'Detailed Interests',
              (userData!['detailedInterests'] as List<dynamic>).join(', '),
              Icons.sports_esports,
            ),

            // Reviews & Ratings
            _buildUserInfoCard('Rating', userData!['rating']?.toString() ?? 'N/A', Icons.star),
            _buildUserInfoCard('Reviews', userData!['reviews']?.toString() ?? 'N/A', Icons.rate_review),
          ],
        ),
      ),
    );
  }

  // Profile Image Widget
  Widget _buildProfileImage(String? imageUrl) {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.cyanAccent,
      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : null,
      child: imageUrl == null || imageUrl.isEmpty
          ? Icon(Icons.person, size: 50, color: Colors.black)
          : null,
    );
  }

  // User Info Card Widget
  Widget _buildUserInfoCard(String title, String? value, IconData icon) {
    return Card(
      color: Colors.black87,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(
          title,
          style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value ?? 'N/A',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }
}
