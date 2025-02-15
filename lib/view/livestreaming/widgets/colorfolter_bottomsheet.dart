import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet {
  static void show(BuildContext context, String channelId) {
    final Map<Color, String> filters = {
      Colors.black: 'black',
      Colors.yellow: 'yellow',
      Colors.red: 'red',
      Colors.green: 'green',
      Colors.blue: 'blue',
    };

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.grey[900],
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "select_filter".tr,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => updateCurrentFilter(null, channelId, context),
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: "remove_filter".tr,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: filters.entries.map((entry) {
                  final color = entry.key;
                  final colorName = entry.value;
                  return GestureDetector(
                    onTap: () => updateCurrentFilter(colorName, channelId, context),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> updateCurrentFilter(
      String? colorName, String channelId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .set({'currentFilter': colorName}, SetOptions(merge: true));
      print("Filter updated to: $colorName");
      Navigator.pop(context); // Close the bottom sheet
    } catch (e) {
      print("Error updating filter: $e");
    }
  }

  static Color parseColorFromString(String colorName) {
    switch (colorName) {
      case 'black':
        return Colors.black;
      case 'yellow':
        return Colors.yellow;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.transparent; // Default or no filter
    }
  }
}
