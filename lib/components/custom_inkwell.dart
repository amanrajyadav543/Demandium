

import 'package:demandium/components/core_export.dart';

class CustomInkWell extends StatelessWidget {
  final double? radius;
  final Widget? child;
  final Function() ? onTap;
  final Color? highlightColor;
  const CustomInkWell({super.key, this.radius, this.child, this.onTap, this.highlightColor}) ;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? Dimensions.radiusDefault),
        highlightColor: highlightColor ?? Theme.of(context).primaryColor.withOpacity(0.05),
        hoverColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: child,
      ),
    );
  }
}