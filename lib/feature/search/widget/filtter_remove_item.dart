import 'package:demandium/components/core_export.dart';


class FilterRemoveItem extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const FilterRemoveItem({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 5),
      child: Row( mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
        Text(title, style: ubuntuRegular,),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
        InkWell(
          onTap: onTap,
          child:  Icon(Icons.close, size: 16, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),),
        )
      ],),
    );
  }
}