import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("1. Introduction"),
            sectionText(
                "Hvatai respects your privacy. This Privacy Policy explains how we collect, use, and protect your personal information when you use our app and services."),
            sectionTitle("2. Information We Collect"),
            sectionText(
                "- Personal Information: such as your name, email address, and profile photo.\n"
                    "- Usage Data: such as how you interact with the app, device type, and session logs.\n"
                    "- Payment Information: processed securely through YooKassa, not stored by Hvatai."),
            sectionTitle("3. How We Use Your Information"),
            sectionText(
                "- Create and manage user accounts.\n"
                    "- Process purchases and payments.\n"
                    "- Facilitate live streaming and bidding functionality.\n"
                    "- Improve app functionality and user experience.\n"
                    "- Comply with legal requirements."),
            sectionTitle("4. Data Storage and Security"),
            sectionText(
                "Your data is securely stored using Firebase services. We use industry-standard security measures to protect your information."),
            sectionTitle("5. Sharing Your Information"),
            sectionText(
                "We do not sell your personal data. We may share your information with:\n"
                    "- Service providers like Firebase and YooKassa for operational needs.\n"
                    "- Legal authorities if required by law."),
            sectionTitle("6. GDPR Compliance"),
            sectionText(
                "If you are located in the EU, you have the following rights under GDPR:\n"
                    "- Right to access your data.\n"
                    "- Right to correct inaccurate information.\n"
                    "- Right to delete your data.\n"
                    "- Right to data portability.\n"
                    "- Right to object to processing."),
            sectionTitle("7. Cookies and Tracking"),
            sectionText(
                "We may use cookies or similar technologies to enhance user experience and monitor usage trends."),
            sectionTitle("8. Children’s Privacy"),
            sectionText(
                "Hvatai is not intended for users under the age of 13. We do not knowingly collect personal information from children."),
            sectionTitle("9. Changes to This Policy"),
            sectionText(
                "We may update this Privacy Policy from time to time. Any changes will be notified within the app."),
            sectionTitle("10. Contact Us"),
            sectionText(
                "If you have any questions or requests regarding your data, contact us at:\n"
                    "developer1apexappworks@gmail.com"),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget sectionText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }
}
