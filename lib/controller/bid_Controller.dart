import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BidController extends GetxController {
  // TextEditingController for handling user input for the bid price.
  final TextEditingController priceController = TextEditingController();

  // Observable for the current highest bid, initially set to 100 ₽.
  // This can be used to update UI widgets reactively.
  final RxDouble currentBid = 100.0.obs;

  // Place bid logic that checks validity of the entered bid and shows a success dialog.
  void placeBid() {
    final String input = priceController.text.trim();
    // Remove any currency symbols (like '₽') that might be added to the input.
    final String cleanedInput = input.replaceAll('₽', '').trim();
    final double? bidAmount = double.tryParse(cleanedInput);

    // Validate the bid amount.
    if (bidAmount == null) {
      Get.snackbar("Error", "Please enter a valid number for the bid.");
      return;
    }
    if (bidAmount < 200) {
      Get.snackbar("Error", "Your bid must be at least 200 ₽.");
      return;
    }
    if (bidAmount <= currentBid.value) {
      Get.snackbar("Error", "Your bid must be higher than the current bid of ${currentBid.value.toStringAsFixed(0)} ₽.");
      return;
    }

    // Update the current bid value.
    currentBid.value = bidAmount;

    // Show the success dialog using Get.dialog.
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A close icon to dismiss the dialog.
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close_outlined),
              ),
            ),
            // You can use your custom container or image here.
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/check_with_circle.png'),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Display the bid amount placed.
            Text(
              '${bidAmount.toStringAsFixed(0)} ₽',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // You can replace the following Text widget with your GradientText widget.
            Text(
              "Successfully Placed",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    // Dispose of the controller when not in use.
    priceController.dispose();
    super.onClose();
  }
}
