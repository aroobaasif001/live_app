import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .6,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      //padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        // Transparent or slightly translucent background
      //  color: Colors.black.withOpacity(0.2),
        // Rounded border
        borderRadius: BorderRadius.circular(30),
        // White border with some opacity
        border: Border.all(color: Colors.white54, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.focusNode.requestFocus(); // Ensure focus on tap
              },
              child: TextField(
                controller: widget.chatController,
                focusNode: widget.focusNode,
                maxLines: 1,
                // Keep the field at a single line
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: Colors.white54),
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
              if (widget.chatController.text
                  .trim()
                  .isNotEmpty) {
                widget.onSend(widget.chatController.text);
                widget.chatController.clear();
                widget.focusNode.unfocus();
              }
            },
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
