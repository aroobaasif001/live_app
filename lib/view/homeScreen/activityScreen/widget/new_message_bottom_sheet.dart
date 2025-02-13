import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/utils/images_path.dart';
import 'package:live_app/view/homeScreen/activityScreen/chat_screen.dart';

import '../../../../custom_widgets/custom_text.dart';
import '../../../../utils/colors.dart';

class NewMessageBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New message", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(),
        
          Row(
            children: [
              Text("To whom: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Nickname",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
       
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    Get.to(()=>ChatScreen());
                  },
                  leading: Image.asset(applegImage),
                  title: CustomText(text:"company_name", fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',fontSize: 16,),
          subtitle: CustomText(text:"You are Subscribed",fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',fontSize: 16,color: textColor),
          trailing: CustomText(text: "4 d.",fontWeight: FontWeight.w500,fontFamily: 'Gilroy-Bold',fontSize: 16,color: textColor,),
                );
              },
            ),
          ),
  
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Icon(Icons.text_format),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}