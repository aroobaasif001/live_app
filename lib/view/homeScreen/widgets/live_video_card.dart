import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';

import '../../../custom_widgets/custom_text.dart';
import '../../../utils/icons_path.dart';

class LiveVideoCard extends StatelessWidget {
  final String? adminName;
  final String? adminImage;
  final int? viewsCount;
  final String? title;

  const LiveVideoCard({
    Key? key,
    this.adminName,
    this.adminImage,
    this.viewsCount,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset('assets/icons/apple1.png'),
            const SizedBox(width: 10),
            CustomText(
              text: adminName!,
              fontFamily: 'Gilroy-Bold',
              fontWeight: FontWeight.w400,
            )
          ],
        ),
        const SizedBox(height: 10),
        CustomContainer(
          height: 262,
          width: double.maxFinite,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: NetworkImage(adminImage!),fit: BoxFit.fill),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Live • $viewsCount",
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      "$viewsCount",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomContainer(
                height: 16,
                width: 16,
                image: DecorationImage(image: AssetImage(flagIcon),fit: BoxFit.fill),
              ),
              Flexible(
                child: CustomText(
                  text: title!,
                  textAlign: TextAlign.start,
                  fontSize: 12,
                  color: const Color(0xff2a2a2a),
                  fontFamily: 'Gilroy-Bold',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}