import 'package:flutter/material.dart';

class LiveVideoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
              Text('company_name',style: TextStyle(fontFamily: 'SFProRounded',fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                child: Image.asset(
                  "assets/images/live.png",
                  width: double.infinity,
                fit: BoxFit.contain,
                ),
              ),

              // Positioned(
              //   top: 8,
              //   left: 8,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Text("Live • 86",
              //         style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              //   ),
              // ),
              // Positioned(
              //   top: 8,
              //   right: 8,
              //   child: Row(
              //     children: [
              //       Icon(Icons.remove_red_eye, size: 14, color: Colors.white),
              //       SizedBox(width: 4),
              //       Text("161",
              //           style: TextStyle(color: Colors.white, fontSize: 12)),
              //     ],
              //   ),
              // ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                Row(
                  
                  children: [
                     Image.asset('assets/icons/flag.png', height: 16, width: 16),
                    Flexible(
                      child: Text(
                        "Lorem ipsum dolor sit amet consectetur adipiscing ",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Lorem ipsum ',style: TextStyle(color: Color(0xff3438B7)),),
                    Flexible(child: Text('Lorem ipsum ',style: TextStyle(color: Colors.grey)))
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
