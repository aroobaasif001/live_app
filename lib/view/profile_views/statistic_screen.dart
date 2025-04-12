import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TooltipBehavior _tooltipBehavior;

  /// Tracks the currently selected date range (for demonstration).
  DateTimeRange? _selectedDateRange;

  /// Popup filter category (All, Marketplaces, Auctions).
  String selectedCategory = "All";

  /// Sample data for the chart, reordered chronologically.
  List<ChartData> chartData = [
    ChartData('10.01', 300000),
    ChartData('15.01', 400000),
    ChartData('19.01', 100000),
    ChartData('25.01', 200000),
    ChartData('30.01', 750000),
    ChartData('05.02', 1000000),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Enable tooltips so tapping a data point shows its info.
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      // Customize the tooltip display
      format: 'point.x: point.y ₽',
      // You could also show marker in the tooltip if desired
      canShowMarker: true,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Opens a date range picker when the user taps "Change".
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      // Adjust these dates based on your actual limits
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: DateTimeRange(
        start: DateTime(2025, 1, 19),
        end: DateTime(2025, 2, 28), // Example: 19 Jan - 28 Feb 2025
      ),
    );

    if (range != null) {
      setState(() {
        _selectedDateRange = range;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Streams'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatisticsTab(),
          _buildStreamsTab(),
        ],
      ),
    );
  }

  /// "All" tab content: Seller analytics card + chart
  Widget _buildStatisticsTab() {
    final dateRangeText = _selectedDateRange == null
        ? '19 Jan 2025 - 28 Feb 2025'
        : '${_formatDate(_selectedDateRange!.start)} - '
        '${_formatDate(_selectedDateRange!.end)}';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // First card with Seller Analytics, date range, and "Change" button
          _buildCard(
            title: 'Seller Analytics',
            subtitle: dateRangeText,
            buttonText: 'Change',
            onButtonPressed: _pickDateRange,
          ),
          const SizedBox(height: 16),
          // Second card: Brought sales + chart
          _buildChartCard(),
        ],
      ),
    );
  }

  /// A reusable card widget for the top section (Seller Analytics).
  Widget _buildCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(50, 30),
                ),
                onPressed: onButtonPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.arrow_back_ios,size: 18,),
              SizedBox(width: 10,),
              Icon(Icons.arrow_forward_ios,size: 18,),
            ],
          ),

        ],
      ),
    );
  }

  /// Displays a chart card with "100,000 ₽" text and "Brought sales" label
  /// plus the line chart of sales over time.
  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount & label (like "100,000 ₽" and "Brought sales")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "100,000 ₽",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Brought sales",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Row with a dropdown for category and a "More" button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return ['All', 'Marketplaces', 'Auctions']
                      .map(
                        (String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ),
                  )
                      .toList();
                },
                child: Row(
                  children: [
                    Text(
                      selectedCategory,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // Handle selection if needed
                },
                itemBuilder: (BuildContext context) {
                  return [
                    'Current Avg. Order Cost',
                    'Buyer Shares',
                    'Number of Buyers',
                    'Customer Recommendations',
                    'Subscribed',
                    'Number of Views',
                    'Max Viewers',
                    'Broadcast Time'
                  ].map(
                        (String choice) => PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    ),
                  ).toList();
                },
                child: const Row(
                  children: [
                    Text('More', style: TextStyle(fontSize: 14)),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // The chart with tooltips
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              tooltipBehavior: _tooltipBehavior,
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                labelFormat: '{value}₽',
              ),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.blue,
                  markerSettings: const MarkerSettings(isVisible: true),
                  enableTooltip: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Second tab: streams summary
  Widget _buildStreamsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Stream Title',
            subtitle: '04.02.2025, 02:07',
            buttonText: 'Change',
            onButtonPressed: () {
              // Add your "Change" logic here for Streams if needed
              debugPrint("Change tapped in Streams tab");
            },
          ),
          const SizedBox(height: 16),
          // Scrollable list of stats
          Expanded(
            child: ListView(
              children: [
                _buildListTile('Sales', '10,000 ₽', info: 'Sales info here.'),
                _buildListTile('Revenue', '10,000 ₽', info: 'Revenue info here.'),
                _buildListTile('Orders', '10,000 ₽', info: 'Orders info here.'),
                _buildListTile('Average order value', '10,000 ₽', info: 'Avg order info here.'),
                _buildListTile('Buyers', '10,000 ₽', info: 'Buyers info here.'),
                _buildListTile('First buyers', '10,000 ₽', info: 'First buyers info here.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A small reusable tile for stream stats with an "i" icon for info.
  Widget _buildListTile(String title, String value, {String? info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Info icon
              Tooltip(
                message: info ?? '',
                child: const Icon(Icons.info_outline, color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: Formats DateTime to 'dd.MM.yyyy'
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}

/// Data model class for the line chart
class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}

/// ///

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class StatisticsScreen extends StatefulWidget {
//   @override
//   _StatisticsScreenState createState() => _StatisticsScreenState();
// }
//
// class _StatisticsScreenState extends State<StatisticsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String selectedCategory = "All";
//
//   List<ChartData> chartData = [
//     ChartData('19.01', 100000),
//     ChartData('25.01', 200000),
//     ChartData('30.01', 750000),
//     ChartData('10.01', 300000),
//     ChartData('15.01', 400000),
//     ChartData('30.01', 1000000),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Statistics',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         bottom: TabBar(
//           indicatorSize:TabBarIndicatorSize.tab,
//           controller: _tabController,
//           labelColor: Colors.black,
//           indicatorColor: Colors.blue,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Streams'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildStatisticsTab(),
//           _buildStreamsTab(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatisticsTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildCard(
//             title: 'Seller Analytics',
//             subtitle: '19 Jan 2025 - 30 Feb 2025',
//             buttonText: 'Change',
//           ),
//           const SizedBox(height: 16),
//           _buildChartCard(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard(
//       {required String title, required String subtitle, required String buttonText}) {
//     return Container(
//       width: double.infinity, // Full width
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: const TextStyle(fontSize: 13, color: Colors.grey),
//               ),
//             ],
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.black,
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8)),
//               minimumSize: const Size(50, 30), // Small button
//             ),
//             onPressed: () {},
//             child: const Text(
//                 "Change", style: TextStyle(color: Colors.white, fontSize: 12)),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildChartCard() {
//     return Container(
//       width: double.infinity, // Full width
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               PopupMenuButton<String>(
//                 onSelected: (String value) {
//                   setState(() {
//                     selectedCategory = value;
//                   });
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return ['All', 'Marketplaces', 'Auctions']
//                       .map((String choice) =>
//                       PopupMenuItem<String>(
//                         value: choice,
//                         child: Text(choice),
//                       ))
//                       .toList();
//                 },
//                 child: Row(
//                   children: [
//                     Text(
//                       selectedCategory,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const Icon(Icons.arrow_drop_down),
//                   ],
//                 ),
//               ),
//               PopupMenuButton<String>(
//                 onSelected: (String value) {
//                   // Handle selection if needed
//                 },
//                 itemBuilder: (BuildContext context) {
//                   return [
//                     'Current Avg. Order Cost',
//                     'Buyer Shares',
//                     'Number of Buyers',
//                     'Customer Recommendations',
//                     'Subscribed',
//                     'Number of Views',
//                     'Max Viewers',
//                     'Broadcast Time'
//                   ].map((String choice) =>
//                       PopupMenuItem<String>(
//                         value: choice,
//                         child: Text(choice),
//                       ))
//                       .toList();
//                 },
//                 child: const Icon(Icons.more_horiz),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 200,
//             child: SfCartesianChart(
//               primaryXAxis: CategoryAxis(),
//               series: <CartesianSeries<ChartData, String>>[
//                 LineSeries<ChartData, String>(
//                   dataSource: chartData,
//                   xValueMapper: (ChartData data, _) => data.label,
//                   yValueMapper: (ChartData data, _) => data.value,
//                   color: Colors.blue,
//                   markerSettings: const MarkerSettings(isVisible: true),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _buildStreamsTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildCard(
//             title: 'Stream Title',
//             subtitle: '04.02.2025, 02:07',
//             buttonText: 'Change',
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               children: [
//                 _buildListTile('Sales', '10,000 ₽'),
//                 _buildListTile('Revenue', '10,000 ₽'),
//                 _buildListTile('Orders', '10,000 ₽'),
//                 _buildListTile('Average order value', '10,000 ₽'),
//                 _buildListTile('Buyers', '10,000 ₽'),
//                 _buildListTile('First buyers', '10,000 ₽'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildListTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: ListTile(
//           title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           trailing: Text(
//               value, style: const TextStyle(fontWeight: FontWeight.bold)),
//         ),
//       ),
//     );
//   }
//
// }
//
//   class ChartData {
//   final String label;
//   final double value;
//
//   ChartData(this.label, this.value);
// }

///

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class StatisticsScreen extends StatefulWidget {
//   @override
//   _StatisticsScreenState createState() => _StatisticsScreenState();
// }
//
// class _StatisticsScreenState extends State<StatisticsScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   List<ChartData> chartData = [
//     ChartData('19.01', 100000),
//     ChartData('25.01', 200000),
//     ChartData('30.01', 750000),
//     ChartData('10.01', 300000),
//     ChartData('15.01', 400000),
//     ChartData('30.01', 1000000),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Statistics',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.black,
//           indicatorColor: Colors.blue,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'Streams'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildStatisticsTab(),
//           _buildStreamsTab(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatisticsTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildCard(
//             title: 'Seller Analytics',
//             subtitle: '19 Jan 2025 - 30 Feb 2025',
//             buttonText: 'Change',
//           ),
//           const SizedBox(height: 16),
//           _buildChartCard(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCard({required String title, required String subtitle, required String buttonText}) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onPressed: () {},
//               child: Text(buttonText, style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildChartCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   '100,000 ₽',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.more_horiz),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 200,
//               child: SfCartesianChart(
//                 primaryXAxis: CategoryAxis(),
//                 series: <CartesianSeries<ChartData, String>>[
//                   LineSeries<ChartData, String>(
//                     dataSource: chartData,
//                     xValueMapper: (ChartData data, _) => data.label,
//                     yValueMapper: (ChartData data, _) => data.value,
//                     color: Colors.blue,
//                     markerSettings: const MarkerSettings(isVisible: true),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStreamsTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildCard(
//             title: 'Stream Title',
//             subtitle: '04.02.2025, 02:07',
//             buttonText: 'Change',
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               children: [
//                 _buildListTile('Sales', '10,000 ₽'),
//                 _buildListTile('Revenue', '10,000 ₽'),
//                 _buildListTile('Orders', '10,000 ₽'),
//                 _buildListTile('Average order value', '10,000 ₽'),
//                 _buildListTile('Buyers', '10,000 ₽'),
//                 _buildListTile('First buyers', '10,000 ₽'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildListTile(String title, String value) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: ListTile(
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }
//
// class ChartData {
//   final String label;
//   final double value;
//
//   ChartData(this.label, this.value);
// }
