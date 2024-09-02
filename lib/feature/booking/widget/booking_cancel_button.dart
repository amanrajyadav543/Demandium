import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class BookingCancelButton extends StatelessWidget {
  const BookingCancelButton({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){
      bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
      String bookingStatus = bookingDetailsController.bookingDetailsContent?.bookingStatus ?? "";
      return bookingDetailsController.isCancelling ? const Center(child: CircularProgressIndicator()) : isLoggedIn && (bookingStatus == 'pending') ?
      Align( alignment: Alignment.center, child: InkWell( onTap: () =>  Get.dialog(
        ConfirmationDialog(
          icon: Images.deleteProfile,
          title: 'are_you_sure_to_cancel_your_order'.tr, description: 'your_order_will_be_cancel'.tr,
          descriptionTextColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
          onYesPressed: () {
            bookingDetailsController.bookingCancel(bookingId: bookingDetailsController.bookingDetailsContent?.id ?? "");
            Get.back();
          },
        ), useSafeArea: false),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(.2),
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
          ),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
            child: Text('cancel'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).colorScheme.error,),
            ),
          ),
        ),
      )) : const SizedBox();
    });
  }
}
