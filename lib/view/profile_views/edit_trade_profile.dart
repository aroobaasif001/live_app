import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import '../../utils/images_path.dart';

class EditTradeProfile extends StatefulWidget {
  const EditTradeProfile({super.key});

  @override
  State<EditTradeProfile> createState() => _EditTradeProfileState();
}

class _EditTradeProfileState extends State<EditTradeProfile> {
  final TextEditingController _nameController =
      TextEditingController(text: "Ivan Ivanov");
  final TextEditingController _nicknameController =
      TextEditingController(text: "usernickname");
  final TextEditingController _aboutController = TextEditingController();

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
          "Edit profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Ready button action
            },
            child: const Text(
              "Ready",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF7E57C2), // Purple color
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(companyProfileBackgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      width: 75,
                      height: 75,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  CustomText(
                    text: "Personal Details",
                    fontFamily: "Gilroy-Bold",
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  EditTradeProfileCustomTextFormField(
                    controller: _nameController,
                    label: "Name",
                    maxLines: 1,
                    isBold: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  EditTradeProfileCustomTextFormField(
                    controller: _nameController,
                    label: "Nickname",
                    maxLines: 1,
                    isBold: true,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  EditTradeProfileCustomTextFormField(
                    controller: _nameController,
                    label: "About me",
                    maxLines: 2,
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

class EditTradeProfileCustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isBold;
  final int maxLines;

  const EditTradeProfileCustomTextFormField({
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
        color: Color(0xFFFFFFFF), // White background
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Light shadow
            spreadRadius: 2, // Spread of the shadow
            blurRadius: 10, // Blur effect
            offset: Offset(0, 4), // Moves shadow downwards
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
