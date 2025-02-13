import 'package:flutter/material.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';

import '../../../custom_widgets/custom_text.dart';
import 'message_list_screen.dart';
import 'widget/new_message_bottom_sheet.dart';
import 'feature_activity_screen.dart';
import 'purchase_activity_screen.dart';
import 'rates_activity_search_screen.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text:"Activity", color: Colors.black,fontFamily: 'SF Pro Rounded',fontSize: 24,fontWeight: FontWeight.w500,),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
         Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1,
             color: Color(0xffCACACA)
            ),
           
          ),
          child: 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: Row(
            
              children: [
               Image.asset(findfriendsIcon,height: 18,),
              SizedBox(width: 10,),
                CustomText(text:'Find Friends')
              ],
            ),
          ),
         )
        ],
     bottom: TabBar(
  controller: _tabController,
  labelColor: Colors.black,
  unselectedLabelColor: Colors.grey,
  indicatorColor: Colors.black,
  tabs: [
    Tab(child: CustomText(text: "Purchases",fontSize: 12,  fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',)),
    Tab(child: CustomText(text:"Rates", fontSize: 12, fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',)),
    Tab(child: CustomText(text:"Messages", fontSize: 12,fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',)),
    Tab(child: CustomText(text:"Featured",fontSize: 12,  fontWeight: FontWeight.w400,fontFamily: 'Gilroy-Bold',)),
  ],
),

      ),
      body: TabBarView(
        controller: _tabController,
        children: [
      PurchaseActivityScreen(),
         RatesActivitySearchScreen(),
          MessagesList(),
          FeatureActivityScreen()
        ],
      ),
 
   
    );
  }
  }

