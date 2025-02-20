import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          // Video thumbnail with overlay details
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                // Display the admin image (assumed to be a URL)
                child: Image.network(
                  adminImage!,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              // Live badge with views count
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Live • $viewsCount",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Top right bookmark and views count
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  children: [
                    const Icon(Icons.bookmark, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      "$viewsCount",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Bottom details with title and extra info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(flagIcon, height: 16, width: 16),
                    Flexible(
                      child: CustomText(
                        text: title!,
                        fontSize: 12,
                        color: const Color(0xff2a2a2a),
                        fontFamily: 'Gilroy-Bold',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

