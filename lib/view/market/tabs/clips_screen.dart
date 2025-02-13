import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'package:live_app/utils/images_path.dart';

class ClipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.5,
        ),
        itemCount: 4, // Number of clips
        itemBuilder: (context, index) {
          return Column(
            children: [
              CustomContainer(
                height: 262,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(bgImage), // Replace with actual image path
                    fit: BoxFit.fill,
                  ),
              ),
              SizedBox(height: 6),
              CustomText(
                text: '🇺🇸 Lorem ipsum dolor sit amet consectetur adipisc',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                fontSize: 12,
              )
            ],
          );
        },
      ),
    );
  }
}