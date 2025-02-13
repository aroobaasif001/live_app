import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';



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
  bool livePurchase = true;
  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedStreamer;
  String? selectedDelivery;

  final List<String> categories = [
    "Category 1", "Category 2", "Category 3", "Category 4"
  ];
  final List<String> subcategories = List.generate(10, (index) => "Name of the Product Type");
  final List<String> streamers = [
    "Stream Title 1", "Stream Title 2", "Stream Title 3"
  ];
  final List<String> deliveryOptions = [
    "Delivery Title 1", "Delivery Title 2", "Delivery Title 3"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const CustomText(
          text: "Create a product",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Photo"),
              _buildPhotoUploadBox(),
              const SizedBox(height: 16),
              _buildSectionTitle("Product details"),
              _buildSelectionField("Category", selectedCategory, categories, (String? val) {
                setState(() {
                  selectedCategory = val;
                });
              }),
              const SizedBox(height: 8),
              _buildTextField("Title"),
              const SizedBox(height: 8),
              _buildTextField("Description", maxLines: 3),

              const SizedBox(height: 16),

              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle("Quantity of goods:"),
                  Row(
                    children: [
                      _buildQuantityButton(Icons.remove, () {
                        setState(() {
                          if (quantity > 1) quantity--;
                        });
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CustomText(
                          text: quantity.toString(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildQuantityButton(Icons.add, () {
                        setState(() {
                          quantity++;
                        });
                      }),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _buildSectionTitle("Type of sale"),

              if (isAuction) ...[
                const SizedBox(height: 8),
                _buildTextField("Starting bid", keyboardType: TextInputType.number),
              ],

              const SizedBox(height: 16),

              _buildToggle(
                title: "Self-destruction",
                toggleValue: selfDestruct,
                subtitle: "This means that at 00:01 the last person to place a bid will win.",
                onChanged: (bool value) {
                  setState(() {
                    selfDestruct = value;
                  });
                },
              ),

              _buildToggle(
                title: "Book your participation in Live",
                toggleValue: livePurchase,
                subtitle: "Toggle this to make this item only available for purchase during the stream.",
                onChanged: (bool value) {
                  setState(() {
                    livePurchase = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              _buildSelectionField("Select a streamer", selectedStreamer, streamers, (String? val) {
                setState(() {
                  selectedStreamer = val;
                });
              }),

              const SizedBox(height: 16),

              _buildSelectionField("Delivery", selectedDelivery, deliveryOptions, (String? val) {
                setState(() {
                  selectedDelivery = val;
                });
              }),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildButton("Cancel", Colors.grey[300]!, Colors.black, () {}),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildGradientButton("Ready"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// **📌 Image Selection Function**
  Future<void> _pickImages() async {
    if (await Permission.photos.request().isGranted) {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        setState(() {
          if (selectedImages.length + pickedFiles.length > 8) {
            selectedImages.addAll(
                pickedFiles.take(8 - selectedImages.length).map((file) => File(file.path)));
          } else {
            selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
          }
        });
      }
    } else {
      // Show error if permission is denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied. Enable it in settings.")),
      );
    }
  }

  /// **📌 Photo Upload Section**
  // Widget _buildPhotoUploadBox() {
  //   return GestureDetector(
  //     onTap: _pickImages,
  //     child: Container(
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey.shade300),
  //         borderRadius: BorderRadius.circular(12),
  //         color: Colors.grey[100],
  //       ),
  //       padding: const EdgeInsets.all(10),
  //       child: Column(
  //         children: [
  //           // Display selected images in a horizontal ListView
  //           if (selectedImages.isNotEmpty)
  //             SizedBox(
  //               height: 100, // Adjust height to fit images
  //               child: ListView.builder(
  //                 scrollDirection: Axis.horizontal,
  //                 itemCount: selectedImages.length,
  //                 itemBuilder: (context, index) {
  //                   return Stack(
  //                     clipBehavior: Clip.none,
  //                     children: [
  //                       Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 4),
  //                         width: 120,
  //                         height: 140,
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(8),
  //                           image: DecorationImage(
  //                             image: FileImage(selectedImages[index]),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                       // Remove Image Button
  //                       Positioned(
  //                         top: -5,
  //                         right: -5,
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             setState(() {
  //                               selectedImages.removeAt(index);
  //                             });
  //                           },
  //                           child: Container(
  //                             decoration: const BoxDecoration(
  //                               color: Colors.red,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: const Icon(Icons.close, color: Colors.white, size: 18),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             )
  //           else
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
  //                 const SizedBox(height: 8),
  //                 const CustomText(
  //                   text: "Tap to select images",
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //                 const CustomText(
  //                   text: "Max 8 images",
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.grey,
  //                 ),
  //                 const SizedBox(height: 8),
  //               ],
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget _buildPhotoUploadBox() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            // **Horizontal ListView for Selected Images**
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // **Image Container**
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // **Properly Positioned Close Button**
                        Positioned(
                          top: -5,
                          right: -5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_outlined, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  const CustomText(
                    text: "Tap to select images",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const CustomText(
                    text: "Max 8 images",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: bgColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: CustomText(text: text, color: textColor, fontWeight: FontWeight.bold),
    );
  }






  Widget _buildToggle({
    required String title,
    required bool toggleValue, // Changed from 'value' to 'toggleValue'
    required String subtitle,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
      ),
      subtitle: CustomText(
        text: subtitle,
        fontSize: 12,
        color: Colors.grey,
      ),
      value: toggleValue, // Ensure it uses the correct variable
      onChanged: onChanged,
    );
  }


  void _showSelectionBottomSheet({
    required String title,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isSubcategory = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title, Back Button, Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isSubcategory
                          ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pop(context),
                      )
                          : const SizedBox(),
                      CustomText(text: title, fontSize: 18, fontWeight: FontWeight.bold),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return isSubcategory
                            ? RadioListTile<String>(
                          title: CustomText(text: items[index]),
                          value: items[index],
                          groupValue: selectedSubcategory,
                          activeColor: Colors.purpleAccent,
                          onChanged: (String? value) {
                            setModalState(() {
                              selectedSubcategory = value;
                            });
                            onChanged(value);
                            Navigator.pop(context);
                          },
                        )
                            : ListTile(
                          title: CustomText(text: items[index]),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            _showSelectionBottomSheet(
                              title: "Select category",
                              items: subcategories,
                              onChanged: onChanged,
                              isSubcategory: true,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
    Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Icon(icon, size: 20, color: Colors.black),
      ),
    );
  }

  Widget _buildSaleTypeToggle() {
    return Row(
      children: [
        Expanded(
            child: _buildGradientButton("Auction", isSelected: isAuction,
                onTap: () {
          setState(() {
            isAuction = true;
          });
        })),
        Expanded(
            child: _buildGradientButton("Buy now", isSelected: !isAuction,
                onTap: () {
          setState(() {
            isAuction = false;
          });
        })),
      ],
    );
  }

  Widget _buildGradientButton(String text, {bool isSelected = true, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: isSelected
              ? const LinearGradient(colors: [Colors.blue, Colors.purple])
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400]),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CustomText(
        text: text,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }



  Widget _buildTextField(String hint,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSelectionField(String title, String? selectedValue, List<String> items, ValueChanged<String?> onChanged) {
    return GestureDetector(
      onTap: () {
        _showSelectionBottomSheet(title: title, items: items, onChanged: onChanged);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: selectedValue ?? title, color: Colors.black, fontSize: 16),
            const Icon(Icons.keyboard_arrow_down_outlined),
          ],
        ),
      ),
    );
  }
}

