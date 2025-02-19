import 'package:flutter/material.dart';
import 'package:live_app/utils/images_path.dart';

import '../../../custom_widgets/custom_text.dart';
import '../../../utils/icons_path.dart';

class LiveVideoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/icons/apple1.png'),
              SizedBox(width: 10,),
              CustomText(text:'company_name',fontFamily: 'Gilroy-Bold',fontWeight: FontWeight.w400,)
            ],
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: Image.asset(
                 liveImage,
                  width: double.infinity,
                fit: BoxFit.contain,
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text("Live • 86",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  children: [
                    Icon(Icons.bookmark,color: Colors.white,),
                  
                    SizedBox(width: 4),
                    Text("161",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Row(
                  
                  children: [
                     Image.asset(flagIcon, height: 16, width: 16),
                    Flexible(
                      child: CustomText(text: 
                        "Lorem ipsum dolor sit amet consectetur adipiscing ",
                       fontSize: 12, color: Color(0xff2a2a2a),
                       fontFamily: 'Gilroy-Bold',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomText(text:'Lorem ipsum ',color: Color(0xff3438B7),),
                    Flexible(child: CustomText(text: 'Lorem ipsum ',color: Colors.grey,maxLines: 1,),)
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

