import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = "All";

  List<ChartData> chartData = [
    ChartData('19.01', 100000),
    ChartData('25.01', 200000),
    ChartData('30.01', 750000),
    ChartData('10.01', 300000),
    ChartData('15.01', 400000),
    ChartData('30.01', 1000000),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          indicatorSize:TabBarIndicatorSize.tab,
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.blue,
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

  Widget _buildStatisticsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Seller Analytics',
            subtitle: '19 Jan 2025 - 30 Feb 2025',
            buttonText: 'Change',
          ),
          const SizedBox(height: 16),
          _buildChartCard(),
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String title, required String subtitle, required String buttonText}) {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(50, 30), // Small button
            ),
            onPressed: () {},
            child: const Text(
                "Change", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }


  Widget _buildChartCard() {
    return Container(
      width: double.infinity, // Full width
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      .map((String choice) =>
                      PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      ))
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
                  ].map((String choice) =>
                      PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      ))
                      .toList();
                },
                child: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <CartesianSeries<ChartData, String>>[
                LineSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  color: Colors.blue,
                  markerSettings: const MarkerSettings(isVisible: true),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStreamsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCard(
            title: 'Stream Title',
            subtitle: '04.02.2025, 02:07',
            buttonText: 'Change',
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildListTile('Sales', '10,000 ₽'),
                _buildListTile('Revenue', '10,000 ₽'),
                _buildListTile('Orders', '10,000 ₽'),
                _buildListTile('Average order value', '10,000 ₽'),
                _buildListTile('Buyers', '10,000 ₽'),
                _buildListTile('First buyers', '10,000 ₽'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
              value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

}

  class ChartData {
  final String label;
  final double value;

  ChartData(this.label, this.value);
}


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
