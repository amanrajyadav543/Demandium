import 'package:flutter/material.dart';

class PagerDot extends StatelessWidget {
  const PagerDot({super.key, required this.index, required this.currentIndex, this.dotSize = 10}) ;
  final int index;
  final int currentIndex;
  final double dotSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: dotSize),
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        color: currentIndex == index ? Theme.of(context).colorScheme.primary : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}