import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Name Awards Club"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Image.asset('assets/images/appleg.png',height: 94,),
                  SizedBox(height: 10),
                  CustomText(text: 'Company Name', fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'SF Pro Rounded',
                      color: Color(0xff2A2A2A),),
                   CustomText(text: 'Awards Club', fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Rounded',
                      color: Color(0xff2A2A2A),),
                 
                  SizedBox(height: 10),
                    CustomText(text: 'Subscribe, watch and shop to receive rewards from company_name', fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Gilroy-Bold',
                      textAlign: TextAlign.center,
                      color: Color(0xff2A2A2A),),
                       SizedBox(height: 10),
                    CustomText(text: 'Rewards and progress are reset at the beginning of each season. See more', fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Gilroy-Bold',
                      textAlign: TextAlign.center,
                      color: Color(0xff2A2A2A),),
                ],
              ),
            ),
            _buildLevelCard("Bronze", Colors.brown, "20% off on exclusive offers in the store"),
            _buildLevelCard("Silver", Colors.grey, "30% off on special products"),
            _buildLevelCard("Gold", Colors.amber, "40% off on premium products"),
            _buildLevelCard("Platinum", Colors.blueGrey, "50% off on luxury products"),
            _buildLevelCard("Diamond", Colors.blue, "60% off on all store items"),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(String level, Color color, String benefit) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Level $level",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 5),
            Text(
              benefit,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
