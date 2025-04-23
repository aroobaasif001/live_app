import 'dart:math';

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
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x: point.y ₽');
    fetchChartData();
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
      fetchChartData();
    }
  }

// Make sure this is imported at the top

  Future<void> fetchChartData() async {
    setState(() => isChartLoading = true);

    await Future.delayed(Duration(milliseconds: 500)); // simulate network delay

    final random = Random();
    final labels = ['10.01', '15.01', '19.01', '25.01', '30.01', '05.02'];

    // Adjust values based on selected category
    double multiplier;
    switch (selectedCategory) {
      case 'Marketplaces':
        multiplier = 1.0;
        break;
      case 'Auctions':
        multiplier = 1.5;
        break;
      default: // 'All'
        multiplier = 1.2;
    }

    chartData = labels.map((label) {
      return ChartData(
        label,
        (random.nextInt(700000) + 50000) * multiplier,
      );
    }).toList();

    setState(() => isChartLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade100,
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
          _buildCard(
            title: 'Seller Analytics',
            subtitle: _selectedDateRange == null
    ? '04.02.2025, 02:07'
    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool isChartLoading = false;

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
                color: Colors.white,
                onSelected: (String value) {
                  // Handle selection if needed
                },
                itemBuilder: (BuildContext context) {
                  // Define the menu choices
                  final List<String> choices = [
                    'Current Avg. Order Cost',
                    'Buyer Shares',
                    'Number of Buyers',
                    'Customer Recommendations',
                    'Subscribed',
                    'Number of Views',
                    'Max Viewers',
                    'Broadcast Time'
                  ];

                  // Build the list of PopupMenuEntry items
                  List<PopupMenuEntry<String>> menuItems = [];

                  for (int i = 0; i < choices.length; i++) {
                    // Add the menu item
                    menuItems.add(
                      PopupMenuItem<String>(
                        value: choices[i],
                        child: Text(choices[i]),
                      ),
                    );

                    if (i < choices.length - 1) {
                      menuItems.add(const PopupMenuDivider());
                    }
                  }
                  return menuItems;
                },
                child: const Row(
                  children: [
                    Text('More', style: TextStyle(fontSize: 14)),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          // The chart with tooltips
          // SizedBox(
          //   height: 300,
          //   child: SfCartesianChart(
          //     tooltipBehavior: _tooltipBehavior,
          //     primaryXAxis: CategoryAxis(),
          //     primaryYAxis: NumericAxis(
          //       labelFormat: '{value}₽',
          //     ),
          //     series: <CartesianSeries<ChartData, String>>[
          //       LineSeries<ChartData, String>(
          //         dataSource: chartData,
          //         xValueMapper: (ChartData data, _) => data.label,
          //         yValueMapper: (ChartData data, _) => data.value,
          //         color: Colors.blue,
          //         markerSettings: const MarkerSettings(isVisible: true),
          //         enableTooltip: true,
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(
            height: 300,
            child: isChartLoading
                ? const Center(child: CircularProgressIndicator())
                : SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(labelFormat: '{value}₽'),
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
     final random = Random();
  Widget _buildStreamsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Stream Title',
            subtitle: _selectedDateRange == null
    ? '04.02.2025, 02:07'
    : '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}',
            buttonText: 'Change',
            onButtonPressed: () async {
              final now = DateTime.now();
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 2),
                lastDate: DateTime(now.year + 1),
                initialDateRange: _selectedDateRange ??
                    DateTimeRange(
                      start: DateTime(2025, 1, 19),
                      end: DateTime(2025, 2, 28),
                    ),
              );

              if (picked != null) {
                setState(() {
                  _selectedDateRange = picked;
                });

                // Optional: refresh or simulate fetch
                await fetchChartData();
              }
            },
          ),
          const SizedBox(height: 16),
          // Scrollable list of stats
          Expanded(
            child: ListView(
              children: [
             
_buildListTile('Orders', '${random.nextInt(150) + 50}', info: 'Orders placed during stream.'),

                _buildListTile('Sales', '10,000 ₽', info: 'Sales info here.'),
                _buildListTile('Revenue', '10,000 ₽',
                    info: 'Revenue info here.'),
                _buildListTile('Orders', '10,000 ₽', info: 'Orders info here.'),
                _buildListTile('Average order value', '10,000 ₽',
                    info: 'Avg order info here.'),
                _buildListTile('Buyers', '10,000 ₽', info: 'Buyers info here.'),
                _buildListTile('First buyers', '10,000 ₽',
                    info: 'First buyers info here.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A small reusable tile for stream stats with an "i" icon for info.
  // Widget _buildListTile(String title, String value, {String? info}) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.05),
  //             blurRadius: 4,
  //             spreadRadius: 1,
  //           ),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 10),
  //         child: ListTile(
  //           title: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(title,
  //                   style: const TextStyle(fontWeight: FontWeight.bold)),
  //               Text(value,
  //                   style: const TextStyle(fontWeight: FontWeight.bold)),
  //             ],
  //           ),
  //           trailing: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               // Info icon
  //               Tooltip(
  //                 message: info ?? '',
  //                 child:
  //                     const Icon(Icons.info_outline, color: Colors.blueAccent),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          trailing: info != null && info.trim().isNotEmpty
              ? Tooltip(
                  message: info,
                  preferBelow: false,
                  waitDuration: Duration(milliseconds: 500),
                  showDuration: Duration(seconds: 3),
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                    onPressed: () {
                      final snack = SnackBar(
                        content: Text(info),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.black87,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    },
                  ),
                )
              : const SizedBox.shrink(),
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
