import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class ServiceUnavailableDialog extends StatelessWidget {
 final String bookingId;
 final bool isPriceChanged;
 final bool isNotAvailable;
 final bool isAllNotAvailable;
  const ServiceUnavailableDialog({super.key, required this.bookingId, required this.isPriceChanged, required this.isNotAvailable, required this.isAllNotAvailable});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        return Container(
          width: ResponsiveHelper.isDesktop(context) ? 550 : Dimensions.webMaxWidth,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: ResponsiveHelper.isDesktop(context) ? const BorderRadius.all(Radius.circular(20)) : const BorderRadius.vertical(top: Radius.circular(20)),
            color: Get.isDarkMode ? Theme.of(context).cardColor : Theme.of(context).colorScheme.surface,
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
            Image.asset(Images.serviceNotAvailable, width:  50.0, height: 50.0),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text((isNotAvailable && isPriceChanged) ? 'please_review_the_changes'.tr : isPriceChanged ? 'some_services_price'.tr : "some_services_are_not".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),


            ListView.builder(
              itemCount: serviceBookingController.serviceAvailability!.content!.services!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding( padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall), child:
                  ServiceItemWidget(
                    index: index+1,
                    serviceName : '${serviceBookingController.serviceAvailability?.content?.services?[index].serviceName??""}-${serviceBookingController.serviceAvailability?.content?.services?[index].variantKey??""}',
                    previousPrice: serviceBookingController.serviceAvailability?.content?.services?[index].bookingServiceCost??0,
                    updatedPrice: serviceBookingController.serviceAvailability?.content?.services?[index].serviceCost ?? 0,
                    isNotActive: serviceBookingController.serviceAvailability?.content?.services?[index].isAvailable == 0,
                  )
                );
              }
            ),


            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text((isNotAvailable && isPriceChanged) ? 'since_you_have_last_ordered'.tr : isPriceChanged ? 'services_price_has_been_updates'.tr : isAllNotAvailable ? 'all_services_from_this_booking'.tr : "some_services_has_been_changed".tr, style: ubuntuRegular.copyWith( fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              isAllNotAvailable ? const SizedBox() : const SizedBox(width: Dimensions.paddingSizeDefault),
              isAllNotAvailable ? const SizedBox() : Expanded(child: CustomButton(backgroundColor: Theme.of(context).hintColor.withOpacity(0.65), buttonText: 'cancel'.tr, onPressed: () => Get.back())),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: serviceBookingController.isLoading ? const Center(child: SizedBox(width: 40, child: CircularProgressIndicator())) :  CustomButton(buttonText: isAllNotAvailable ? 'ok'.tr : 'yes_continue'.tr, onPressed: () {
                if(isAllNotAvailable) {
                  Get.back();
                } else {
                  serviceBookingController.rebook(bookingId, isBack: true);
                }
              })),
              const SizedBox(width: Dimensions.paddingSizeDefault),
            ]),

            const SizedBox(height: Dimensions.paddingSizeLarge),
            const SizedBox(height: Dimensions.paddingSizeLarge),

          ],
          ),

        );
      }
    );
  }
}

class ServiceItemWidget extends StatelessWidget {
  final int? index;
  final String? serviceName;
  final double? previousPrice;
  final  double? updatedPrice;
  final bool isNotActive;
  const  ServiceItemWidget({super.key, this.index, this.serviceName, this.previousPrice, this.updatedPrice, this.isNotActive = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        return Row(children: [
          const SizedBox(width: Dimensions.paddingSizeDefault),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: isNotActive ? Theme.of(context).colorScheme.error : Theme.of(context).primaryColor),
              shape: BoxShape.circle, color:  isNotActive ? Theme.of(context).colorScheme.error.withOpacity(0.10) : Colors.transparent,
            ),
            padding: isNotActive ? const EdgeInsets.all(Dimensions.paddingSizeExtraSmall) : const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: isNotActive ?  Icon(Icons.close, color: Theme.of(context).colorScheme.error, size: 20) : Text(index.toString(), style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.primary)),
          ),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(child: Text(serviceName!, style: ubuntuRegular.copyWith(color: isNotActive ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyLarge!.color, decoration: isNotActive ? TextDecoration.lineThrough : TextDecoration.none), maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          serviceBookingController.isPriceChanged ?
          Column(
            children: [
              (previousPrice == updatedPrice || isNotActive)? const SizedBox() :
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
                    style: ubuntuBold.copyWith(fontSize: Dimensions.paddingSizeDefault, color:Get.isDarkMode ? Theme.of(context).primaryColorLight : isNotActive ? Theme.of(context).hintColor : Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ) : const SizedBox(),
          ],
        );
      }
    );
  }
}



