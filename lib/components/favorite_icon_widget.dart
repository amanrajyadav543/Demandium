import 'package:demandium/components/core_export.dart';

class FavoriteIconWidget extends StatelessWidget {
  final Function()? onTap;
  final int? value;
  const FavoriteIconWidget({super.key, this.onTap, this.value}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: value == 1 ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(  Icons.favorite_outlined , color: Colors.white, size: 16,),
        ),
      ),
    );
  }
}
