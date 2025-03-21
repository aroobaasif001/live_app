import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../custom_widgets/custom_text.dart';
import '../../entities/product_entity.dart';
import '../market/tabs/product_detail/product_detail_screen.dart';

class SearchByProduct extends StatefulWidget {
  const SearchByProduct({super.key});

  @override
  State<SearchByProduct> createState() => _SearchByProductState();
}

class _SearchByProductState extends State<SearchByProduct> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchChips = []; // Previous search history
  String _searchQuery = ""; // Holds current search query
  List<ProductEntity> _filteredProducts = []; // Filtered products
  bool _isSearching = false; // Controls visibility of products

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  /// Fetch all products from Firestore
  Future<List<ProductEntity>> _fetchProducts() async {
    var snapshot = await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) => ProductEntity.fromJson(doc.data())).toList();
  }

  /// Load search history from SharedPreferences
  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchChips = prefs.getStringList("search_history") ?? [];
    });
  }

  /// Save search history to SharedPreferences
  Future<void> _saveSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("search_history", _searchChips);
  }

  /// Clear all search history
  Future<void> _clearSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("search_history");
    setState(() {
      _searchChips.clear();
    });
  }

  /// Search products based on query
  Future<void> _searchProducts(String query) async {
    if (query.isEmpty) return;

    List<ProductEntity> allProducts = await _fetchProducts();
    List<ProductEntity> results = allProducts.where((product) {
      return product.title?.toLowerCase().contains(query.toLowerCase()) ?? false;
    }).toList();

    setState(() {
      _filteredProducts = results;
      _isSearching = true;
    });

    if (!_searchChips.contains(query)) {
      _searchChips.add(query);
      await _saveSearchHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (value) {
                            _searchProducts(value);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search for products",
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                  _filteredProducts.clear();
                                });
                              },
                              child: const Icon(Icons.close, color: Colors.grey),
                            )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                          _filteredProducts.clear();
                        });
                       Get.back();
                      },
                      child: CustomText(
                        text: "Cancel",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Gilroy-Bold",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Tabs: "Suggested" & "Saved"
                ButtonsTabBar(
                  unselectedBackgroundColor: Colors.white,
                  borderWidth: 0,
                  unselectedBorderColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.pinkAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  tabs: const [
                    Tab(text: "Suggested"),
                    Tab(text: "Saved"),
                  ],
                ),

                const SizedBox(height: 12),

                // "Your previous searches" + "Clear"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Your previous searches",
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: "Gilroy-Bold",
                    ),
                    GestureDetector(
                      onTap: () {
                        _clearSearchHistory();
                      },
                      child: CustomText(
                        text: "Clear",
                        color: const Color(0xff815BFF),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Gilroy-Bold",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Display previous searches as chips
                _searchChips.isNotEmpty
                    ? Wrap(
                  spacing: 8,
                  children: _searchChips
                      .map((chip) => _buildRemovableChip(chip))
                      .toList(),
                )
                    : const Center(child: Text("No search history")),

                const SizedBox(height: 12),

                // Show products only if searching
                if (_isSearching) _productListView(_filteredProducts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds removable search history chips
  Widget _buildRemovableChip(String chipText) {
    return Chip(
      label: Text(chipText),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () async {
        setState(() {
          _searchChips.remove(chipText);
        });
        await _saveSearchHistory();
      },
    );
  }

  /// Builds the product list based on search query
  Widget _productListView(List<ProductEntity> products) {
    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return ListTile(
            leading: Image.network(
              product.images?.isNotEmpty == true
                  ? product.images!.first
                  : 'assets/default_image.png',
              height: 40,
              width: 40,
              fit: BoxFit.cover,
            ),
            title: Text(product.title ?? 'Unknown Product'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
