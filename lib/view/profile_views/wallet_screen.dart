import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabButtons(), // Full-width tabs with color change
            const SizedBox(height: 16),
            Expanded(
              child: _buildCheckTab(), // All data is now inside the "Check" tab
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildWithdrawButton(),
    );
  }

  /// **📌 Full-width Tab Buttons**
  Widget _buildTabButtons() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabButton("Check", 0),
          _buildTabButton("Transactions", 1),
        ],
      ),
    );
  }

  /// **📌 Individual Tab Button with Active/Inactive State**
  Widget _buildTabButton(String text, int index) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Colors.blue, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  /// **✅ Check Tab**
  Widget _buildCheckTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Account Score",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "100,000 ₽",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          _buildBalanceCard(
            iconImage: "assets/icons/withdraw icon.png",
            text: "100,000 ₽ available for withdrawal",
          ),
          const SizedBox(height: 8),
          _buildBalanceCard(
            iconImage: "assets/icons/clock icon.png",
            text: "0 ₽ will be available soon",
          ),
          const SizedBox(height: 24),

          // **Transaction History**
          const Text(
            "Story",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // **Transaction List**
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildTransactionItem();
            },
          ),
        ],
      ),
    );
  }

  /// **📌 Withdraw Money Button (Opens Modal)**
  Widget _buildWithdrawButton() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          _showWithdrawBottomSheet();
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Colors.transparent,
          ),
          elevation: MaterialStateProperty.resolveWith((states) => 0),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              "Withdraw money",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard({required String iconImage, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Image.asset(
            iconImage,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "-10,000 ₽",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            "Output to MIR **2882",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  void _showWithdrawBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), // Only top-left corner rounded
          topRight: Radius.circular(16), // Only top-right corner rounded
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title + Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Withdraw money",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              // Where? Dropdown / selection
              const Text(
                "Where?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/iPhone 13 mini - 47.png",height: 50,),
                    SizedBox(width: 10,),
                    Text("MIR **2882"),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "How many",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Amount input
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter an amount up to 100,000 ₽",
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Continue Button with gradient background
              Container(
                height: 70,
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close current sheet
                    _showConfirmationBottomSheet(
                        context); // Show confirmation sheet
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // We make the button background and shadow transparent,
                    // then create the gradient in the Ink decoration below
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.transparent,
                    ),
                    elevation: MaterialStateProperty.resolveWith((states) => 0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///
  // void _showWithdrawBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(16), // Only top-left corner rounded
  //         topRight: Radius.circular(16), // Only top-right corner rounded
  //       ),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header with Title and Close Button
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   "Withdraw money",
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () => Navigator.pop(context),
  //                 ),
  //               ],
  //             ),
  //             const Divider(),
  //
  //             // Withdrawal Method (Dropdown)
  //             const Text("Where?", style: TextStyle(fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 8),
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[100],
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: const Text("MIR **2882"),
  //             ),
  //
  //             const SizedBox(height: 16),
  //             const Text("How many", style: TextStyle(fontWeight: FontWeight.bold)),
  //             const SizedBox(height: 8),
  //
  //             // Input Field for Amount
  //             TextField(
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //                 hintText: "Enter an amount up to 100,000 ₽",
  //                 filled: true,
  //                 fillColor: Colors.grey[100],
  //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //               ),
  //             ),
  //
  //             const SizedBox(height: 16),
  //
  //             // Continue Button
  //             Container(
  //               height: 70,
  //               margin: const EdgeInsets.all(16),
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Navigator.pop(context); // Close current sheet
  //                   _showConfirmationBottomSheet(); // Show confirmation sheet
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: const EdgeInsets.symmetric(vertical: 14),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   backgroundColor: Colors.transparent,
  //                   shadowColor: Colors.transparent,
  //                 ).copyWith(
  //                   backgroundColor: MaterialStateProperty.resolveWith(
  //                         (states) => Colors.transparent,
  //                   ),
  //                   elevation: MaterialStateProperty.resolveWith((states) => 0),
  //                 ),
  //                 child: Ink(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     gradient: const LinearGradient(
  //                       colors: [Colors.blue, Colors.purpleAccent],
  //                       begin: Alignment.topLeft,
  //                       end: Alignment.bottomRight,
  //                     ),
  //                   ),
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     padding: const EdgeInsets.symmetric(vertical: 12),
  //                     child: const Text(
  //                       "Continue",
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  /// **📌 Confirmation Bottom Sheet**
  void _showConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), // Only top-left corner rounded
          topRight: Radius.circular(16), // Only top-right corner rounded
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            // Minimize the column’s height so it fits the content.
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Success Icon
              Image.asset("assets/icons/success icon.png",height: 60,),
              const SizedBox(height: 16),

              // Amount Withdrawn
              const Text(
                "10,000 ₽",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Gradient Text (Pending Confirmation)
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.blue, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child:  Text(
                  "Will appear on your\naccount soon!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Overridden by the gradient mask
                  ),
                  textAlign:TextAlign.center ,
                ),
              ),

              const SizedBox(height: 16),

              // Close Button with Gradient Background
              Container(
                height: 80,
                margin: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.transparent),
                    elevation: MaterialStateProperty.resolveWith((states) => 0),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.purpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        "Okay",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    // void _showConfirmationBottomSheet() {
    //   showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(16), // Only top-left corner rounded
    //         topRight: Radius.circular(16), // Only top-right corner rounded
    //       ),
    //     ),
    //     builder: (context) {
    //       return Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             const SizedBox(height: 16),
    //
    //             // Success Icon
    //             const CircleAvatar(
    //               radius: 30,
    //               backgroundColor: Colors.greenAccent,
    //               child: Icon(Icons.check, color: Colors.white, size: 30),
    //             ),
    //             const SizedBox(height: 16),
    //
    //             // Amount Withdrawn
    //             const Text(
    //               "10,000 ₽",
    //               style: TextStyle(
    //                 fontSize: 24,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black,
    //               ),
    //             ),
    //             const SizedBox(height: 8),
    //
    //             // Gradient Text (Pending Confirmation)
    //             ShaderMask(
    //               shaderCallback: (bounds) => const LinearGradient(
    //                 colors: [Colors.blue, Colors.purpleAccent],
    //                 begin: Alignment.topLeft,
    //                 end: Alignment.bottomRight,
    //               ).createShader(bounds),
    //               child: const Text(
    //                 "Will appear on your account soon!",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white, // Masked by gradient
    //                 ),
    //               ),
    //             ),
    //
    //             const SizedBox(height: 16),
    //
    //             Container(
    //               height: 70,
    //               margin: const EdgeInsets.all(16),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   padding: const EdgeInsets.symmetric(vertical: 14),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   backgroundColor: Colors.transparent,
    //                   shadowColor: Colors.transparent,
    //                 ).copyWith(
    //                   backgroundColor: MaterialStateProperty.resolveWith(
    //                         (states) => Colors.transparent,
    //                   ),
    //                   elevation: MaterialStateProperty.resolveWith((states) => 0),
    //                 ),
    //                 child: Ink(
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8),
    //                     gradient: const LinearGradient(
    //                       colors: [Colors.blue, Colors.purpleAccent],
    //                       begin: Alignment.topLeft,
    //                       end: Alignment.bottomRight,
    //                     ),
    //                   ),
    //                   child: Container(
    //                     alignment: Alignment.center,
    //                     padding: const EdgeInsets.symmetric(vertical: 12),
    //                     child: const Text(
    //                       "Close",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 16),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }

    /// **📌 Withdraw Bottom Sheet**
    // void _showWithdrawBottomSheet() {
    //   showModalBottomSheet(
    //     context: context,
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(16), // Only top-left corner rounded
    //         topRight: Radius.circular(16), // Only top-right corner rounded
    //       ),
    //     ),
    //     builder: (context) {
    //       return Padding(
    //         padding: const EdgeInsets.all(16),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // Header with Title and Close Button
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 const Text(
    //                   "Withdraw money",
    //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //                 ),
    //                 IconButton(
    //                   icon: const Icon(Icons.close),
    //                   onPressed: () => Navigator.pop(context),
    //                 ),
    //               ],
    //             ),
    //             const Divider(),
    //
    //             // Withdrawal Method (Dropdown)
    //             const Text("Where?", style: TextStyle(fontWeight: FontWeight.bold)),
    //             const SizedBox(height: 8),
    //             Container(
    //               padding: const EdgeInsets.all(12),
    //               decoration: BoxDecoration(
    //                 color: Colors.grey[100],
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //               child: const Text("MIR **2882"),
    //             ),
    //
    //             const SizedBox(height: 16),
    //             const Text("How many", style: TextStyle(fontWeight: FontWeight.bold)),
    //             const SizedBox(height: 8),
    //
    //             // Input Field for Amount
    //             TextField(
    //               keyboardType: TextInputType.number,
    //               decoration: InputDecoration(
    //                 hintText: "Enter an amount up to 100,000 ₽",
    //                 filled: true,
    //                 fillColor: Colors.grey[100],
    //                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    //               ),
    //             ),
    //
    //             const SizedBox(height: 16),
    //             Container(
    //               height: 70,
    //               margin: const EdgeInsets.all(16),
    //               child: ElevatedButton(
    //                 onPressed: () {
    //                 },
    //                 style: ElevatedButton.styleFrom(
    //                   padding: const EdgeInsets.symmetric(vertical: 14),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   backgroundColor: Colors.transparent,
    //                   shadowColor: Colors.transparent,
    //                 ).copyWith(
    //                   backgroundColor: MaterialStateProperty.resolveWith(
    //                         (states) => Colors.transparent,
    //                   ),
    //                   elevation: MaterialStateProperty.resolveWith((states) => 0),
    //                 ),
    //                 child: Ink(
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8),
    //                     gradient: const LinearGradient(
    //                       colors: [Colors.blue, Colors.purpleAccent],
    //                       begin: Alignment.topLeft,
    //                       end: Alignment.bottomRight,
    //                     ),
    //                   ),
    //                   child: Container(
    //                     alignment: Alignment.center,
    //                     padding: const EdgeInsets.symmetric(vertical: 12),
    //                     child: const Text(
    //                       "Continue",
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.white,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }
  }
}

///

// import 'package:flutter/material.dart';
//
// class WalletScreen extends StatefulWidget {
//   const WalletScreen({super.key});
//
//   @override
//   State<WalletScreen> createState() => _WalletScreenState();
// }
//
// class _WalletScreenState extends State<WalletScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _selectedIndex = 0; // Track selected tab index
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedIndex =
//             _tabController.index; // Update selected index on change
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Wallet",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildTabButtons(), // Full-width tabs with color change
//             const SizedBox(height: 16),
//             Expanded(
//               child: _buildCheckTab(), // All data is now inside the "Check" tab
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildWithdrawButton(),
//     );
//   }
//
//   /// **📌 Full-width Tab Buttons**
//   Widget _buildTabButtons() {
//     return Container(
//       width: double.infinity,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           _buildTabButton("Check", 0),
//           _buildTabButton("Transactions", 1), // Still present but does nothing
//         ],
//       ),
//     );
//   }
//
//   /// **📌 Individual Tab Button with Active/Inactive State**
//   Widget _buildTabButton(String text, int index) {
//     bool isSelected = _selectedIndex == index;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           _tabController.animateTo(index);
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: isSelected
//                 ? const LinearGradient(
//                     colors: [Colors.blue, Colors.purpleAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   )
//                 : null,
//             color: isSelected ? null : Colors.transparent,
//           ),
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isSelected ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// **✅ Check Tab (Now Contains All Data)**
//   Widget _buildCheckTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Account Score",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black54,
//             ),
//           ),
//           const SizedBox(height: 4),
//           const Text(
//             "100,000 ₽",
//             style: TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 16),
//
//           _buildBalanceCard(
//             icon: Icons.account_balance_wallet_outlined,
//             text: "100,000 ₽ available for withdrawal",
//           ),
//           const SizedBox(height: 8),
//           _buildBalanceCard(
//             icon: Icons.access_time,
//             text: "0 ₽ will be available soon",
//           ),
//           const SizedBox(height: 24),
//
//           // **Transaction History**
//           const Text(
//             "Story",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const SizedBox(height: 8),
//
//           // **Transaction List**
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 16,
//             itemBuilder: (context, index) {
//               return _buildTransactionItem();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// **📌 Balance Info Card**
//   Widget _buildBalanceCard({required IconData icon, required String text}) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.black54, size: 20),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// **📌 Transaction History Item**
//   Widget _buildTransactionItem() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             "-10,000 ₽",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           const Text(
//             "Output to MIR **2882",
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black54,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// **📌 Withdraw Money Button**
//   Widget _buildWithdrawButton() {
//     return Container(
//       height: 70,
//       margin: const EdgeInsets.all(16),
//       child: ElevatedButton(
//         onPressed: () {
//           // Withdraw logic here
//         },
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 14),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//         ).copyWith(
//           backgroundColor: MaterialStateProperty.resolveWith(
//             (states) => Colors.transparent,
//           ),
//           elevation: MaterialStateProperty.resolveWith((states) => 0),
//         ),
//         child: Ink(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             gradient: const LinearGradient(
//               colors: [Colors.blue, Colors.purpleAccent],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.symmetric(vertical: 12),
//             child: const Text(
//               "Withdraw money",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
