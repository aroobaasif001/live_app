// import 'package:flutter/material.dart';
// import 'package:live_app/entities/product_entity.dart';


// Widget buildAuctionCard(ProductEntity product) {
//   return Card(
//     color: Colors.white,
//     margin: EdgeInsets.symmetric(vertical: 6),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     elevation: 0,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
//               child: product.images != null && product.images!.isNotEmpty
//                   ? Image.network(product.images![0], width: 100, height: 100, fit: BoxFit.cover)
//                   : Image.asset("assets/placeholder.png", width: 100, height: 100, fit: BoxFit.cover), // ✅ Default Image
//             ),
//           ],
//         ),
//         SizedBox(width: 10),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(product.category!,
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//                     SizedBox(width: 4),
//                     Icon(Icons.star, color: Colors.amber, size: 14),
//                     SizedBox(width: 4),
//                     Text("4.5", style: TextStyle(fontSize: 12)), 
//                   ],
//                 ),
//                 SizedBox(height: 4),
//                 Text(product.title!, style: TextStyle(fontSize: 14)),
//                 Text(product.description!, style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 SizedBox(height: 4),
//                 Text("${product.price} ₽", 
//                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }


import 'package:flutter/material.dart';
import 'package:live_app/entities/product_entity.dart';

Widget buildAuctionCard(ProductEntity product) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: product.images != null && product.images!.isNotEmpty
                  ? Image.network(
                      product.images![0],
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/placeholder.png",
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
            ),
            // 🟢 Top-right chat bubble
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/Bookmark.png',height: 16,width: 16,),
                    SizedBox(width: 4),
                    Text(
                      "3",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: category, rating
                Row(
                  children: [
                    Text(
                      product.category ?? "company_name",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    const Text("4.9", style: TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.title ?? 'Product name',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.description ?? 'Description',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${product.price} ₽",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
