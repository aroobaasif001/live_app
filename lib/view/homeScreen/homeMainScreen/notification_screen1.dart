import 'package:flutter/material.dart';

class NotificationScreen1 extends StatelessWidget {
  const NotificationScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Notifications Found')
          ],
        ),
      ),
    );
  }
}