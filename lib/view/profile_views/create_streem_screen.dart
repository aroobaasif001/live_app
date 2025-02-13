import 'package:flutter/material.dart';

class CreateStreamScreen extends StatefulWidget {
  const CreateStreamScreen({super.key});

  @override
  State<CreateStreamScreen> createState() => _CreateStreamScreenState();
}

class _CreateStreamScreenState extends State<CreateStreamScreen> {
  DateTime? selectedDate;
  String repetition = "Do not repeat";
  String category = "Do not repeat";
  bool freePickup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create a stream",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Stream name"),
              const SizedBox(height: 12),
              _buildDatePicker(),
              const SizedBox(height: 12),
              _buildTextField("Description", maxLines: 3),
              const SizedBox(height: 12),
              _buildDropdownField("Repetitions*", repetition,
                  ["Do not repeat", "Every week", "Every month"], (value) {
                setState(() {
                  repetition = value!;
                });
              }),
              const SizedBox(height: 16),
              _buildSectionTitle("Media",
                  "Add a thumbnail and preview of your video to highlight what's missing from your show."),
              const SizedBox(height: 8),
              _buildMediaUploadRow(),
              const SizedBox(height: 16),
              _buildSectionTitle("Main Category",
                  "Accurately defining the category of your \nshow will help increase its recognition."),
              const SizedBox(height: 16),
              _buildDropdownField("Main category", category, [
                "Do not repeat",
                "Electronics",
                "Fashion",
                "Home & Garden"
              ], (value) {
                setState(() {
                  category = value!;
                });
              }),
              const SizedBox(height: 16),
              _buildSectionTitle("Delivery settings",
                  "Change the default settings for shipping, shipping costs, and create delivery for this stream."),
              _buildSwitchTile("Free pickup",
                  "Allow customers to pick up any order", freePickup, (value) {
                setState(() {
                  freePickup = value;
                });
              }),
              const SizedBox(height: 12),
              _buildNavigationTile(
                  "Select logistics companies",
                  "Allow logistic services and asset spectacular selecting of the delivery mode",
                  Icons.arrow_forward_ios),
              const SizedBox(height: 24),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// **📌 Common Text Field**
  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  /// **📌 Date Picker**
  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? "${selectedDate!.day} ${_getMonthName(selectedDate!.month)} ${selectedDate!.year}"
                  : "Select Date",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Icon(Icons.calendar_today_outlined, color: Colors.black),
          ],
        ),
      ),
    );
  }

  /// **📌 Media Upload Row**
  Widget _buildMediaUploadRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMediaUploadBox("Upload photo", Icons.image_outlined),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMediaUploadBox("Upload video", Icons.videocam_outlined),
        ),
      ],
    );
  }

  /// **📌 Dropdown Selector**
  Widget _buildDropdownField(String title, String selectedValue,
      List<String> items, ValueChanged<String?> onChanged) {
    return GestureDetector(
      onTap: () {
        _showDropdownBottomSheet(title, items, onChanged);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(selectedValue,
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            const Icon(Icons.keyboard_arrow_down_outlined),
          ],
        ),
      ),
    );
  }

  /// **📌 Gradient Button (Fixed)**
  Widget _buildGradientButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: Ink(
        height: 50, // Ensures fixed height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(colors: [Colors.blue, Colors.purpleAccent]),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }



  /// **📌 Switch Tile**
  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.black54)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple,
    );
  }

  /// **📌 Section Title**
  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontFamily: "Gilroy-Bold",
                fontWeight: FontWeight.w400)),
      ],
    );
  }
  /// **📌 Regular Button (Fixed)**
  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Center( // Prevents layout errors
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }



  /// **📌 Navigation Tile**
  Widget _buildNavigationTile(String title, String subtitle, IconData icon) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54)),
      trailing: Icon(icon, size: 16, color: Colors.black54),
      onTap: () {},
    );
  }

  /// **📌 Show Dropdown Bottom Sheet**
  void _showDropdownBottomSheet(
      String title, List<String> items, ValueChanged<String?> onChanged) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                    onTap: () {
                      onChanged(items[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
  /// **📌 Bottom Buttons (Fixed)**
  Widget _buildBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 50, // Ensures fixed height
            child: _buildButton("Cancel", Colors.grey[300]!, Colors.black, () {}),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 50, // Ensures fixed height
            child: _buildGradientButton("Create"),
          ),
        ),
      ],
    );
  }


  /// **📌 Media Upload Box**
  Widget _buildMediaUploadBox(String text, IconData icon) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][month - 1];
  }
}
