
import 'package:flutter/material.dart';

Widget buildAuctionCard(Map<String, dynamic> auction) {
    Color statusColor = Colors.transparent;
    String statusText = "";

  

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
