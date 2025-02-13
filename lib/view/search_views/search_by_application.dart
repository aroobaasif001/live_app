import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/custom_gradient_button.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/icons_path.dart';

class SearchByApplication extends StatefulWidget {
  const SearchByApplication({super.key});

  @override
  State<SearchByApplication> createState() => _SearchByApplicationState();
}

class _SearchByApplicationState extends State<SearchByApplication> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CustomText(
                      text: "Cancel",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: "Gilroy-Bold",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ButtonsTabBar(
                  unselectedBackgroundColor: Colors.white,
                  borderWidth: 0,
                  unselectedBorderColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  tabs: [
                    Tab(text: "Suggest"),
                    Tab(text: "Save"),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Your previous searches",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: "Gilroy-Bold",
                    ),
                    CustomText(
                      text: "Clear",
                      color: Color(0xff815BFF),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: "Gilroy-Bold",
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 115,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Electronic"),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.close,color: Colors.black,size: 15,),
                            ],
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 35,
                      width: 115,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Iphone"),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.close,color: Colors.black,size: 15,),
                        ],
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CustomText(
                  text: "Previously viewed users",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: "Gilroy-Bold",
                ),
                const SizedBox(height: 15),
                _userListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userListView() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: 6,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      appleIcon,
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'company_name',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Gilroy-Bold",
                        ),
                        CustomText(
                            color: Color(0xff8C8C8C),
                            fontSize: 14,
                            fontFamily: "Gilroy-Bold",
                            text: '2.4K Subscribers',
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
