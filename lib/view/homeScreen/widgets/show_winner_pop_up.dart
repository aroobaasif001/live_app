import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'show_custom_bottom_sheet.dart';

void showWinnerPopup(BuildContext context, String winnerName) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, 
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7), 
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selecting the Winner", 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: (){
                  showSubscribeBottomSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      winnerName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}
