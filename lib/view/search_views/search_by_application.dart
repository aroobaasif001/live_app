import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/icons_path.dart';

class SearchByApplication extends StatefulWidget {
  const SearchByApplication({super.key});

  @override
  State<SearchByApplication> createState() => _SearchByApplicationState();
}

class _SearchByApplicationState extends State<SearchByApplication> {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers =
  FirebaseFirestore.instance.collection('UserEntity').snapshots();

  final List<String> _searchChips = ["Electronics", "iPhone"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: StreamBuilder(
          stream: getAllUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No users found"));
            }

            var users = snapshot.data!.docs;

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      // Search Row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: const TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search by application",
                                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          CustomText(
                            text: "Cancel",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: "Gilroy-Bold",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Tabs: "Suggested" & "Saved"
                      ButtonsTabBar(
                        unselectedBackgroundColor: Colors.white,
                        borderWidth: 0,
                        unselectedBorderColor: Colors.transparent,
                        borderColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.pinkAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        tabs: const [
                          Tab(text: "Suggested"),
                          Tab(text: "Saved"),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // "Your previous searches" + "Clear"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Your previous searches",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            fontFamily: "Gilroy-Bold",
                          ),
                          CustomText(
                            text: "Clear",
                            color: Color(0xff815BFF),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            fontFamily: "Gilroy-Bold",
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Dynamically build chips from _searchChips list
                      Row(
                        children: _searchChips.map((chip) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildRemovableChip(chip),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),

                      // "Previously viewed users"
                      CustomText(
                        text: "Previously viewed users",
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        fontFamily: "Gilroy-Bold",
                      ),
                      const SizedBox(height: 15),

                      // Users List
                      _userListView(users),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds each chip with a close icon to remove it
  Widget _buildRemovableChip(String chipText) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chipText),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchChips.remove(chipText);
                });
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the user list from Firestore
  Widget _userListView(List<QueryDocumentSnapshot<Map<String, dynamic>>> users) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        var user = users[index].data();
        String firstName = user['firstName'] ?? 'Unknown';
        String imageUrl = user['image'] ?? appleIcon;
        // Get the subscribersList length; if it's null, default to 0.
        int subscribers = user['subscribersList'] != null
            ? (user['subscribersList'] as List).length
            : 0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(appleIcon, height: 40, width: 40);
                  },
                ),
              ),
              const SizedBox(width: 10),
              // User Name & Subscribers
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: firstName,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy-Bold",
                  ),
                  CustomText(
                    color: const Color(0xff8C8C8C),
                    fontSize: 14,
                    fontFamily: "Gilroy-Bold",
                    text: '$subscribers subscribers',
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}
