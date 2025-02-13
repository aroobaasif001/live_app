import 'package:get/get.dart';

class ReadMoreController extends
GetxController {
  var readMore = false.obs;

  void toggleReadMore() {
    readMore.value = !readMore.value;
  }
}