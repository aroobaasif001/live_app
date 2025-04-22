import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  final List<Map<String, String>> tips = [
    {
      "icon": "assets/images/tips icon.png",
      "text": "Tip 1: Keep your profile updated."
    },
    {
      "icon": "assets/images/tips icon.png",
      "text": "Tip 2: Refer friends to earn bonuses."
    },
    {
      "icon": "assets/images/tips icon.png",
      "text": "Tip 3: Withdraw your balance anytime."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tips")),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: tips.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final tip = tips[index];
          return ListTile(
            leading: Image.asset(tip["icon"]!, height: 30),
            title: Text(tip["text"]!, style: TextStyle(fontSize: 16)),
          );
        },
      ),
    );
  }
}
