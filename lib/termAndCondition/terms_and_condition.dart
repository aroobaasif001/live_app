import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle("1. Introduction"),
            sectionText(
              "Welcome to Hvatai! These Terms and Conditions govern your use of the Hvatai mobile application, operated by Apex AppWorks, including services like live bidding, purchasing, and account management.\n"
                  "By using the app, you agree to be bound by these terms.",
            ),
            sectionTitle("2. Eligibility"),
            sectionText(
              "- Be at least 18 years old or of legal age in your country.\n"
                  "- Agree to comply with these Terms.\n"
                  "- Provide accurate registration information.",
            ),
            sectionTitle("3. User Accounts"),
            sectionText(
              "- You must register an account using a valid email address.\n"
                  "- You are responsible for safeguarding your account.\n"
                  "- Hvatai reserves the right to suspend or terminate accounts for violations.",
            ),
            sectionTitle("4. Live Bidding"),
            sectionText(
              "- Live bidding allows users to place real-time offers on products.\n"
                  "- All bids are final and binding once accepted.\n"
                  "- Hvatai is not responsible for network issues affecting bid timing.",
            ),
            sectionTitle("5. Payments"),
            sectionText(
              "- Payments are processed through YooKassa. By using the service, you also agree to YooKassa's Terms of Use.\n"
                  "- All prices are in EUR unless stated otherwise.\n"
                  "- Hvatai is not liable for third-party payment failures or disputes.",
            ),
            sectionTitle("6. Refunds and Cancellations"),
            sectionText(
              "- All sales are final unless explicitly stated.\n"
                  "- Refund requests must comply with our Refund Policy.",
            ),
            sectionTitle("7. Privacy"),
            sectionText(
              "- We respect your privacy and comply with the General Data Protection Regulation (GDPR).\n"
                  "- We collect only the necessary personal data and store it securely via Firebase.\n"
                  "- See our Privacy Policy for more details.",
            ),
            sectionTitle("8. Content and Conduct"),
            sectionText(
              "- You agree not to post or stream harmful, illegal, or abusive content.\n"
                  "- Hvatai reserves the right to remove such content and ban offending users.",
            ),
            sectionTitle("9. Intellectual Property"),
            sectionText(
              "- All content, trademarks, and technology within the app are owned by Hvatai or its licensors.\n"
                  "- You may not use them without written permission.",
            ),
            sectionTitle("10. Liability"),
            sectionText(
              "- Hvatai provides the platform as is and does not guarantee uninterrupted service.\n"
                  "- We are not liable for any loss, damages, or disputes between users and sellers.",
            ),
            sectionTitle("11. Changes to the Terms"),
            sectionText(
              "- Hvatai may update these terms from time to time. Users will be notified within the app.\n"
                  "- Continued use of the app means you accept the updated terms.",
            ),
            sectionTitle("12. Contact"),
            sectionText(
              "For questions about these Terms, contact us at:\n"
                  "developer1apexappworks@gmail.com",
            ),
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
