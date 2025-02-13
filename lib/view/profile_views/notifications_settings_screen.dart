import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool streamsFromSubscriptions = true;
  bool streamsISaved = false;
  bool recommendedStreams = true;
  bool newSubscriber = true;
  bool bookmarksFromStreams = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
            text: 'Notifications',
            fontSize: 18,
            fontFamily: "Gilroy-Bold",
            fontWeight: FontWeight.bold,
            color: Colors.black),

        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          sectionTitle('LIVE STREAM NOTIFICATIONS'),
          buildCustomSwitchTile(
              'Streams from subscriptions', streamsFromSubscriptions, (val) {
            setState(() => streamsFromSubscriptions = val);
          }),
          buildCustomSwitchTile('Streams I saved', streamsISaved, (val) {
            setState(() => streamsISaved = val);
          }),
          buildCustomSwitchTile('Recommended Streams', recommendedStreams,
              (val) {
            setState(() => recommendedStreams = val);
          }),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: CustomText(
              text:
                  'Choose which streams you\'ll be notified about. Grab It! sends you recommended shows based on your history.',
              color: Colors.grey,
              fontSize: 14,
              fontFamily: "Gilroy-Bold",
            ),
          ),
          sectionTitle('SEARCH NOTIFICATIONS'),
          ListTile(
            title: const CustomText(text: 'Adding tags to chat',  fontFamily: "Gilroy-Bold",),
            trailing:
                const CustomText(text: 'All', fontWeight: FontWeight.bold,  fontFamily: "Gilroy-Bold",),
            onTap: () {},
          ),
          buildCustomSwitchTile('New subscriber', newSubscriber, (val) {
            setState(() => newSubscriber = val);
          }),
          sectionTitle('SELLER BOOKMARK NOTIFICATIONS'),
          buildCustomSwitchTile(
              'Bookmarks from my streams', bookmarksFromStreams, (val) {
            setState(() => bookmarksFromStreams = val);
          }),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CustomText(
              fontFamily: "Gilroy-Bold",
              text: 'Get notified when people bookmark your upcoming streams.',
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

  Widget buildCustomSwitchTile(
      String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: CustomText(text: title, fontSize: 15,  fontFamily: "Gilroy-Bold",),
      trailing: Switch(
        value: value,
        activeColor: Colors.green,
        onChanged: onChanged,
      ),
    );
  }
}
