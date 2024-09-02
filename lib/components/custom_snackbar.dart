import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

void customSnackBar(String? message, {bool isError = true, double margin = Dimensions.paddingSizeSmall,int duration =2, Color? backgroundColor, Widget? customWidget, double borderRadius = Dimensions.radiusSmall, bool showDefaultSnackBar = true}) {
  if(message != null && message.isNotEmpty) {

    if(showDefaultSnackBar){
      final width = MediaQuery.of(Get.context!).size.width;
      ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
        content: customWidget ?? Text(message.tr, style: ubuntuRegular.copyWith(
          color: Colors.white,
        )),
        margin: ResponsiveHelper.isDesktop(Get.context!)
            ? EdgeInsets.only(right: width * 0.7, bottom: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeExtraSmall)
            : const EdgeInsets.symmetric( horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: duration),
        backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
      ));

    }else{
      Get.showSnackbar(GetSnackBar(
        backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
        message: customWidget ==null ? message.tr : null,
        messageText: customWidget,
        maxWidth: Dimensions.webMaxWidth,
        duration: Duration(seconds: duration),
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.only(
            top: Dimensions.paddingSizeSmall,
            left: ResponsiveHelper.isDesktop(Get.context) ? Dimensions.webMaxWidth/2: Dimensions.paddingSizeSmall,
            right: ResponsiveHelper.isDesktop(Get.context) ? (Get.width-Dimensions.webMaxWidth)/2: Dimensions.paddingSizeSmall,
            bottom: margin),
        borderRadius: borderRadius,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }
  }
}