import 'package:flutter/material.dart';
import 'package:live_app/utils/colors.dart';
import 'package:live_app/utils/images_path.dart';

import '../../../custom_widgets/custom_text.dart';
import '../../../utils/icons_path.dart';
import 'widget/new_message_bottom_sheet.dart';

class MessagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(applegImage),
            title: CustomText(
              text: "company_name",
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy-Bold',
              fontSize: 16,
            ),
            subtitle: CustomText(
                text: "Message text here",
                fontWeight: FontWeight.w400,
                fontFamily: 'Gilroy-Bold',
                fontSize: 16,
                color: textColor),
            trailing: CustomText(
              text: "4 d.",
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilroy-Bold',
              fontSize: 16,
              color: textColor,
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: primaryGradientColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            showNewMessageBottomSheet(context);
          },
          icon: Image.asset(penIcon),
          label: Text("Write", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  void showNewMessageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return NewMessageBottomSheet();
      },
    );
  }
}
