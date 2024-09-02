
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

void customCouponSnackBar(String? title, { String? subtitle,bool isError = true, double margin = Dimensions.paddingSizeSmall,int duration =2, Color? backgroundColor, Widget? customWidget, double borderRadius = Dimensions.radiusSmall}) {
  if(title != null && title.isNotEmpty) {
    Get.closeAllSnackbars();
    Get.snackbar( title.tr,
      "",
      messageText: Text(
        subtitle?.tr ?? "",
        style: ubuntuRegular.copyWith(
            color: Colors.white.withOpacity(0.7)
        ),
      ),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey.shade900,
      borderRadius: Dimensions.paddingSizeSmall,
      margin: EdgeInsets.symmetric(
          horizontal:ResponsiveHelper.isDesktop(Get.context!)? ((  Get.width - Dimensions.webMaxWidth)/2) :  Dimensions.paddingSizeLarge,
          vertical: ResponsiveHelper.isDesktop(Get.context!) ? Get.height  * 0.07 :  Dimensions.paddingSizeExtraLarge * 2
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeExtraLarge,
          vertical: Dimensions.paddingSizeLarge
      ),
      icon: Image.asset(
          isError ? Images.couponWarning : Images.correctIcon,
          width: Dimensions.paddingSizeLarge * 2,
          height: Dimensions.paddingSizeLarge * 2
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: isError ? Colors.red : Colors.green,
    );
  }
}