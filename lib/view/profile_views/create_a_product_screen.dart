
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_app/entities/product_entity.dart';
import 'package:live_app/utils/colors.dart';
import 'dart:io';
import '../../custom_widgets/custom_text.dart';
import '../../services/firebase_services.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> selectedImages = [];
  int quantity = 1;

  bool isAuction = true;
  bool selfDestruct = false;
  bool liveOnly = true;

  String? selectedCategory;
  String? selectedStreamer;
  String? selectedDelivery;

  String title = "";
  String description = "";
  String? startingBid = "0";
  String? price = "0";

  final List<String> categories = [
    "electronics".tr,
    "cloth".tr,
    "accessories".tr
  ];
  final List<String> streamers = ["Streamer 1", "Streamer 2", "Streamer 3"];
  final List<String> deliveryOptions = [
    "standard".tr,
    "express".tr,
    "next_day".tr
  ];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  final TextEditingController _descriptionController = TextEditingController();

  String? descriptionError;

  String title1 = '';
  String? titleError;
  // Future<void> _saveProduct() async {
  //   // Upload images
  //   List<String> imageUrls = await FirebaseService.uploadImages(selectedImages);

  //   // Create the product object
  //   ProductEntity newProduct = ProductEntity(
  //     id: FirebaseAuth.instance.currentUser!.uid,
  //     category: selectedCategory ?? "unknown".tr,
  //     title: title,
  //     description: description,
  //     // Convert quantity to string
  //     quantity: quantity.toString(),
  //     saleType: isAuction ? "Auction" : "Buy Now",
  //     startingBid: startingBid,
  //     price: price,
  //     selfDestruct: selfDestruct,
  //     isActive: true,
  //     isSold: false,
  //     liveOnly: liveOnly,
  //     streamer: selectedStreamer,
  //     delivery: selectedDelivery,
  //     images: imageUrls,
  //   );

  //   // Save product to Firestore
  //   await FirebaseService.saveProduct(newProduct);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("product_created".tr)),
  //   );

  //   Navigator.pop(context);
  // }

  Future<void> _saveProduct() async {
  try {
    // Upload images
    List<String> imageUrls = await FirebaseService.uploadImages(selectedImages);

    // Create the product object
    ProductEntity newProduct = ProductEntity(
      id: FirebaseAuth.instance.currentUser!.uid,
      category: selectedCategory ?? "unknown".tr,
      title: title1.trim(), // ← Use the validated title
      description: description.trim(),
      quantity: quantity.toString(),
      saleType: isAuction ? "Auction" : "Buy Now",
      startingBid: isAuction ? startingBid : null,
      price: !isAuction ? price : null,
      selfDestruct: selfDestruct,
      isActive: true,
      isSold: false,
      liveOnly: liveOnly,
      streamer: selectedStreamer,
      delivery: selectedDelivery,
      images: imageUrls,
    );

    await FirebaseService.saveProduct(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("product_created".tr)),
    );

    Navigator.pop(context);
  } catch (e, stack) {
    print("🔥 Error saving product: $e");
    print(stack);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to create product: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "create_product".tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
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
                  child: selectedImages.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_camera_outlined,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              "photo_required".tr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        selectedImages[index],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedImages.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),

              Text(
                "photos_uploaded"
                    .tr
                    .replaceAll("{0}", selectedImages.length.toString()),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              /// Product details
              Text(
                "product_details".tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showCategoryBottomSheet(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: (selectedCategory ?? '').isEmpty
                          ? "category".tr
                          : selectedCategory!,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ),
              ),

              // DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     hintText: "category".tr,
              //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              //     filled: true,
              //     fillColor: Colors.grey[50],
              //     border: InputBorder.none,
              //     enabledBorder: InputBorder.none,
              //     focusedBorder: InputBorder.none,
              //   ),
              //   value: selectedCategory,
              //   items: categories
              //       .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              //       .toList(),
              //   onChanged: (val) {
              //     setState(() => selectedCategory = val as String);
              //   },
              // ),

              SizedBox(height: 8),
              TextField(
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
                ),
                onChanged: (val) {
                  final words = val.trim().split(RegExp(r"\s+"));
                  if (words.length <= 20) {
                    setState(() {
                      title1 = val;
                      titleError = null; // ✅ clear error
                    });
                  } else {
                    setState(() {
                      titleError = "Maximum 10 words allowed";
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
                    _descriptionController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: _descriptionController.text.length),
                    );
                    setState(() {
                      descriptionError = "Maximum 30 words allowed";
                    });
                  }
                },
              ),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: "description".tr,
              //     labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              //     filled: true,
              //     fillColor: Colors.grey[50],
              //     border: InputBorder.none,
              //     enabledBorder: InputBorder.none,
              //     focusedBorder: InputBorder.none,
              //   ),
              //   maxLines: 3,
              //   onChanged: (val) => setState(() => description = val),
              // ),

              const SizedBox(height: 16),

              /// Quantity row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "quantity_goods".tr,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // Fix: decrement quantity properly
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // Fix: increment quantity properly
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Auction or Buy Now
              CustomText(
                text: 'type_of_sale'.tr,
                fontFamily: 'SF Pro Rounded',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => isAuction = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: isAuction
                              ? primaryGradientColor
                              : secondaryGradientColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: CustomText(
                            text: 'auction'.tr,
                            color: isAuction ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isAuction = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: !isAuction
                              ? primaryGradientColor
                              : secondaryGradientColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: CustomText(
                            text: 'buy_now'.tr,
                            color: isAuction ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 16),

              // /// Starting Bid or Price
              // if (isAuction)
              //   TextField(
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       enabledBorder: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       labelText: "starting_bid".tr,
              //       hintText: '100₽',
              //     ),
              //     keyboardType: TextInputType.number,
              //     onChanged: (val) {
              //       setState(() {
              //         startingBid = val;
              //       });
              //     },
              //   ),

              // if (!isAuction)
              //   TextField(
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       enabledBorder: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       labelText: "price".tr,
              //       hintText: '100₽',
              //     ),
              //     keyboardType: TextInputType.number,
              //     onChanged: (val) {
              //       setState(() {
              //         price = val;
              //       });
              //     },
              //   ),
              const SizedBox(height: 16),

Text(
  isAuction ? "starting_bid".tr : "price".tr,
  style: const TextStyle(fontWeight: FontWeight.bold),
),

const SizedBox(height: 6),

TextField(
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[200], // Pale background
    hintText: isAuction ? '100₽' : '999₽',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  keyboardType: TextInputType.number,
  onChanged: (val) {
    setState(() {
      if (isAuction) {
        startingBid = val;
      } else {
        price = val;
      }
    });
  },
),


              const SizedBox(height: 16),

              /// Self-destruction & Live Only
              SwitchListTile(
                title: Text(
                  "self_destruction".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "self_destruction_desc".tr,
                ),
                value: selfDestruct,
                onChanged: (bool value) => setState(() => selfDestruct = value),
              ),
              SwitchListTile(
                title: Text(
                  "book_live".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "book_live_desc".tr,
                ),
                value: liveOnly,
                activeColor: Colors.green,
                onChanged: (bool value) => setState(() => liveOnly = value),
              ),

              const SizedBox(height: 16),

              /// Streamer & Delivery (only shown if Auction)
              if (isAuction)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "select_stream".tr,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedStreamer,
                      items: streamers
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedStreamer = val as String);
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "delivery".tr,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      value: selectedDelivery,
                      hint: Text("delivery_details".tr),
                      items: deliveryOptions
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedDelivery = val as String);
                      },
                    ),
                  ],
                ),

              /// Bottom buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffefefef),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // 🔲 No rounded corners
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "cancel".tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Gilroy-Bold',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _saveProduct,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: primaryGradientColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: CustomText(
                            text: 'ready'.tr,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
            // ✅ limit height
          ),
          child: Container(
            // padding: const EdgeInsets.all(16),
            // height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Center(
                  child: const Text(
                    'Select Category',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SFProRounded'),
                  ),
                ),
                Expanded(
                  child: categories.isEmpty
                      ? const Center(child: Text("No categories available"))
                      : ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return ListTile(
                              title: Text(
                                category,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
