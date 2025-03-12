import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import '../../../custom_widgets/custom_text.dart';

class LiveVideoCard extends StatelessWidget {
  final String adminName;
  final String adminImage;
  final int viewsCount;
  final String title;
  final String description;
  final String liveImage;

  const LiveVideoCard({
    Key? key,
    required this.adminName,
    required this.adminImage,
    required this.viewsCount,
    required this.title,
    required this.description, required this.liveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row with admin avatar and name.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: const AssetImage('assets/icons/apple1.png'),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  adminName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // Live video container.
        CustomContainer(
          height: MediaQuery.of(context).size.height*0.2,
          width: double.infinity,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(liveImage ?? adminImage),
            fit: BoxFit.fill,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Live • $viewsCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // Title and description area wrapped in Expanded.
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/icons/flag.png',
                      height: 20,
                      width: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomText(
                        text: title,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff2a2a2a),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: description,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff2a2a2a),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


/// ///

// import 'package:flutter/material.dart';
// import 'package:live_app/custom_widgets/custom_container.dart';
// import '../../../custom_widgets/custom_text.dart';
//
// class LiveVideoCard extends StatelessWidget {
//   final String adminName;
//   final String adminImage;
//   final int viewsCount;
//   final String title;
//   final String description;
//
//   const LiveVideoCard({
//     Key? key,
//     required this.adminName,
//     required this.adminImage,
//     required this.viewsCount,
//     required this.title,
//     required this.description,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Top row with admin avatar and name.
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 15,
//                 backgroundImage:
//                 const AssetImage('assets/icons/apple1.png'),
//               ),
//               const SizedBox(width: 5),
//               Expanded(
//                 child: Text(
//                   adminName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Live video container.
//         CustomContainer(
//           height: 252,
//           width: double.infinity,
//           borderRadius: BorderRadius.circular(10),
//           image: DecorationImage(
//             image: NetworkImage(adminImage),
//             fit: BoxFit.fill,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     "Live • $viewsCount",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         // Title and description area.
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Use minimal vertical space.
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset('assets/icons/flag.png',
//                       height: 20, width: 16),
//                   const SizedBox(width: 5),
//                   Expanded(
//                     child: CustomText(
//                       text: title,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xff2a2a2a),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               CustomText(
//                 text: description,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xff2a2a2a),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


///

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:live_app/custom_widgets/custom_container.dart';
//
// import '../../../custom_widgets/custom_text.dart';
// import '../../../utils/icons_path.dart';
//
// class LiveVideoCard extends StatelessWidget {
//   final String adminName;
//   final String adminImage;
//   final int viewsCount;
//   final String title;
//   final String description;
//
//   const LiveVideoCard({
//     Key? key,
//     required this.adminName,
//     required this.adminImage,
//     required this.viewsCount,
//     required this.description,
//     required this.title,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 radius: 15,
//                 backgroundImage: AssetImage('assets/icons/apple1.png'),
//               ),
//               const SizedBox(width: 5),
//               Expanded(
//                 child: Text(
//                   adminName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         CustomContainer(
//           height: 252,
//           width: double.maxFinite,
//           borderRadius: BorderRadius.circular(10),
//           image: DecorationImage(image: NetworkImage(adminImage),fit: BoxFit.fill),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: Text(
//                     "Live • $viewsCount",
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Image.asset('assets/icons/flag.png', height: 20, width: 16),
//                       const SizedBox(width: 5),
//                       Flexible(
//                         child: CustomText(
//                           text: title,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xff2a2a2a),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//               Flexible(
//                 child: CustomText(
//                   text: title,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xff2a2a2a),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
