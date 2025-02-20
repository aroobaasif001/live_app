import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../custom_widgets/custom_text.dart';
import '../../translate/translations_app.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool directMessages = true;
  bool receiveGifts = true;
  bool displayRewardsStatus = true;
  bool activityStatus = true;
  bool suggestToOthers = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                title: const CustomText(
                  text: 'Russia',
                  fontSize: 16,
                  fontFamily: "Gilroy-Bold",
                ),
                leading: const Icon(Icons.flag),
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
                // Implement delete action
              },
            ),
          ),
        ],
      ),
    );
  }

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

  Widget buildCustomSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
}
