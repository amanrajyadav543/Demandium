import 'package:demandium/components/core_export.dart';

class RippleButton extends StatelessWidget {
  const RippleButton({super.key, required this.onTap, this.borderRadius = 5}) ;
  final GestureTapCallback onTap;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
