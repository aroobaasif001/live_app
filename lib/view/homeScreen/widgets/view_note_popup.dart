import 'package:flutter/material.dart';

import '../../../custom_widgets/custom_text.dart';

class ViewNoteButton extends StatelessWidget {
  static void showNotePopup(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 150,
        left: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xffEFE7B1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "View Note",
                      style: TextStyle(
                          fontFamily: 'SFProRounded',
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    IconButton(
                      icon: Icon(Icons.minimize, color: Colors.black),
                      onPressed: () {
                        overlayEntry.remove();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  child: CustomText(text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Amet sapien fringilla, mattis ligula consectetur, ultrices mauris.\n\n"
                    "Maecenas vitae mattis tellus. Nullam quis imperdiet augue. "
                    "Vestibulum auctor ornare leo, non suscipit magna interdum eu.\n\n"
                    "Sodales sodales. Quisque sagittis orci ut diam condimentum, "
                    "vel euismod erat placerat. In iaculis arcu eros, eget tempus orci facilisis id. "
                    "Praesent lorem orci, mattis non efficitur id, ultricies vel nibh. Sed.",
                   fontSize: 14, 
                   fontFamily: 'Gilroy-Bold',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showNotePopup(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.yellow.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          "View Note",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
