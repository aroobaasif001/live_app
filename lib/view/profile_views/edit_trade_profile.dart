import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_app/view/profile_views/trade_profile_screen.dart';
import '../../entities/registration_entity.dart';
import '../../utils/images_path.dart';
import '../../custom_widgets/custom_text.dart';
import '../../translate/translations_app.dart';

class EditTradeProfile extends StatefulWidget {
  final String userId;

  const EditTradeProfile({super.key, required this.userId});

  @override
  State<EditTradeProfile> createState() => _EditTradeProfileState();
}

class _EditTradeProfileState extends State<EditTradeProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController  = TextEditingController();
  final TextEditingController _emailController     = TextEditingController();
  final TextEditingController _cityController      = TextEditingController();
  final TextEditingController _countryController   = TextEditingController();

  bool _isLoading = true;
  String? _profileImageUrl;
  String? _coverImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Loads profile details from Firestore
  Future<void> _loadProfile() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("UserEntity")
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _firstNameController.text = snapshot.get("firstName") ?? '';
          _lastNameController.text  = snapshot.get("lastName") ?? '';
          _emailController.text     = snapshot.get("email") ?? '';
          _cityController.text      = snapshot.get("city") ?? '';
          _countryController.text   = snapshot.get("country") ?? '';
          _profileImageUrl          = snapshot.get("image") ?? "";
          _coverImageUrl            = snapshot.get("coverImage") ?? "";
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; });
      }
    } catch (e) {
      print("error_fetching".tr.replaceAll("{0}", e.toString()));
      setState(() { _isLoading = false; });
    }
  }

  /// Updates the profile data in Firestore
  Future<void> _updateProfile() async {
    try {
      await RegistrationEntity.doc(userId: widget.userId).update({
        "firstName": _firstNameController.text,
        "lastName":  _lastNameController.text,
        "email":     _emailController.text,
        "city":      _cityController.text,
        "country":   _countryController.text,
        "image":     _profileImageUrl ?? "",
        "coverImage":_coverImageUrl ?? "",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("profile_updated".tr)),
      );
      Get.back();
    } catch (e) {
      print("error_updating".tr.replaceAll("{0}", e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("update_failed".tr)),
      );
    }
  }

  /// Picks an image from the gallery and uploads it to Firebase Storage
  Future<void> _pickImage(bool isProfile) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      // Upload image and get URL
      String imageUrl = await _uploadImage(imageFile, isProfile);

      setState(() {
        if (isProfile) {
          _profileImageUrl = imageUrl;
        } else {
          _coverImageUrl = imageUrl;
        }
      });

      print("Uploaded image URL: $imageUrl");

      // Optionally update Firestore immediately
      try {
        await FirebaseFirestore.instance
            .collection("UserEntity")
            .doc(widget.userId)
            .update({
          isProfile ? "image" : "coverImage": imageUrl,
        });
        print(isProfile ? "Profile image updated" : "Cover image updated");
      } catch (e) {
        print("Error updating Firestore: $e");
      }
    } else {
      print("No image selected");
    }
  }

  /// Uploads the image file to Firebase Storage and returns its URL
  Future<String> _uploadImage(File imageFile, bool isProfile) async {
    try {
      String fileName =
          "${widget.userId}_${isProfile ? 'profile' : 'cover'}.jpg";
      Reference storageRef =
      FirebaseStorage.instance.ref().child("users/$fileName");

      TaskSnapshot taskSnapshot = await storageRef.putFile(imageFile);

      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image");
    }
  }

  /// Returns the cover image widget while preserving the previous UI look.
  /// If no cover image URL is set, display a grey background with a centered photo icon.
  Widget _buildCoverImage() {
    if (_coverImageUrl != null && _coverImageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => _pickImage(false),
        child: Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_coverImageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _pickImage(false),
        child: Container(
          height: 220,
          width: double.infinity,
          color: Colors.grey[300],
          child: Center(
            child: Icon(
              Icons.photo,
              size: 50,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }
  }

  /// Returns the profile image widget while preserving the previous UI look.
  /// If no profile image URL is set, display a rounded icon instead.
  Widget _buildProfileImage() {
    if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(_profileImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: 40,
          color: Colors.grey[700],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "edit_profile_title".tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _updateProfile,
            child: Text(
              "save".tr,
              style: const TextStyle(
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
          children: [
            Stack(
              children: [
                _buildCoverImage(),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: _buildProfileImage(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CustomText(
                      text: "personal_details".tr,
                      fontFamily: "Gilroy-Bold",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  EditProfileTextField(
                    controller: _firstNameController,
                    label: "first_name".tr,
                    maxLines: 1,
                    isBold: true,
                  ),
                  const SizedBox(height: 16),
                  EditProfileTextField(
                    controller: _lastNameController,
                    label: "last_name".tr,
                    maxLines: 1,
                    isBold: true,
                  ),
                  const SizedBox(height: 16),
                  EditProfileTextField(
                    controller: _emailController,
                    label: "email".tr,
                    maxLines: 1,
                    isBold: false,
                  ),
                  const SizedBox(height: 16),
                  EditProfileTextField(
                    controller: _cityController,
                    label: "city".tr,
                    maxLines: 1,
                    isBold: false,
                  ),
                  const SizedBox(height: 16),
                  EditProfileTextField(
                    controller: _countryController,
                    label: "country".tr,
                    maxLines: 1,
                    isBold: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// A custom text field widget used in the edit profile screen.
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
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
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}



///

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:live_app/view/profile_views/trade_profile_screen.dart';
// import '../../entities/registration_entity.dart';
// import '../../utils/images_path.dart';
// import '../../custom_widgets/custom_text.dart';
// import '../../translate/translations_app.dart';
//
// class EditTradeProfile extends StatefulWidget {
//   final String userId;
//
//   const EditTradeProfile({super.key, required this.userId});
//
//   @override
//   State<EditTradeProfile> createState() => _EditTradeProfileState();
// }
//
// class _EditTradeProfileState extends State<EditTradeProfile> {
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//
//   bool _isLoading = true;
//   String? _profileImageUrl;
//   String? _coverImageUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }
//
//   Future<void> _loadProfile() async {
//     try {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection("UserEntity")
//           .doc(widget.userId)
//           .get();
//
//       if (snapshot.exists) {
//         setState(() {
//           _firstNameController.text = snapshot.get("firstName") ?? '';
//           _lastNameController.text = snapshot.get("lastName") ?? '';
//           _emailController.text = snapshot.get("email") ?? '';
//           _cityController.text = snapshot.get("city") ?? '';
//           _countryController.text = snapshot.get("country") ?? '';
//           _profileImageUrl = snapshot.get("image") ?? null;
//           _coverImageUrl = snapshot.get("coverImage") ?? null;
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("error_fetching".tr.replaceAll("{0}", e.toString()));
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     try {
//       await RegistrationEntity.doc(userId: widget.userId).update({
//           "firstName": _firstNameController.text,
//           "lastName": _lastNameController.text,
//           "email": _emailController.text,
//           "city": _cityController.text,
//           "country": _countryController.text,
//           "image": _profileImageUrl ?? "",
//           "coverImage": _coverImageUrl ?? "",
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("profile_updated".tr)),
//       );
//       Get.off(() => TradeProfileScreen(userId: widget.userId));
//     } catch (e) {
//       print("error_updating".tr.replaceAll("{0}", e.toString()));
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("update_failed".tr)),
//       );
//     }
//   }
//
//   Future<void> _pickImage(bool isProfile) async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedImage != null) {
//       File imageFile = File(pickedImage.path);
//
//       // Upload image and get URL
//       String imageUrl = await _uploadImage(imageFile, isProfile);
//
//       setState(() {
//         if (isProfile) {
//           _profileImageUrl = imageUrl;
//         } else {
//           _coverImageUrl = imageUrl;
//         }
//       });
//
//       // Log the image URL and Firestore update logic for debugging
//       print("Uploaded image URL: $imageUrl");
//
//       // Update Firestore with the image URL for profile or cover image
//       try {
//         await FirebaseFirestore.instance
//             .collection("UserEntity")
//             .doc(widget.userId)
//             .update({
//           isProfile ? "image" : "coverImage": imageUrl,
//         });
//         print(isProfile ? "Profile image updated" : "Cover image updated");
//       } catch (e) {
//         print("Error updating Firestore: $e");
//       }
//     } else {
//       print("No image selected");
//     }
//   }
//
//
//
//   Future<String> _uploadImage(File imageFile, bool isProfile) async {
//     try {
//       String fileName = "${widget.userId}_${isProfile ? 'profile' : 'cover'}.jpg";
//       Reference storageRef = FirebaseStorage.instance.ref().child("users/$fileName");
//
//       // Upload the image to Firebase Storage
//       TaskSnapshot taskSnapshot = await storageRef.putFile(imageFile);
//
//       // Get the URL after upload completion
//       String imageUrl = await taskSnapshot.ref.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       print("Error uploading image: $e");
//       throw Exception("Error uploading image");
//     }
//   }
//
//
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
//         title: Text(
//           "edit_profile_title".tr,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           TextButton(
//             onPressed: _updateProfile,
//             child: Text(
//               "save".tr,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF7E57C2),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     children: [
//                       GestureDetector(
//                         onTap: () => _pickImage(false),
//                         child: Container(
//                           height: 220,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: _coverImageUrl != null
//                                   ? NetworkImage(_coverImageUrl!)
//                                   : const AssetImage(
//                                           companyProfileBackgroundImage)
//                                       as ImageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: const Center(
//                             child: Icon(Icons.camera_alt_rounded,
//                                 color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 10,
//                         left: 20,
//                         child: GestureDetector(
//                           onTap: () => _pickImage(true),
//                           child: CircleAvatar(
//                             radius: 40,
//                             backgroundColor: Colors.white,
//                             backgroundImage: _profileImageUrl != null
//                                 ? NetworkImage(_profileImageUrl!)
//                                 : const AssetImage("assets/default_profile.png")
//                                     as ImageProvider,
//                             child: _profileImageUrl == null
//                                 ? const Icon(Icons.camera_alt_rounded,
//                                     color: Colors.black)
//                                 : null,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       children: [
//                         CustomText(
//                           text: "personal_details".tr,
//                           fontFamily: "Gilroy-Bold",
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         const SizedBox(height: 16),
//                         EditProfileTextField(
//                             controller: _firstNameController,
//                             label: "first_name".tr,
//                             maxLines: 1,
//                             isBold: true),
//                         const SizedBox(height: 16),
//                         EditProfileTextField(
//                             controller: _lastNameController,
//                             label: "last_name".tr,
//                             maxLines: 1,
//                             isBold: true),
//                         const SizedBox(height: 16),
//                         EditProfileTextField(
//                             controller: _emailController,
//                             label: "email".tr,
//                             maxLines: 1,
//                             isBold: false),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
//
// class EditProfileTextField extends StatelessWidget {
//   final String label;
//   final TextEditingController controller;
//   final bool isBold;
//   final int maxLines;
//
//   const EditProfileTextField({
//     super.key,
//     required this.label,
//     required this.controller,
//     this.isBold = false,
//     this.maxLines = 1,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: const Offset(0, 4),
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
