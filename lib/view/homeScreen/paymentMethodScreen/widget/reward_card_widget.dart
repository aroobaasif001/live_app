import 'package:flutter/material.dart';


class RewardCard extends StatefulWidget {
  final RewardLevel level;

  RewardCard({required this.level});

  @override
  _RewardCardState createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.level.color.withOpacity(0.5), widget.level.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Level ${widget.level.level}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                 Image.asset('assets/images')
                ],
              ),
              ...widget.level.rewards.map((reward) => Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.white70, size: 16),
                    SizedBox(width: 5),
                    Text("$reward", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              )),
              if (isExpanded && widget.level.progressItems.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.level.progressItems.map((progress) => Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(progress.label, style: TextStyle(color: Colors.white)),
                        SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progress.value / progress.max,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                        Text("${progress.value} from ${progress.max}", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  )).toList(),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class RewardLevel {
  final String level;
  final Color color;
  final List<String> rewards;
  final List<ProgressItem> progressItems;

  RewardLevel({
    required this.level,
    required this.color,
    required this.rewards,
    this.progressItems = const [],
  });
}

class ProgressItem {
  final String label;
  final double value;
  final double max;

  ProgressItem({required this.label, required this.value, required this.max});
}
