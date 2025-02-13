import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/controller/read_more_controller.dart';

class CustomReadMoreText extends StatelessWidget {
  final String text;
  const CustomReadMoreText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final ReadMoreController controller = Get.put(ReadMoreController());
    final lines = controller.readMore.value? null: 2;
    return Text(
      text,
      maxLines: lines,
      overflow: controller.readMore.value?TextOverflow.visible:TextOverflow.ellipsis,
    );
  }
}
