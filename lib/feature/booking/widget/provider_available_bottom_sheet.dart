import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/booking/model/service_availability_model.dart';
import 'package:demandium/feature/booking/widget/service_unavailable_dialog.dart';
import 'package:get/get.dart';



class RebookWarningBottomSheet extends StatelessWidget {
  final String bookingId;
  const RebookWarningBottomSheet({super.key, required this.bookingId});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceBookingController>(
      builder: (serviceBookingController) {
        ServiceAvailabilityModel? serviceAvailable = serviceBookingController.serviceAvailability;
        return Container(
          width: ResponsiveHelper.isDesktop(context) ? 550 : Dimensions.webMaxWidth,
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
            Image.asset(Images.providerNotAvailable, width:  50.0, height: 50.0),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text("provider_not_available".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text("the_provider_who_previously".tr, style: ubuntuRegular.copyWith( fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: CustomButton(backgroundColor: Theme.of(context).hintColor.withOpacity(0.65), buttonText: 'cancel'.tr, onPressed: ()=> Get.back())),
              const SizedBox(width: Dimensions.paddingSizeDefault),
              Expanded(child: CustomButton(buttonText: 'yes_continue'.tr, onPressed: () {
                if (serviceBookingController.isNotAvailable || serviceBookingController.isPriceChanged) {
                  Get.back();
                  if (ResponsiveHelper.isDesktop(Get.context)) {
                     Get.dialog(Center(child: ServiceUnavailableDialog(
                       bookingId: bookingId,
                       isPriceChanged: serviceBookingController.isPriceChanged,
                       isNotAvailable: serviceBookingController.isNotAvailable,
                       isAllNotAvailable: serviceBookingController.checkAllServiceAvailable(serviceAvailable!.content!.services),
                     )));
                  } else {

                     Get.bottomSheet(ServiceUnavailableDialog(
                       bookingId: bookingId,
                       isPriceChanged: serviceBookingController.isPriceChanged,
                       isNotAvailable: serviceBookingController.isNotAvailable,
                       isAllNotAvailable: serviceBookingController.checkAllServiceAvailable(serviceAvailable!.content!.services),
                     ), backgroundColor: Colors.transparent, isScrollControlled: true);
                  }
                }else{
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
