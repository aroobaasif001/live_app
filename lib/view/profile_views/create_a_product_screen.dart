import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final List<String> categories = ["Electronics", "Clothing", "Accessories"];
  final List<String> streamers = ["Streamer 1", "Streamer 2", "Streamer 3"];
  final List<String> deliveryOptions = ["Standard", "Express", "Next-Day"];

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _saveProduct() async {
    // Upload images
    List<String> imageUrls = await FirebaseService.uploadImages(selectedImages);

    // Create the product object
    ProductEntity newProduct = ProductEntity(
      id: FirebaseAuth.instance.currentUser!.uid,
      category: selectedCategory ?? "Unknown",
      title: title,
      description: description,
      // Convert quantity to string
      quantity: quantity.toString(),
      saleType: isAuction ? "Auction" : "Buy Now",
      startingBid: startingBid,
      price: price,
      selfDestruct: selfDestruct,
      isActive: true,
      isSold: false,
      liveOnly: liveOnly,
      streamer: selectedStreamer,
      delivery: selectedDelivery,
      images: imageUrls,
    );

    // Save product to Firestore
    await FirebaseService.saveProduct(newProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product Created Successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Create a product",
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
                    children: const [
                      Icon(Icons.photo_camera_outlined,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        "1 photo is required*",
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
                "Uploaded ${selectedImages.length}/8",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),

              /// Product details
              const Text(
                "Product details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: "Category*",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                value: selectedCategory,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() => selectedCategory = val as String);
                },
              ),

              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "Title*",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (val) => setState(() => title = val),
              ),
              const SizedBox(height: 8),

              TextField(
                decoration: InputDecoration(
                  hintText: "Description*",
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                maxLines: 3,
                onChanged: (val) => setState(() => description = val),
              ),

              const SizedBox(height: 16),

              /// Quantity row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quantity of goods:",
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
                text: 'Type of Sale',
                fontFamily: 'SF Pro Rounded',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 16),
              Row(
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: CustomText(
                          text: 'Auction',
                          color: Colors.white,
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: CustomText(
                          text: 'Buy Now',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Starting Bid or Price
              if (isAuction)
                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    labelText: "Starting bid* (₽)",
                    hintText: '100₽',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      startingBid = val;
                    });
                  },
                ),

              if (!isAuction)
                TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    labelText: "Price",
                    hintText: '100₽',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    setState(() {
                      price = val;
                    });
                  },
                ),

              const SizedBox(height: 16),

              /// Self-destruction & Live Only
              SwitchListTile(
                title: const Text(
                  "Self-destruction",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "This means that at 00:01 the last person to place a bet wins!",
                ),
                value: selfDestruct,
                onChanged: (bool value) => setState(() => selfDestruct = value),
              ),
              SwitchListTile(
                title: const Text(
                  "Book your participation in Live",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Toggle this to make this item only available for purchase during the stream.",
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
                    const Text(
                      "Select a stream*",
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
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        setState(() => selectedStreamer = val as String);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Delivery",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      hint: const Text("Dimensions, weight of the parcel*"),
                      items: deliveryOptions
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
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
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: CustomText(
                            text: 'Ready',
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
}

