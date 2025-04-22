import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for translations
import 'package:live_app/custom_widgets/custom_text.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool streamsFromSubscriptions = true;
  bool streamsISaved = false;
  bool recommendedStreams = true;
  bool newSubscriber = true;
  bool bookmarksFromStreams = true;
  var isAllSelected = false.obs;

  void toggleSelectAll() {
    isAllSelected.value = !isAllSelected.value;
    // aap yahan sab tags ko select ya unselect kar sakte hain
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: CustomText(
            text: 'notifications'.tr,
            // Updated to use translation
            fontSize: 18,
            fontFamily: "Gilroy-Bold",
            fontWeight: FontWeight.bold,
            color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Added pop action
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle('live_stream_notifications'.tr), // Updated to use translation
          buildCustomSwitchTile('streams_from_subscriptions'.tr, streamsFromSubscriptions, (val) {
            setState(() => streamsFromSubscriptions = val);
          }),
          Divider(),
          buildCustomSwitchTile('streams_i_saved'.tr, streamsISaved, (val) {
            setState(() => streamsISaved = val);
          }),
          Divider(),
          buildCustomSwitchTile('recommended_streams'.tr, recommendedStreams, (val) {
            setState(() => recommendedStreams = val);
          }),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CustomText(
              text: 'notification_description'.tr, // Updated to use translation
              color: Colors.grey,
              fontSize: 14,
              fontFamily: "Gilroy-Bold",
            ),
          ),
          sectionTitle('search_notifications'.tr), // Updated to use translation
          ListTile(
            title: CustomText(
              text: 'adding_tags_to_chat'.tr,
              fontFamily: "Gilroy-Bold",
              fontSize: 14,
            ),
            trailing: Obx(() => GestureDetector(
              onTap: () {
                toggleSelectAll();
              },
              child: CustomText(
                text: isAllSelected.value ? 'Unselect'.tr : 'all'.tr,
                fontWeight: FontWeight.bold,
                fontFamily: "Gilroy-Bold",
                fontSize: 14,
              ),
            )),
          ),

          buildCustomSwitchTile('new_subscriber'.tr, newSubscriber, (val) {
            setState(() => newSubscriber = val);
          }),
          sectionTitle('seller_bookmark_notifications'.tr), // Updated to use translation
          buildCustomSwitchTile('bookmarks_from_my_streams'.tr, bookmarksFromStreams, (val) {
            setState(() => bookmarksFromStreams = val);
          }),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CustomText(
              fontFamily: "Gilroy-Bold",
              text: 'bookmark_notification_description'.tr, // Updated to use translation
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: CustomText(
        text: title,
        fontSize: 14,
        fontFamily: "Gilroy-Bold",
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget buildCustomSwitchTile(String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: CustomText(text: title, fontSize: 15, fontFamily: "Gilroy-Bold"),
      trailing: Switch(
        value: value,
        activeColor: Colors.green,
        onChanged: onChanged,
      ),
    );
  }
}
