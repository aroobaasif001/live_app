import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_radio_tile.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/custom_widgets/custom_textfield.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/icons_path.dart';

import '../fetch_goods.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  _ForYouScreenState createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  String selectedOption = "Recommended";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            prefixIcon: Icon(CupertinoIcons.search),
            hintText: 'Search',
          ),
          SizedBox(height: 20),
          // Sort and Category Buttons
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _showTuneBottomSheet(context);
                },
                child: CustomContainer(
                  height: 32,
                  width: 44,
                  image: DecorationImage(image: AssetImage(tuneIcon)),
                ),
              ),
              SizedBox(width: 10),
              CustomContainer(
                height: 32,
                conColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  hint: CustomText(
                    text: 'Sort',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  underline: SizedBox(),
                  items: <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        text: value,
                        fontSize: 14,
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
              SizedBox(width: 10),
              CustomContainer(
                height: 32,
                conColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  hint: CustomText(
                    text: 'Category',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  underline: SizedBox(),
                  items: <String>['Category 1', 'Category 2', 'Category 3'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: CustomText(
                        text: value,
                        fontSize: 14,
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Goods Section
          CustomText(
            text: 'Goods',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GetAllGoods(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTuneBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 30),
                      CustomText(
                        text: "Tune",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      IconButton(
                          onPressed: () {
                        Get.back();
                      }, icon: Icon(Icons.close))
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildListItem(context, "Sort", "Top Sellers"),
                  _buildListItem(context, "Show time"),
                  _buildListItem(context, "Free pickup"),
                  _buildListItem(context, "Display format"),
                  _buildListItem(context, "Label"),
                  _buildListItem(context, "Seller Rating"),
                  _buildListItem(context, "Sent from"),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: CustomContainer(
                            height: 48,
                            borderRadius: BorderRadius.circular(10),
                            conColor: greyButtonColor,
                            alignment: Alignment.center,
                            child: CustomText(text: 'Clear', fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: CustomGradientButton(
                          text: 'View results',
                          onPressed: () {},
                          height: 48,
                          width: 221,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 133,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, String title, [String? subtitle]) {
    return Column(
      children: [
        ListTile(
          title: CustomText(text: title),
          subtitle: subtitle != null
              ? CustomText(text: subtitle, color: Colors.purple, fontWeight: FontWeight.bold)
              : null,
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
          onTap: () {
            if (title == "Sort") {
              _showSortBottomSheet(context);
            }
          },
        ),
        Divider(color: Colors.black12, height: 1),
      ],
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          }, icon: Icon(Icons.arrow_back_ios_outlined)),
                      CustomText(
                        text: "Sort",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gilroy-Bold',
                      ),
                      SizedBox(width: 30)
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomRadioTile(title: "Recommended",selectedOption: selectedOption, onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  }),
                  CustomRadioTile(title: "New and noteworthy",selectedOption: selectedOption, onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  }),
                  CustomRadioTile(title: "Top Sellers",selectedOption: selectedOption, onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  }),
                  CustomRadioTile(title: "Number of views: high first",selectedOption: selectedOption, onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  }),
                  CustomRadioTile(title: "Number of views: low first",selectedOption: selectedOption, onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  }),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: CustomContainer(
                          height: 48,
                          borderRadius: BorderRadius.circular(10),
                          conColor: greyButtonColor,
                          alignment: Alignment.center,
                          child: CustomText(text: 'Clear', fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: CustomGradientButton(
                          text: 'View results',
                          onPressed: () {},
                          height: 48,
                          width: 221,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 133,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}