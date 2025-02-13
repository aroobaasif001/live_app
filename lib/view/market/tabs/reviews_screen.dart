import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_app/controller/read_more_controller.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/images_path.dart';

class ReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ReadMoreController controller = Get.put(ReadMoreController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(girlImage), // Replace with actual image path
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      CustomText(text: 'nickname25', fontWeight: FontWeight.bold),
                      Spacer(),
                      Icon(Icons.more_horiz, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CustomText(text: '3.8', fontWeight: FontWeight.bold),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Color(0xff60C0FF), Color(0xffE356D7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds);
                        },
                        child: Icon(Icons.star, size: 16, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      CustomText(text: '21.01.2025'),
                    ],
                  ),
                  SizedBox(height: 10),
                  /// **Description**
                  Obx(() => Text(
                    'Lorem ipsum dolor sit amet consectetur adipiscing elit Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit',
                    maxLines: controller.readMore.value ? null : 2,
                    overflow: controller.readMore.value ? TextOverflow.visible : TextOverflow.ellipsis,
                  )),
                  SizedBox(height: 10),
                  // **See more / See less button**
                  GestureDetector(
                    onTap: controller.toggleReadMore,
                    child: Row(
                      children: [
                        Obx(() => CustomText(
                          text: controller.readMore.value ? 'See less' : 'See more',
                          color: Color(0xff815BFF),
                          fontWeight: FontWeight.bold,
                        )),
                        Obx(() => Icon(
                          controller.readMore.value ? Icons.expand_less : Icons.expand_more,
                          color: Color(0xff815BFF),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}