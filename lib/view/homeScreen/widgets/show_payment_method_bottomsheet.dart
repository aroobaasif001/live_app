import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../custom_widgets/custom_text.dart';
import '../../../custom_widgets/custom_gradient_button.dart';
import '../homeMainScreen/liveShoppingScreens/supportSellerScreen/supportFavouriteSellerScreen/support_favourite_seller_screen.dart';

void showPaymentMethodBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          int selectedMethod = 0;
          final List<Map<String, dynamic>> paymentMethods = [
            {"icon": 'assets/icons/card.png', "name": "MIR **2882"},
            {"icon": 'assets/icons/sbp.png', "name": "SBP"},
            {"icon": 'assets/icons/card.png', "name": "New map"},
          ];
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Spacer(),
                          CustomText(
                            text: 'Payment method',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy-Bold',
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: paymentMethods.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.asset(paymentMethods[index]['icon'], height: 40, width: 40),
                          title: Text(paymentMethods[index]['name']),
                          trailing: Radio<int>(
                            value: index,
                            groupValue: selectedMethod,
                            onChanged: (value) {
                              setState(() {
                                selectedMethod = value!;
                              });
                            },
                            activeColor: Colors.purple,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomGradientButton(
                        text: 'Continue',
                        onPressed: () {
                          Navigator.pop(context);
                          Get.to(()=>SupportFavouriteSellerScreen());
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          );
        },
      );
    },
  );
}
