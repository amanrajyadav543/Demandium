import 'package:flutter/material.dart';

class CustomHeaderIcon extends StatelessWidget {
  final String assetIconSelected;
  final String assetIconUnSelected;
  final bool isActiveColor;

  const CustomHeaderIcon(
      {super.key,
      required this.assetIconSelected,
      required this.assetIconUnSelected,
      this.isActiveColor = false})
      ;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(assetIconUnSelected))),
    );
  }
}
