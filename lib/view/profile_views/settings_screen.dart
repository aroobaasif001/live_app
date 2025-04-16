import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_picker/country_picker.dart';

import '../../custom_widgets/custom_text.dart';
import '../../translate/translations_app.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Create a default Country for Russia by providing all required parameters.
  // Please adjust the parameters (like example phone number) as needed.
  Country selectedCountry = Country(
    countryCode: 'RU',
    phoneCode: '7',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Russia',
    example: '9123456789',
    displayName: 'Russia',
    displayNameNoCountryCode: 'Russia',
    e164Key: '7',
  );

  bool directMessages = true;
  bool receiveGifts = true;
  bool displayRewardsStatus = true;
  bool activityStatus = true;
  bool suggestToOthers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CustomText(
          text: 'settings'.tr,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: "Gilroy-Bold",
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          settingsSection(
            'country_of_residence'.tr,
            'country_description'.tr,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                // Display the flag using the computed getter flagEmoji.
                leading: Text(
                  selectedCountry.flagEmoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: CustomText(
                  text: selectedCountry.name,
                  fontSize: 16,
                  fontFamily: "Gilroy-Bold",
                ),
                onTap: _selectCountry,
              ),
            ),
          ),
          buildCustomSwitchTile(
            'direct_messages'.tr,
            'direct_messages_description'.tr,
            directMessages,
                (val) {
              setState(() => directMessages = val);
            },
          ),
          buildCustomSwitchTile(
            'receive_gifts'.tr,
            'receive_gifts_description'.tr,
            receiveGifts,
                (val) {
              setState(() => receiveGifts = val);
            },
          ),
          buildCustomSwitchTile(
            'display_rewards_status'.tr,
            'display_rewards_status_description'.tr,
            displayRewardsStatus,
                (val) {
              setState(() => displayRewardsStatus = val);
            },
          ),
          buildCustomSwitchTile(
            'activity_status'.tr,
            'activity_status_description'.tr,
            activityStatus,
                (val) {
              setState(() => activityStatus = val);
            },
          ),
          buildCustomSwitchTile(
            'suggest_to_others'.tr,
            'suggest_to_others_description'.tr,
            suggestToOthers,
                (val) {
              setState(() => suggestToOthers = val);
            },
          ),
          settingsSection(
            'account_management'.tr,
            '',
            child: ListTile(
              title: CustomText(
                text: 'delete_account'.tr,
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: "Gilroy-Bold",
              ),
              leading: const Icon(Icons.delete, color: Colors.red),
              onTap: () {
                // Show a GetX snackbar informing account deletion was successful.
                Get.snackbar(
                  'Success'.tr,
                  'Account Deleted Successfully'.tr,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 3),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to create a settings section.
  Widget settingsSection(String title, String description, {Widget? child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy-Bold",
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 5),
              CustomText(
                text: description,
                fontSize: 14,
                color: Colors.grey,
                fontFamily: "Gilroy-Bold",
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: 10),
              child,
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget to build a custom switch tile.
  Widget buildCustomSwitchTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.grey.shade200),
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 5,
          //   )
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Gilroy-Bold",
                  ),
                  const SizedBox(height: 5),
                  CustomText(
                    text: subtitle,
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: "Gilroy-Bold",
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              activeColor: Colors.green,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  // Modified method to use the country_picker package for selecting a country.
  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          selectedCountry = country;
        });
      },
      // Optional: customize the country list theme.
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}








///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../custom_widgets/custom_text.dart';
// import '../../translate/translations_app.dart';
//
// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool directMessages = true;
//   bool receiveGifts = true;
//   bool displayRewardsStatus = true;
//   bool activityStatus = true;
//   bool suggestToOthers = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: CustomText(
//           text: 'settings'.tr,
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//           fontFamily: "Gilroy-Bold",
//         ),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           settingsSection(
//             'country_of_residence'.tr,
//             'country_description'.tr,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 title: const CustomText(
//                   text: 'Russia',
//                   fontSize: 16,
//                   fontFamily: "Gilroy-Bold",
//                 ),
//                 leading: const Icon(Icons.flag),
//               ),
//             ),
//           ),
//           buildCustomSwitchTile(
//             'direct_messages'.tr,
//             'direct_messages_description'.tr,
//             directMessages,
//                 (val) {
//               setState(() => directMessages = val);
//             },
//           ),
//           buildCustomSwitchTile(
//             'receive_gifts'.tr,
//             'receive_gifts_description'.tr,
//             receiveGifts,
//                 (val) {
//               setState(() => receiveGifts = val);
//             },
//           ),
//           buildCustomSwitchTile(
//             'display_rewards_status'.tr,
//             'display_rewards_status_description'.tr,
//             displayRewardsStatus,
//                 (val) {
//               setState(() => displayRewardsStatus = val);
//             },
//           ),
//           buildCustomSwitchTile(
//             'activity_status'.tr,
//             'activity_status_description'.tr,
//             activityStatus,
//                 (val) {
//               setState(() => activityStatus = val);
//             },
//           ),
//           buildCustomSwitchTile(
//             'suggest_to_others'.tr,
//             'suggest_to_others_description'.tr,
//             suggestToOthers,
//                 (val) {
//               setState(() => suggestToOthers = val);
//             },
//           ),
//           settingsSection(
//             'account_management'.tr,
//             '',
//             child: ListTile(
//               title: CustomText(
//                 text: 'delete_account'.tr,
//                 fontSize: 16,
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: "Gilroy-Bold",
//               ),
//               leading: const Icon(Icons.delete, color: Colors.red),
//               onTap: () {
//                 // Implement delete action
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget settingsSection(String title, String description, {Widget? child}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomText(
//               text: title,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               fontFamily: "Gilroy-Bold",
//             ),
//             if (description.isNotEmpty) ...[
//               const SizedBox(height: 5),
//               CustomText(
//                 text: description,
//                 fontSize: 14,
//                 color: Colors.grey,
//                 fontFamily: "Gilroy-Bold",
//               ),
//             ],
//             if (child != null) ...[
//               const SizedBox(height: 10),
//               child,
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildCustomSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(24),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//             )
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     text: title,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Gilroy-Bold",
//                   ),
//                   const SizedBox(height: 5),
//                   CustomText(
//                     text: subtitle,
//                     fontSize: 14,
//                     color: Colors.grey,
//                     fontFamily: "Gilroy-Bold",
//                   ),
//                 ],
//               ),
//             ),
//             Switch(
//               value: value,
//               activeColor: Colors.green,
//               onChanged: onChanged,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
