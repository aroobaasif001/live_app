import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/entities/report_entity.dart';

class CustomReportDialog extends StatefulWidget {
    const CustomReportDialog({super.key});
  @override
  State<CustomReportDialog> createState() => _CustomReportDialogState();
}

class _CustomReportDialogState extends State<CustomReportDialog> {
  final TextEditingController _reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      title: CustomText(
        text: 'Report Abuse',
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _reportController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write your report here...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffC0241E),
            ),
            onPressed: () async {
              final reportText = _reportController.text;
              if (reportText.isNotEmpty) {
                try {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    // Get current user's name
                    final userDoc = await FirebaseFirestore.instance
                        .collection('UserEntity')
                        .doc(currentUser.uid)
                        .get();
                    final userName = userDoc.data()?['firstName'] ?? 'Anonymous';

                    // Create report entity
                    final report = ReportEntity(
                      reporterId: currentUser.uid,
                      reporterName: userName,
                      reportText: reportText,
                      createAt: DateTime.now(),
                      status: 'pending',
                    );

                    // Save report to Firestore
                    await ReportEntity.collection().add(report);

                    Navigator.pop(context);
                    Get.snackbar(
                      'Report',
                      'Your report has been submitted.',
                    );
                  }
                } catch (e) {
                  print('Error submitting report: $e');
                  Get.snackbar(
                    'Error',
                    'Failed to submit report. Please try again.',
                  );
                }
              } else {
                Get.snackbar(
                  'Error',
                  'Please write something before submitting.',
                );
              }
            },
            child: CustomText(
              text: 'Submit',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
