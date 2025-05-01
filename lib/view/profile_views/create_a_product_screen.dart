// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:live_app/entities/product_entity.dart';
// import 'package:live_app/services/notification_service.dart';
// import 'package:live_app/services/send_notification_service.dart';
// import 'package:live_app/utils/colors.dart';
// import 'dart:io';
// import '../../custom_widgets/custom_text.dart';
// import '../../services/firebase_services.dart';
//
// class CreateProductScreen extends StatefulWidget {
//   final String? productDocId;
//   final ProductEntity? updateProduct;
//   const CreateProductScreen({super.key, this.productDocId, this.updateProduct});
//
//   @override
//   State<CreateProductScreen> createState() => _CreateProductScreenState();
// }
//
// class _CreateProductScreenState extends State<CreateProductScreen> {
//   final ImagePicker _picker = ImagePicker();
//   List<File> selectedImages = [];
//   int quantity = 1;
//
//   bool isAuction = true;
//   bool selfDestruct = false;
//   bool liveOnly = true;
//
//   String? selectedCategory;
//   String? selectedStreamer;
//   String? selectedDelivery;
//
//   String title = "";
//   String description = "";
//   String? startingBid = "0";
//   String? price = "0";
//
//   final List<String> categories = [
//     "electronics".tr,
//     "cloth".tr,
//     "accessories".tr
//   ];
//   final List<String> streamers = ["Streamer 1", "Streamer 2", "Streamer 3"];
//   final List<String> deliveryOptions = [
//     "standard".tr,
//     "express".tr,
//     "next_day".tr
//   ];
//
//   Future<void> _pickImages() async {
//     final List<XFile>? pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         selectedImages = pickedFiles.map((file) => File(file.path)).toList();
//       });
//     }
//   }
//
//   final TextEditingController _descriptionController = TextEditingController();
//
//   String? descriptionError;
//
//   String title1 = '';
//   String? titleError;
//   bool isLoading = false;
//
//   Future<void> _saveProduct() async {
//     if (selectedImages.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select at least one image.")),
//       );
//       return;
//     }
//
//     // ✅ Validate title
//     if (title1.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Title is required.")),
//       );
//       return;
//     }
//
//     // ✅ Validate description
//     if (description.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Description is required.")),
//       );
//       return;
//     }
//     // ✅ Validate starting bid or price
//     if (isAuction && (startingBid == null || startingBid!.trim().isEmpty)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Starting bid is required.")),
//       );
//       return;
//     }
//     if (!isAuction && (price == null || price!.trim().isEmpty)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Price is required.")),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       List<String> imageUrls =
//           await FirebaseService.uploadImages(selectedImages);
//
//       ProductEntity newProduct = ProductEntity(
//         id: FirebaseAuth.instance.currentUser!.uid,
//         category: selectedCategory ?? "unknown".tr,
//         title: title1.trim(),
//         description: description,
//         quantity: quantity.toString(),
//         saleType: isAuction ? "Auction" : "Buy Now",
//         // startingBid: startingBid,
//         // price: price,
//         startingBid: isAuction ? startingBid : null, // ✅ Only store if Auction
//         price: !isAuction ? price : null,
//         selfDestruct: selfDestruct,
//         isActive: true,
//         isSold: false,
//         liveOnly: liveOnly,
//         streamer: selectedStreamer,
//         delivery: selectedDelivery,
//         images: imageUrls,
//       );
//
//       await FirebaseService.saveProduct(newProduct);
//
//       final notificationDoc =
//           FirebaseFirestore.instance.collection('notifications').doc();
//       await notificationDoc.set({
//         "id": notificationDoc.id,
//         "title": "✅ Product Added!",
//         "body": "Your product '${title1.trim()}' was successfully listed.",
//         "receiverId": FirebaseAuth.instance.currentUser!.uid,
//         "senderId": FirebaseAuth.instance.currentUser!.uid,
//         "timestamp": DateTime.now(),
//         "data": {
//           "screen": "my_products",
//           "productId": newProduct.id,
//         }
//       });
//
//       final userDoc = await FirebaseFirestore.instance
//           .collection("UserEntity")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get();
//
//       final fcmToken = userDoc.data()?['fcmToken'];
//       await SendNotificationService.sendNotificationUsingApi(
//         token: fcmToken,
//         title: 'Product Added',
//         body: 'Your Product is Listed',
//         data: {},
//       );
//       Get.snackbar('Success', 'product_created".tr',
//           colorText: Colors.white, backgroundColor: purpleColor);
//
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to create product: $e")),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
// //   Future<void> _saveProduct() async {
// //     // Upload images
// //     List<String> imageUrls = await FirebaseService.uploadImages(selectedImages);
//
// //     // Create the product object
// //     ProductEntity newProduct = ProductEntity(
// //       id: FirebaseAuth.instance.currentUser!.uid,
// //       category: selectedCategory ?? "unknown".tr,
// //       title: title,
// //       description: description,
// //       // Convert quantity to string
// //       quantity: quantity.toString(),
// //       saleType: isAuction ? "Auction" : "Buy Now",
// //       startingBid: startingBid,
// //       price: price,
// //       selfDestruct: selfDestruct,
// //       isActive: true,
// //       isSold: false,
// //       liveOnly: liveOnly,
// //       streamer: selectedStreamer,
// //       delivery: selectedDelivery,
// //       images: imageUrls,
// //     );
//
// //     // Save product to Firestore
// //     await FirebaseService.saveProduct(newProduct);
// // // Create a Firestore doc for the notification
// //     final notificationDoc =
// //         FirebaseFirestore.instance.collection('notifications').doc();
//
// //     await notificationDoc.set({
// //       "id": notificationDoc.id,
// //       "title": "✅ Product Added!",
// //       "body": "Your product '${title1.trim()}' was successfully listed.",
// //       "receiverId":
// //           FirebaseAuth.instance.currentUser!.uid, // 👈 Target the current user
// //       "senderId": FirebaseAuth.instance.currentUser!.uid,
// //       "timestamp": DateTime.now(),
// //       "data": {
// //         "screen": "my_products",
// //         "productId": newProduct.id,
// //       }
// //     });
// //     final userDoc = await FirebaseFirestore.instance
// //         .collection("UserEntity")
// //         .doc(FirebaseAuth.instance.currentUser!.uid)
// //         .get();
//
// //     final fcmToken = userDoc.data()?['fcmToken'] ?? null;
// //     await SendNotificationService.sendNotificationUsingApi(
// //         token: fcmToken,
// //         title: 'Product Added',
// //         body: 'Your Product is Listed',
// //         data: {});
//
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text("product_created".tr)),
// //     );
//
// //     Navigator.pop(context);
// //   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           "create_product".tr,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Image picker area
//               GestureDetector(
//                 onTap: _pickImages,
//                 child: Container(
//                   height: 120,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: selectedImages.isEmpty
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.photo_camera_outlined,
//                                 size: 40, color: Colors.grey),
//                             SizedBox(height: 8),
//                             Text(
//                               "photo_required".tr,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         )
//                       : SizedBox(
//                           height: 100,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: selectedImages.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(4),
//                                 child: Stack(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.file(
//                                         selectedImages[index],
//                                         width: 100,
//                                         height: 100,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 4,
//                                       right: 4,
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedImages.removeAt(index);
//                                           });
//                                         },
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: const Icon(
//                                             Icons.close,
//                                             color: Colors.white,
//                                             size: 16,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                 ),
//               ),
//
//               Text(
//                 "photos_uploaded"
//                     .tr
//                     .replaceAll("{0}", selectedImages.length.toString()),
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 16),
//
//               /// Product details
//               Text(
//                 "product_details".tr,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () => _showCategoryBottomSheet(context),
//                 child: AbsorbPointer(
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: (selectedCategory ?? '').isEmpty
//                           ? "category".tr
//                           : selectedCategory!,
//                       labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                       filled: true,
//                       fillColor: Colors.grey[50],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 18),
//                       suffixIcon: const Icon(Icons.arrow_drop_down),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // DropdownButtonFormField(
//               //   decoration: InputDecoration(
//               //     hintText: "category".tr,
//               //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//               //     filled: true,
//               //     fillColor: Colors.grey[50],
//               //     border: InputBorder.none,
//               //     enabledBorder: InputBorder.none,
//               //     focusedBorder: InputBorder.none,
//               //   ),
//               //   value: selectedCategory,
//               //   items: categories
//               //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//               //       .toList(),
//               //   onChanged: (val) {
//               //     setState(() => selectedCategory = val as String);
//               //   },
//               // ),
//
//               SizedBox(height: 8),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: "title".tr,
//                   labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                   filled: true,
//                   fillColor: Colors.grey[50],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                 ),
//                 onChanged: (val) {
//                   final words = val.trim().split(RegExp(r"\s+"));
//                   if (words.length <= 20) {
//                     setState(() {
//                       title1 = val;
//                       titleError = null; // ✅ clear error
//                     });
//                   } else {
//                     setState(() {
//                       titleError = "Maximum 10 words allowed";
//                     });
//                   }
//                 },
//               ),
//               const SizedBox(height: 8),
//               TextField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   hintText: "description".tr,
//                   labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                   filled: true,
//                   fillColor: Colors.grey[50],
//                   border: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   errorText: descriptionError,
//                 ),
//                 onChanged: (val) {
//                   final words = val.trim().split(RegExp(r"\s+"));
//                   if (words.length <= 30) {
//                     setState(() {
//                       description = val;
//                       descriptionError = null;
//                     });
//                   } else {
//                     _descriptionController.text = description;
//                     _descriptionController.selection =
//                         TextSelection.fromPosition(
//                       TextPosition(offset: _descriptionController.text.length),
//                     );
//                     setState(() {
//                       descriptionError = "Maximum 30 words allowed";
//                     });
//                   }
//                 },
//               ),
//               // TextField(
//               //   decoration: InputDecoration(
//               //     hintText: "description".tr,
//               //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
//               //     filled: true,
//               //     fillColor: Colors.grey[50],
//               //     border: InputBorder.none,
//               //     enabledBorder: InputBorder.none,
//               //     focusedBorder: InputBorder.none,
//               //   ),
//               //   maxLines: 3,
//               //   onChanged: (val) => setState(() => description = val),
//               // ),
//
//               const SizedBox(height: 16),
//
//               /// Quantity row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "quantity_goods".tr,
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             // Fix: decrement quantity properly
//                             if (quantity > 1) {
//                               quantity--;
//                             }
//                           });
//                         },
//                         icon: const Icon(Icons.remove_circle_outline),
//                       ),
//                       Text(
//                         "$quantity",
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             // Fix: increment quantity properly
//                             quantity++;
//                           });
//                         },
//                         icon: const Icon(Icons.add_circle_outline),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 16),
//
//               /// Auction or Buy Now
//               CustomText(
//                 text: 'type_of_sale'.tr,
//                 fontFamily: 'SF Pro Rounded',
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 4),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     GestureDetector(
//                       onTap: () => setState(() => isAuction = true),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           gradient: isAuction
//                               ? primaryGradientColor
//                               : secondaryGradientColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 40),
//                           child: CustomText(
//                             text: 'auction'.tr,
//                             color: isAuction ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => setState(() => isAuction = false),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           gradient: !isAuction
//                               ? primaryGradientColor
//                               : secondaryGradientColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         alignment: Alignment.center,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 40),
//                           child: CustomText(
//                             text: 'buy_now'.tr,
//                             color: isAuction ? Colors.black : Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // const SizedBox(height: 16),
//
//               // /// Starting Bid or Price
//               // if (isAuction)
//               //   TextField(
//               //     decoration: InputDecoration(
//               //       border: InputBorder.none,
//               //       enabledBorder: InputBorder.none,
//               //       focusedBorder: InputBorder.none,
//               //       labelText: "starting_bid".tr,
//               //       hintText: '100₽',
//               //     ),
//               //     keyboardType: TextInputType.number,
//               //     onChanged: (val) {
//               //       setState(() {
//               //         startingBid = val;
//               //       });
//               //     },
//               //   ),
//
//               // if (!isAuction)
//               //   TextField(
//               //     decoration: InputDecoration(
//               //       border: InputBorder.none,
//               //       enabledBorder: InputBorder.none,
//               //       focusedBorder: InputBorder.none,
//               //       labelText: "price".tr,
//               //       hintText: '100₽',
//               //     ),
//               //     keyboardType: TextInputType.number,
//               //     onChanged: (val) {
//               //       setState(() {
//               //         price = val;
//               //       });
//               //     },
//               //   ),
//
//               const SizedBox(height: 16),
//
//               Text(
//                 isAuction ? "starting_bid".tr : "price".tr,
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//
//               const SizedBox(height: 6),
//
//               TextField(
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[200], // Pale background
//                   hintText: isAuction ? '100₽' : '999₽',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (val) {
//                   setState(() {
//                     if (isAuction) {
//                       startingBid = val;
//                     } else {
//                       price = val;
//                     }
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               /// Self-destruction & Live Only
//               SwitchListTile(
//                 title: Text(
//                   "self_destruction".tr,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   "self_destruction_desc".tr,
//                 ),
//                 value: selfDestruct,
//                 onChanged: (bool value) => setState(() => selfDestruct = value),
//               ),
//               SwitchListTile(
//                 title: Text(
//                   "book_live".tr,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(
//                   "book_live_desc".tr,
//                 ),
//                 value: liveOnly,
//                 activeColor: Colors.green,
//                 onChanged: (bool value) => setState(() => liveOnly = value),
//               ),
//
//               const SizedBox(height: 16),
//
//               /// Streamer & Delivery (only shown if Auction)
//               if (isAuction)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "select_stream".tr,
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     DropdownButtonFormField(
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[50],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       value: selectedStreamer,
//                       items: streamers
//                           .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (val) {
//                         setState(() => selectedStreamer = val as String);
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       "delivery".tr,
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 6),
//                     DropdownButtonFormField(
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.grey[50],
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       value: selectedDelivery,
//                       hint: Text("delivery_details".tr),
//                       items: deliveryOptions
//                           .map(
//                               (e) => DropdownMenuItem(value: e, child: Text(e)))
//                           .toList(),
//                       onChanged: (val) {
//                         setState(() => selectedDelivery = val as String);
//                       },
//                     ),
//                   ],
//                 ),
//
//               /// Bottom buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xffefefef),
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(5), // 🔲 No rounded corners
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: Text(
//                         "cancel".tr,
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontFamily: 'Gilroy-Bold',
//                             fontWeight: FontWeight.w400),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Expanded(
//                   //   child: GestureDetector(
//                   //     onTap: _saveProduct,
//                   //     child: Container(
//                   //       padding: const EdgeInsets.symmetric(vertical: 12),
//                   //       decoration: BoxDecoration(
//                   //         gradient: primaryGradientColor,
//                   //         borderRadius: BorderRadius.circular(8),
//                   //       ),
//                   //       alignment: Alignment.center,
//                   //       child: Padding(
//                   //         padding: EdgeInsets.symmetric(horizontal: 40),
//                   //         child: CustomText(
//                   //           text: 'ready'.tr,
//                   //           color: Colors.white,
//                   //           fontWeight: FontWeight.bold,
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//
//                   Expanded(
//                     child: SizedBox(
//                       height: 70,
//                       child: ElevatedButton(
//                         onPressed: isLoading ? null : _saveProduct,
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                         ),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                             gradient: isLoading ? null : primaryGradientColor,
//                             color: isLoading ? Colors.grey : null,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Container(
//                             alignment: Alignment.center,
//                             child: isLoading
//                                 ? const SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                           Colors.white),
//                                     ),
//                                   )
//                                 : CustomText(
//                                     text: 'ready'.tr,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showCategoryBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return ConstrainedBox(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.3,
//             // ✅ limit height
//           ),
//           child: Container(
//             // padding: const EdgeInsets.all(16),
//             // height: MediaQuery.of(context).size.height * 0.6,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[300],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: const Text(
//                     'Select Category',
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'SFProRounded'),
//                   ),
//                 ),
//                 Expanded(
//                   child: categories.isEmpty
//                       ? const Center(child: Text("No categories available"))
//                       : ListView.builder(
//                           itemCount: categories.length,
//                           itemBuilder: (context, index) {
//                             final category = categories[index];
//                             return ListTile(
//                               title: Text(
//                                 category,
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                               onTap: () {
//                                 setState(() {
//                                   selectedCategory = category;
//                                 });
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

///
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/services/firebase_services.dart';
import 'package:live_app/utils/colors.dart';
import '../../custom_widgets/custom_text.dart';

class CreateProductScreen extends StatefulWidget {
  final String? productDocId;
  final ProductEntity? updateProduct;

  const CreateProductScreen({
    Key? key,
    this.productDocId,
    this.updateProduct,
  }) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  List<String> existingImageUrls = [];
  int quantity = 1;
  bool isAuction = true;
  bool selfDestruct = false;
  bool liveOnly = true;

  String? selectedCategory;
  String? selectedStreamer;
  String? selectedDelivery;

  String title1 = '';
  String description = '';
  String? startingBid = "0";
  String? price = "0";

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? descriptionError;
  String? titleError;
  bool isLoading = false;

  final categories = <String>["electronics", "cloth", "accessories"];
  final streamers = <String>["Streamer 1", "Streamer 2", "Streamer 3"];
  final deliveryOptions = <String>["standard", "express", "next_day"];

  @override
  void initState() {
    super.initState();
    if (widget.updateProduct != null) {
      final p = widget.updateProduct!;
      existingImageUrls = List.from(p.images ?? []);
      selectedCategory = p.category;
      title1 = p.title ?? "";
      description = p.description ?? "";
      _descriptionController.text = description;
      _titleController.text = title1;
      quantity = int.tryParse(p.quantity ?? "1") ?? 1;
      isAuction = p.saleType == "Auction";
      startingBid = p.startingBid;
      price = p.price;
      selfDestruct = p.selfDestruct ?? false;
      liveOnly = p.liveOnly ?? false;
      selectedStreamer = p.streamer;
      selectedDelivery = p.delivery;
    }
  }
  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        selectedImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }
  Future<void> _saveProduct() async {
    // 1) basic validation omitted for brevity…

    setState(() => isLoading = true);
    try {
      List<String> imageUrls;
      if (widget.updateProduct != null && selectedImages.isEmpty) {
        // keep existing
        imageUrls = existingImageUrls;
      } else {
        imageUrls = await FirebaseService.uploadImages(selectedImages);
      }

      final data = {
        "id": FirebaseAuth.instance.currentUser!.uid,
        "category": selectedCategory,
        "title": title1.trim(),
        "description": description,
        "quantity": quantity.toString(),
        "saleType": isAuction ? "Auction" : "Buy Now",
        "startingBid": isAuction ? startingBid : null,
        "price": !isAuction ? price : null,
        "selfDestruct": selfDestruct,
        "isActive": widget.updateProduct?.isActive ?? true,
        "isSold": widget.updateProduct?.isSold ?? false,
        "liveOnly": liveOnly,
        "streamer": selectedStreamer,
        "delivery": selectedDelivery,
        "images": imageUrls,
      };

      if (widget.productDocId != null) {
        // UPDATE
        await FirebaseFirestore.instance.collection('products').doc(widget.productDocId).update(data);
        Get.snackbar('Success', 'product_updated');
      } else {
        // CREATE
        final newProd = ProductEntity.fromJson(data);
        await FirebaseService.saveProduct(newProd);
        Get.snackbar('Success', 'product_created');
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // compute the total number of images (existing + new)
    final totalImages = existingImageUrls.length + selectedImages.length;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.productDocId != null ? "Edit Product" : "Create Product",
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image picker area
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (existingImageUrls.isEmpty && selectedImages.isEmpty)
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text(
                      "photo_required".tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: existingImageUrls.length + selectedImages.length,
                  itemBuilder: (ctx, i) {
                    if (i < existingImageUrls.length) {
                      // existing URL
                      final url = existingImageUrls[i];
                      return _buildImageTile(
                        Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
                        onRemove: () => setState(() => existingImageUrls.removeAt(i)),
                      );
                    } else {
                      // new pick
                      final file = selectedImages[i - existingImageUrls.length];
                      return _buildImageTile(
                        Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                        onRemove: () => setState(() => selectedImages.removeAt(i - existingImageUrls.length)),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "photos_uploaded"
                  .tr
                  .replaceAll("{0}", totalImages.toString()),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _showCategoryBottomSheet(context),
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: selectedCategory?.tr ?? "Select Category".tr,
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // — Title & Description —
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "title".tr,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,

                // ← ADD THIS LINE:
                errorText: titleError,
              ),
              onChanged: (val) {
                final words = val.trim().split(RegExp(r"\s+"));
                if (words.length <= 20) {
                  setState(() {
                    title1 = val;
                    titleError = null;  // will clear the errorText
                  });
                } else {
                  setState(() {
                    titleError = "Maximum 10 words allowed";  // shows under the field
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "description".tr,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.grey[50],
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorText: descriptionError,
              ),
              onChanged: (val) {
                final words = val.trim().split(RegExp(r"\s+"));
                if (words.length <= 30) {
                  setState(() {
                    description = val;
                    descriptionError = null;
                  });
                } else {
                  _descriptionController.text = description;
                  _descriptionController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _descriptionController.text.length),
                  );
                  setState(() {
                    descriptionError = "Maximum 30 words allowed";
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // — Quantity selector —
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                    ),
                    Text("$quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // — Sale type toggle —
            Row(
              children: [
                Expanded(
                  child: _saleTypeButton("Auction", isAuction, () => setState(() => isAuction = true)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _saleTypeButton("Buy Now", !isAuction, () => setState(() => isAuction = false)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // — Starting bid / Price —
            Text(isAuction ? "Starting Bid" : "Price", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: isAuction ? "e.g. 100" : "e.g. 999",
                filled: true,
                fillColor: Colors.grey[50],
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: isAuction ? startingBid : price),
              onChanged: (v) {
                if (isAuction)
                  startingBid = v;
                else
                  price = v;
              },
            ),
            const SizedBox(height: 16),

            // — Switches —
            SwitchListTile(
              title: Text("Self Destruct"),
              value: selfDestruct,
              onChanged: (v) => setState(() => selfDestruct = v),
            ),
            SwitchListTile(
              title: Text("Live Only"),
              value: liveOnly,
              onChanged: (v) => setState(() => liveOnly = v),
            ),
            const SizedBox(height: 16),

            // — Streamer & Delivery (auction only) —
            if (isAuction) ...[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: Text("Select Streamer"),
                value: selectedStreamer,
                items: streamers.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => selectedStreamer = v),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                hint: Text("Delivery Option"),
                value: selectedDelivery,
                items: deliveryOptions.map((e) => DropdownMenuItem(value: e, child: Text(e.tr))).toList(),
                onChanged: (v) => setState(() => selectedDelivery = v),
              ),
              const SizedBox(height: 16),
            ],

            // — Cancel / Save —
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel", style: TextStyle(color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isLoading ? null : primaryGradientColor,
                      color: isLoading ? Colors.grey : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MaterialButton(
                      onPressed: isLoading ? null : _saveProduct,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text(widget.productDocId != null ? "Update" : 'ready'.tr),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(Widget image, {required VoidCallback onRemove}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(8), child: image),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _saleTypeButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient:
              active ? primaryGradientColor : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[300]!]),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.black)),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        height: 250,
        padding: EdgeInsets.all(12),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, i) => ListTile(
            title: Text(categories[i].tr),
            onTap: () {
              setState(() => selectedCategory = categories[i]);
              Navigator.pop(ctx);
            },
          ),
        ),
      ),
    );
  }
}
