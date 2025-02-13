import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/utils/images_path.dart';
import '../../../custom_widgets/custom_gradiant_tab_button.dart';

class RatesActivitySearchScreen extends StatefulWidget {
  @override
  _RatesActivitySearchScreenState createState() => _RatesActivitySearchScreenState();
}

class _RatesActivitySearchScreenState extends State<RatesActivitySearchScreen> {
  RxInt selectedCategoryIndex = 0.obs;

  final List<String> categories = ["All", "You are in the lead", "The bid has been outbid"];

  final List<Map<String, dynamic>> auctions = [
    {
      "image": marketImage,
      "status": "outbid",
      "product": "iPhone 13",
      "description": "Latest iPhone model",
      "price": "1,000 ₽",
      "company": "Apple Store",
      "rating": "4.9"
    },
    {
      "image": marketImage,
      "status": "lead",
      "product": "T-Shirt",
      "description": "Cotton, size M",
      "price": "500 ₽",
      "company": "Clothing Hub",
      "rating": "4.7"
    },
  ];

  final List<Map<String, dynamic>> completedAuctions = [
    {
      "image": marketImage,
      "status": "win",
      "product": "MacBook Air",
      "description": "M2 Chip, 512GB SSD",
      "price": "1,500 ₽",
      "company": "Apple Store",
      "rating": "5.0"
    },
    {
      "image": marketImage,
      "status": "lost",
      "product": "Netflix Premium",
      "description": "1 Year Subscription",
      "price": "900 ₽",
      "company": "Netflix Inc.",
      "rating": "4.8"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            _buildCategoryTabs(),
            SizedBox(height: 12),
            Expanded(
              child: Obx(() => SingleChildScrollView(
                    child: Column(
                      children: [
                        ..._getFilteredAuctions().map((item) => _buildAuctionCard(item)).toList(),
                        SizedBox(height: 16),
                        Text(
                          "Recently Completed Auctions",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        ..._getFilteredCompletedAuctions().map((item) => _buildAuctionCard(item)).toList(),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categories.length, (index) {
            return Obx(() => Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CustomGradiantTabButton(
                    text: categories[index],
                    isSelected: selectedCategoryIndex.value == index,
                    onPressed: () => selectedCategoryIndex.value = index,
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Widget _buildAuctionCard(Map<String, dynamic> auction) {
    Color statusColor = Colors.transparent;
    String statusText = "";

    switch (auction["status"]) {
      case "outbid":
        statusColor = Colors.red;
        statusText = "The bid has been outbid!";
        break;
      case "lead":
        statusColor = Colors.blue;
        statusText = "You are in the lead!";
        break;
      case "win":
        statusColor = Colors.blue;
        statusText = "You win!";
        break;
      case "lost":
        statusColor = Colors.red;
        statusText = "You lost!";
        break;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                child: Image.asset(auction["image"], width: 100, height: 100, fit: BoxFit.cover),
              ),
              if (statusText.isNotEmpty)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(auction["company"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                       SizedBox(width: 4),
                       Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 4),
                      Text(auction["rating"], style: TextStyle(fontSize: 12)),
                    ],
                  ),
             
                  SizedBox(height: 4),
                  Text(auction["product"], style: TextStyle(fontSize: 14)),
                  Text(auction["description"], style: TextStyle(fontSize: 12, color: Colors.grey)),
                  SizedBox(height: 4),
                  Text(auction["price"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAuctions() {
    String filter = categories[selectedCategoryIndex.value];
    if (filter == "All") return auctions;
    if (filter == "You are in the lead") {
      return auctions.where((item) => item["status"] == "lead").toList();
    }
    if (filter == "The bid has been outbid") {
      return auctions.where((item) => item["status"] == "outbid").toList();
    }
    return auctions;
  }

  List<Map<String, dynamic>> _getFilteredCompletedAuctions() {
    String filter = categories[selectedCategoryIndex.value];
    if (filter == "All") return completedAuctions;
    return completedAuctions; 
  }
}
