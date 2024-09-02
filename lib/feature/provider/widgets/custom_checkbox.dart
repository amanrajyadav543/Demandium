import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool? value;
  const CustomCheckBox({super.key, required this.title, this.onTap, this.value}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Expanded(
          child: Text(title.tr,
            style: ubuntuRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium?.color
            ),
            overflow: TextOverflow.ellipsis, maxLines: 1,
          ),
        ),

        const SizedBox(width: Dimensions.paddingSizeDefault,),
        SizedBox(width: 20.0,
          child: Checkbox(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: (bool? isActive) => onTap!()
          ),
        ),
      ]),
    );
  }
}
