import 'package:flutter/material.dart';
import 'package:live_app/custom_widgets/custom_container.dart';
import 'package:live_app/utils/images_path.dart';

class CustomBackgroundScaffold extends StatelessWidget {
  final Widget child;
  const CustomBackgroundScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      image: DecorationImage(image: AssetImage(backgroundScaffoldImage),fit: BoxFit.fill),
      child: child,
    );
  }
}
