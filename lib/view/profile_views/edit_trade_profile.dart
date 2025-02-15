// import 'package:flutter/material.dart';
// import 'package:live_app/custom_widgets/custom_text.dart';
// import '../../utils/images_path.dart';

// class EditTradeProfile extends StatefulWidget {
//   const EditTradeProfile({super.key});

//   @override
//   State<EditTradeProfile> createState() => _EditTradeProfileState();
// }

// class _EditTradeProfileState extends State<EditTradeProfile> {
//   final TextEditingController _nameController =
//       TextEditingController(text: "Ivan Ivanov");
//   final TextEditingController _nicknameController =
//       TextEditingController(text: "usernickname");
//   final TextEditingController _aboutController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "Edit profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           TextButton(
//             onPressed: () {
//               // Ready button action
//             },
//             child: const Text(
//               "Ready",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7E57C2), // Purple color
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 220,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(companyProfileBackgroundImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Center(
//                       child: Icon(
//                         Icons.camera_alt_rounded,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle, color: Colors.white),
//                       width: 75,
//                       height: 75,
//                       child: Icon(
//                         Icons.camera_alt_rounded,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   CustomText(
//                     text: "Personal Details",
//                     fontFamily: "Gilroy-Bold",
//                     fontSize: 18,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   EditTradeProfileCustomTextFormField(
//                     controller: _nameController,
//                     label: "Name",
//                     maxLines: 1,
//                     isBold: true,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   EditTradeProfileCustomTextFormField(
//                     controller: _nicknameController,
//                     label: "Nickname",
//                     maxLines: 1,
//                     isBold: true,
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   EditTradeProfileCustomTextFormField(
//                     controller: _aboutController,
//                     label: "About me",
//                     maxLines: 2,
//                     isBold: true,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EditTradeProfileCustomTextFormField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool isBold;
//   final int maxLines;

//   const EditTradeProfileCustomTextFormField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.isBold = false,
//     this.maxLines = 1,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFFFFFFF), // White background
//         borderRadius: BorderRadius.circular(20), // Rounded corners
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1), // Light shadow
//             spreadRadius: 2, // Spread of the shadow
//             blurRadius: 10, // Blur effect
//             offset: Offset(0, 4), // Moves shadow downwards
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black54,
//               ),
//             ),
//             SizedBox(
//               height: 40,
//               child: TextFormField(
//                 controller: controller,
//                 maxLines: maxLines,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//                   color: Colors.black,
//                 ),
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     vertical: 18,
//                     horizontal: 15,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../entities/registration_entity.dart';
import '../../utils/images_path.dart';
import '../../custom_widgets/custom_text.dart';

class EditTradeProfile extends StatefulWidget {
  final String userId;
  const EditTradeProfile({super.key, required this.userId});

  @override
  State<EditTradeProfile> createState() => _EditTradeProfileState();
}

class _EditTradeProfileState extends State<EditTradeProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  bool _isLoading = true;
  String? _profileImageUrl;
  String? _coverImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      DocumentSnapshot<RegistrationEntity> snapshot =
          await RegistrationEntity.doc(userId: widget.userId).get();

      if (snapshot.exists) {
        RegistrationEntity? profile = snapshot.data();
        setState(() {
          _firstNameController.text = profile?.firstName ?? '';
          _lastNameController.text = profile?.lastName ?? '';
          _emailController.text = profile?.email ?? '';
          _cityController.text = profile?.city ?? '';
          _countryController.text = profile?.country ?? '';
          _profileImageUrl = profile?.image;
          _coverImageUrl = profile?.coverImage;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching profile: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    try {
      RegistrationEntity updatedProfile = RegistrationEntity(
        regId: widget.userId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        city: _cityController.text,
        country: _countryController.text,
        image: _profileImageUrl,
        coverImage: _coverImageUrl,
      );

      await RegistrationEntity.doc(userId: widget.userId).set(
        updatedProfile,
        SetOptions(merge: true),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update profile")),
      );
    }
  }

  Future<void> _pickImage(bool isProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);
      String imageUrl = await _uploadImage(imageFile, isProfile);
      setState(() {
        if (isProfile) {
          _profileImageUrl = imageUrl;
        } else {
          _coverImageUrl = imageUrl;
        }
      });
    }
  }

  Future<String> _uploadImage(File imageFile, bool isProfile) async {
    String fileName = "${widget.userId}_${isProfile ? 'profile' : 'cover'}.jpg";
    Reference storageRef = FirebaseStorage.instance.ref().child("users/$fileName");

    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _updateProfile,
            child: const Text(
              "Save",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7E57C2),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(false),
                        child: Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: _coverImageUrl != null
                                  ? NetworkImage(_coverImageUrl!)
                                  : const AssetImage(companyProfileBackgroundImage) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.camera_alt_rounded, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => _pickImage(true),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : const AssetImage("assets/default_profile.png") as ImageProvider,
                            child: _profileImageUrl == null
                                ? const Icon(Icons.camera_alt_rounded, color: Colors.black)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const CustomText(
                          text: "Personal Details",
                          fontFamily: "Gilroy-Bold",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 16),
                        EditProfileTextField(
                          controller: _firstNameController,
                          label: "First Name",
                          maxLines: 1,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        EditProfileTextField(
                          controller: _lastNameController,
                          label: "Last Name",
                          maxLines: 1,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        EditProfileTextField(
                          controller: _emailController,
                          label: "Email",
                          maxLines: 1,
                          isBold: false,
                        ),
                        const SizedBox(height: 16),
                        EditProfileTextField(
                          controller: _cityController,
                          label: "City",
                          maxLines: 1,
                          isBold: true,
                        ),
                        const SizedBox(height: 16),
                        EditProfileTextField(
                          controller: _countryController,
                          label: "Country",
                          maxLines: 1,
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
class EditProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isBold;
  final int maxLines;

  const EditProfileTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isBold = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: controller,
                maxLines: maxLines,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

