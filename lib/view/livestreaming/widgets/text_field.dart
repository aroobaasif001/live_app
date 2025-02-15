import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSend;
  final TextEditingController chatController;
  final FocusNode focusNode;

  const ChatInputField({
    Key? key,
    required this.onSend,
    required this.chatController,
    required this.focusNode,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool showEmojiPicker = false;

  void toggleEmojiPicker() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });

    if (showEmojiPicker) {
      widget.focusNode.unfocus(); // Close keyboard when emoji picker opens
      showEmojiBottomSheet();
    }
  }

  void showEmojiBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              widget.chatController.text += emoji.emoji;
              setState(() {});
            },
          ),
        );
      },
    ).then((_) {
      setState(() {
        showEmojiPicker = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Emoji Button
          IconButton(
            onPressed: toggleEmojiPicker,
            icon: Icon(Icons.emoji_emotions, color: Colors.yellow),
          ),

          // TextField (expands properly)
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (showEmojiPicker) {
                  setState(() {
                    showEmojiPicker = false;
                  });
                }
                widget.focusNode.requestFocus(); // Ensure focus on tap
              },
              child: TextField(
                controller: widget.chatController,
                focusNode: widget.focusNode,
                maxLines: 1, // Fixed height
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Send Button
          IconButton(
            onPressed: () {
              if (widget.chatController.text.trim().isNotEmpty) {
                widget.onSend(widget.chatController.text);
                widget.chatController.clear();
                widget.focusNode.unfocus();
              }
            },
            icon: Icon(Icons.send, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
