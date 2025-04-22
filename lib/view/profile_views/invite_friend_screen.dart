import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendScreen extends StatelessWidget {
  final String referralCode = "YASIR123";

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Referral code copied!")),
    );
  }

  void _shareCode(BuildContext context) {
    Share.share(
      "Join this awesome app and get rewards! Use my referral code: $referralCode",
      subject: "Invite to App",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Invite a Friend")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/user group icon.png", height: 100),
            SizedBox(height: 20),
            Text("Share your referral code and get rewards!",
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Code: $referralCode", style: TextStyle(fontSize: 16)),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () => _copyCode(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _shareCode(context),
              icon: Icon(Icons.share),
              label: Text("Share Code"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
