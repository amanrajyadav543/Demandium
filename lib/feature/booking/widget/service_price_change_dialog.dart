import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ServicePriceChangeDialog extends StatelessWidget {
  final String bookingId;
  const ServicePriceChangeDialog({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        return Container(
          width: ResponsiveHelper.isDesktop(context) ? 350 : Dimensions.webMaxWidth,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: ResponsiveHelper.isDesktop(context) ? const BorderRadius.all(Radius.circular(20)) : const BorderRadius.vertical(top: Radius.circular(20)),
            color: Get.isDarkMode?Theme.of(context).cardColor:Theme.of(context).colorScheme.surface,
          ),

          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            ResponsiveHelper.isDesktop(context) ? const SizedBox() : Container(
              height: 5, width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Theme.of(context).hintColor.withOpacity(0.50)
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Image.asset(Images.servicePrice, width:  50.0, height: 50.0),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text("some_services_price".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),


            ListView.builder(
              itemCount: serviceBookingController.serviceAvailability!.content!.services!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Center(
                  child: ServicePriceItemWidget(
                    index: index+1,
                    serviceName : '${serviceBookingController.serviceAvailability!.content!.services![index].serviceName!}-${serviceBookingController.serviceAvailability!.content!.services![index].variantKey!}',
                    previousPrice: serviceBookingController.serviceAvailability!.content!.services![index].bookingServiceCost!,
                    updatedPrice: serviceBookingController.serviceAvailability!.content!.services![index].serviceCost ?? 0,
                  )
                );
              }
            ),



            Text("some_services_has_been_changed".tr, style: ubuntuRegular.copyWith( fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: CustomButton(backgroundColor: Theme.of(context).hintColor.withOpacity(0.65), buttonText: 'cancel'.tr, onPressed: () => Get.back() )),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: CustomButton(buttonText: 'yes_continue'.tr, onPressed: () {
                serviceBookingController.rebook(bookingId, isBack: true);
              })),
              const SizedBox(width: Dimensions.paddingSizeDefault),
            ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            const SizedBox(height: Dimensions.paddingSizeLarge),

          ]),



        );
      }
    );
  }
}

class ServicePriceItemWidget extends StatelessWidget {
  final int? index;
  final String? serviceName;
  final  double? previousPrice;
  final double? updatedPrice;
  const ServicePriceItemWidget({super.key, this.index, this.serviceName, this.previousPrice, this.updatedPrice});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const SizedBox(width: Dimensions.paddingSizeDefault),
        Container(
          decoration: BoxDecoration( border: Border.all(color: Theme.of(context).primaryColor), shape: BoxShape.circle),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Text(index.toString(), style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.primary)),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Expanded(child: Text(serviceName!, style: ubuntuRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: Dimensions.paddingSizeDefault),

        Column(
          children: [
            previousPrice == updatedPrice ? const SizedBox() :
            Padding(
              padding:  EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ?  0.0 : Dimensions.paddingSizeExtraSmall),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(PriceConverter.convertPrice(previousPrice, isShowLongPrice: true),
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? Dimensions.paddingSizeExtraSmall : 0.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Text(PriceConverter.convertPrice(
                  updatedPrice,
                  discount: 0,
                  discountType: 'percent',
                  isShowLongPrice:true,
                ),
                  style: ubuntuBold.copyWith(fontSize: Dimensions.paddingSizeDefault, color:Get.isDarkMode ? Theme.of(context).primaryColorLight: Theme.of(context).primaryColor),
                ),
              ),
            )

          ],
        ),
      ],
    );
  }
}



