import 'package:flutter/material.dart';

import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/custom_widgets/custom_gradient_button.dart';
import 'package:live_app/custom_widgets/custom_table.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

import '../product_detail/tabs/seller_information_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? productImage;
  final String? productPrice;
  final String? productName;
  final String? productCompanyId;
  final String? productDescription;

  ProductDetailScreen(
      {this.productImage,
      this.productPrice,
      this.productDescription,
      this.productName,
      this.productCompanyId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 400.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background:Image.network(
                    widget.productImage.toString(),
                    // Replace with actual image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'About the product'),
                      Tab(text: 'Seller Information'),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildProductDetails(widget.productPrice),
              SellerInformationScreen(
                sellerProfileId:widget.productCompanyId,
              ),
              // _buildSellerInformation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(String? productPrice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          CustomTable(leftText: 'Selling price', rightText: '${productPrice} ₽'),
          CustomTable(leftText: 'Type of sale', rightText: 'Auction'),
          CustomTable(leftText: 'Buyer', rightText: 'company_name'),
          CustomTable(leftText: 'Salesman', rightText: 'usernickname'),
          CustomTable(
              leftText: 'Date of sale', rightText: 'September 25, 2022'),
          SizedBox(height: 20),
          CustomText(
            text:
                """Min: 2000 ₽, Max - 35000 ₽, Avg - 4048 ₽ AT THE GRAND GAME SHOW
-48 SEATS-EVERYTHING FROM 1 DOLLAR-NINTENDO SWITCH SET WORTH \$300 (CONSOLE, GAMES AND MORE)-NINTENDO SWITCH, PLAYSTATION 4/5, FOR XBOX-THERE WILL BE A TON OF BUFFERS FOR THOSE OF YOU WHO RECEIVED A GAME THAT WAS NOT INTERESTING TO THEM.
Rules-48 WHITE BOXES WILL APPEAR ON THE SCREEN-A TOTAL OF 48 AUCTIONS WILL BE HELD, EACH OF WHICH STARTS AT ONLY \$1-WINNING AN AUCTION WILL GIVE YOU ACCESS TO CHOOSE 1 OF THE 48 WHITE BOXES-YOUR NAME WILL BE INDICATED IN THE BOX YOU CHOSEN-IN THE END, THERE ARE 48 AUCTIONS WE WILL OPEN IN ORDER OF PURCHASE-CLIENT NAMES WILL BE CLEARLY STATED BEFORE THE BOXES ARE OPENED-THE GRAND PRIZE WILL CONTAIN A SPECIAL JOKER INSIDE IS THERE A PLAYING CARD? THE SELLER IS ALWAYS HAPPY TO EXPLAIN THE RULES OF THE GAME""",
          ),
          SizedBox(height: 20),
          _buildProtectionSection(),
          SizedBox(height: 20),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildSellerInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          SizedBox(height: 20),
          CustomText(
            text: "Seller: Company XYZ",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          CustomText(
            text: "Contact: seller@companyxyz.com",
            fontSize: 16,
          ),
          SizedBox(height: 10),
          CustomText(
            text: "Location: New York, USA",
            fontSize: 16,
          ),
          SizedBox(height: 20),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildProtectionSection() {
    return CustomContainer(
      padding: EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(8),
      conColor: Colors.grey[200],
      child: Row(
        children: [
          Icon(Icons.security, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: CustomText(
              text: 'Buyer protection details...',
              color: Colors.grey,
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return CustomGradientButton(
      text: 'Report Abuse',
      onPressed: () {},
      width: double.infinity,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
