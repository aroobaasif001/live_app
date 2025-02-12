import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_text.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String selectedOption;
  final Function(String) onChanged;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: CustomText(text: title),
          trailing: GestureDetector(
            onTap: () => onChanged(title),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selectedOption == title
                    ? LinearGradient(
                  colors: [Color(0xff60C0FF), Color(0xffE356D7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                border: Border.all(
                  color: selectedOption == title ? Colors.transparent : Colors.grey,
                ),
              ),
              child: Center(
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: selectedOption == title
                            ? LinearGradient(
                          colors: [Color(0xff60C0FF), Color(0xffE356D7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black12, height: 1),
      ],
    );
  }
}