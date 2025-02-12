import 'package:flutter/material.dart';

import '../../custom_widgets/custom_text.dart';

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
        title: const CustomText(
          text: 'Settings',
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
            'Country of Residence',
            'Your country of residence affects trade show and product recommendations. Your address may determine whether your product is shipped to you.',
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
            'Direct messages',
            'Enable this feature if you want to receive direct messages from other users.',
            directMessages,
                (val) {
              setState(() => directMessages = val);
            },
          ),
          buildCustomSwitchTile(
            'Receive gifts',
            'Enable this option if you want other Grab! users to be able to see you buying gifts.',
            receiveGifts,
                (val) {
              setState(() => receiveGifts = val);
            },
          ),
          buildCustomSwitchTile(
            'Display status in Rewards Club',
            'Let other shoppers see your reward badge live and send congratulatory messages in chat.',
            displayRewardsStatus,
                (val) {
              setState(() => displayRewardsStatus = val);
            },
          ),
          buildCustomSwitchTile(
            'Activity status',
            'Turn on if you want to share your actions with friends.',
            activityStatus,
                (val) {
              setState(() => activityStatus = val);
            },
          ),
          buildCustomSwitchTile(
            'Suggest you to other users',
            'Hewlot will suggest your account to your contacts. It will be activated as soon as you add a phone number or sync your contacts.',
            suggestToOthers,
                (val) {
              setState(() => suggestToOthers = val);
            },
          ),
          settingsSection(
            'Account Management',
            '',
            child: ListTile(
              title: const CustomText(
                text: 'Delete account',
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
