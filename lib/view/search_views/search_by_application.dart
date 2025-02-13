import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import '../../custom_widgets/custom_text.dart';
import '../../utils/icons_path.dart';

class SearchByApplication extends StatefulWidget {
  const SearchByApplication({super.key});

  @override
  State<SearchByApplication> createState() => _SearchByApplicationState();
}

class _SearchByApplicationState extends State<SearchByApplication> {
  // Store your search chips here so we can remove them dynamically
  final List<String> _searchChips = ["Electronics", "Iphone"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  // Top Search Row
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
                          child: const TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search by application",
                              prefixIcon: Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      CustomText(
                        text: "Cancel",
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Gilroy-Bold",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // "Suggested" / "Saved" Tab Buttons with gradient
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
                      CustomText(
                        text: "Clear",
                        color: Color(0xff815BFF),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: "Gilroy-Bold",
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Dynamically build chips from _searchChips list
                  Row(
                    children: _searchChips.map((chip) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _buildRemovableChip(chip),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // "Previously viewed users"
                  CustomText(
                    text: "Previously viewed users",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: "Gilroy-Bold",
                  ),
                  const SizedBox(height: 15),
                  // List of users
                  _userListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds each chip with a close icon to remove it from _searchChips
  Widget _buildRemovableChip(String chipText) {
    return Container(
      height: 35,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      // Center the text/icon row
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(chipText),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchChips.remove(chipText);
                });
              },
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userListView() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4, // Show 4 users to match the screenshot
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Apple icon
              Image.asset(
                appleIcon,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              // company_name + subscriber count
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'company_name',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Gilroy-Bold",
                  ),
                  CustomText(
                    color: const Color(0xff8C8C8C),
                    fontSize: 14,
                    fontFamily: "Gilroy-Bold",
                    text: '15.7K subscribers',
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

