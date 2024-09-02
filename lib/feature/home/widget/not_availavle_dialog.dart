import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class ServiceNotAvailableDialog extends StatefulWidget {
  final AddressModel? address;
  final  bool forCard;
  final bool showButton;
  final VoidCallback? onBackPressed;
  const ServiceNotAvailableDialog({super.key, this.address, this.forCard = false, this.showButton = true, this.onBackPressed});

  @override
  State<ServiceNotAvailableDialog> createState() => _ServiceNotAvailableDialogState();
}

class _ServiceNotAvailableDialogState extends State<ServiceNotAvailableDialog> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: ResponsiveHelper.isDesktop(context) ? Dimensions.webMaxWidth/2.5 : Dimensions.webMaxWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 20, width: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close, color: Theme.of(context).hintColor),
                    onPressed: widget.onBackPressed,
                  ),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeLarge),
              Image.asset(Images.notAvailableIcon, width:  50.0, height: 50.0, color: Get.isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text("services_are_not_available".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(widget.forCard ? 'services_from_your_cart_is_not'.tr : "there_are_no_services".tr, style: ubuntuRegular.copyWith( fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              widget.showButton ? Row(children: [
                Expanded(child: CustomButton(backgroundColor: Theme.of(context).hintColor.withOpacity(0.65), buttonText: 'dont_change'.tr,
                  onPressed: () {
                    Get.back();
                    Get.find<LocationController>().saveAddressAndNavigate(widget.address!, false, '', true , true,  fromAddressDialog: true,showDialog: "false");
                  }
                )),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Expanded(child: CustomButton(buttonText: 'continue'.tr,
                  onPressed: widget.onBackPressed,
                )),
              ]) : const SizedBox(),
              widget.showButton ? const SizedBox(height: Dimensions.paddingSizeLarge) : const SizedBox(),

              InkWell(
                onTap: () {
                  Get.back();
                  Get.toNamed(RouteHelper.getServiceArea());
                },
                child: Text("view_available_areas".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeDefault, color:  Get.isDarkMode? Theme.of(context).hintColor : Theme.of(context).primaryColor, decoration : TextDecoration.underline)),
              ),

            ]
        ),
      ),
    );
  }
}
