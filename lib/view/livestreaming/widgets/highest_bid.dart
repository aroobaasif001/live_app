import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HighestBidDisplay extends StatelessWidget {
  final String channelId;

  const HighestBidDisplay({Key? key, required this.channelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('livestreams')
          .doc(channelId)
          .snapshots(),
      builder: (context, livestreamSnapshot) {
        if (livestreamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (livestreamSnapshot.hasError) {
          return Text('Error: ${livestreamSnapshot.error}');
        }

        if (!livestreamSnapshot.hasData || !livestreamSnapshot.data!.exists) {
          return const Center(child: Text('No livestream found.'));
        }

        // Get the livestream data
        final livestreamData = livestreamSnapshot.data!.data() as Map<String, dynamic>?;
        if (livestreamData == null) {
          return const Center(child: Text('No data found.'));
        }

        // Listen to the comments subcollection
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('livestreams')
              .doc(channelId)
              .collection('comments')
              .where('message', isGreaterThanOrEqualTo: 'Set Bid')
              .snapshots(),
          builder: (context, commentsSnapshot) {
            if (commentsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (commentsSnapshot.hasError) {
              return Text('Error: ${commentsSnapshot.error}');
            }

            if (!commentsSnapshot.hasData || commentsSnapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No bid comments found.'));
            }

            // Filter and find the highest bid
            double highestBid = 0;
            Map<String, dynamic>? highestBidder;

            for (var commentDoc in commentsSnapshot.data!.docs) {
              final message = commentDoc['message'] as String?;
              final bid = double.tryParse(commentDoc['message']?.split(' ').last ?? '0') ?? 0.0;

              // If the message contains "Set Bid" and the bid is higher than the current highest, update
              if (message != null && message.contains('Set Bid') && bid > highestBid) {
                highestBid = bid;
                highestBidder = {
                  'userName': commentDoc['user'],
                  'userPhoto': commentDoc['photo'],
                  'message': message,
                  'bid': bid,
                };
              }
            }

            // If a highest bidder is found, display the bid
            if (highestBidder != null) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.purple , ),
                child: MarqueeText(
                  text: ' ${highestBidder['userName']} -  ${highestBidder['message']}',
                  userPhoto: highestBidder['userPhoto'],
                ),
              );
            } else {
              return const Center(child: Text('No bids found.'));
            }
          },
        );
      },
    );
  }
}

class MarqueeText extends StatelessWidget {
  final String text;
  final String userPhoto;

  const MarqueeText({Key? key, required this.text, required this.userPhoto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MarqueeLoopingText(
          text: text,
          userPhoto: userPhoto,
          screenWidth: constraints.maxWidth,
        );
      },
    );
  }
}

class MarqueeLoopingText extends StatefulWidget {
  final String text;
  final String userPhoto;
  final double screenWidth;

  const MarqueeLoopingText({Key? key, required this.text, required this.userPhoto, required this.screenWidth}) : super(key: key);

  @override
  _MarqueeLoopingTextState createState() => _MarqueeLoopingTextState();
}

class _MarqueeLoopingTextState extends State<MarqueeLoopingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create the animation controller
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    // Define the tween to move the content from right to left
    _animation = Tween<double>(
      begin: widget.screenWidth,
      end: -widget.screenWidth,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    // Start the animation when the widget is initialized
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // User photo (Avatar)
              // if (widget.userPhoto.isNotEmpty)
              //   CircleAvatar(
              //     backgroundImage: NetworkImage(widget.userPhoto),
              //   ),
              SizedBox(width: 10),
              // Scrolling text (Bid and Message)
              Transform.translate(
                offset: Offset(_animation.value, 0),
                child: Text(
                  widget.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 , color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
