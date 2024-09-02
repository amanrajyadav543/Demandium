import 'package:demandium/components/core_export.dart';

class DiscountTagWidget extends StatelessWidget {
  final double? discountAmount;
  final String? discountAmountType;
  const DiscountTagWidget({super.key, this.discountAmount, this.discountAmountType}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusSmall),
          bottomRight: Radius.circular(Dimensions.radiusDefault),
        ),
      ),
      child: Text(PriceConverter.percentageOrAmount('$discountAmount', '$discountAmountType'),
        style: ubuntuRegular.copyWith(color: Theme.of(context).primaryColorLight),
      ),
    );
  }
}
