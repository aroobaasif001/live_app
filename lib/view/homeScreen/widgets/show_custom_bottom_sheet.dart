import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';

void showCustomBottomSheet(BuildContext context,
    {required String companyName,
    required double rating,
    required IconData profileIcon,
    required List<Map<String, dynamic>> actions}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(profileIcon, color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(companyName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.black, size: 16),
                          SizedBox(width: 5),
                          Text(rating.toString(),
                              style: TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 30,
                  
                  child: CustomGradientButton(text: 'Subscribe', onPressed: (){},fontSize: 12,))
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                //     backgroundColor: Colors.blue,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                //   child: Text("Subscribe", style: TextStyle(color: Colors.white)),
                // ),
              ],
            ),
            SizedBox(height: 20),

            Divider(),

            // Action List
            ...actions.map((action) {
              return _buildMenuItem(action["icon"], action["text"]);
            }).toList(),

            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}

// Menu Items with Icons
Widget _buildMenuItem(String icon, String text) {
  return ListTile(
    leading: Image.asset(icon),
    title: Text(text, style: TextStyle(fontSize: 16)),
    onTap: () {
      // Handle menu item tap
    },
  );
}