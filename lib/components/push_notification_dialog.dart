import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:demandium/components/core_export.dart';

class PushNotificationDialog extends StatefulWidget {
  final String? title;
  final NotificationBody? notificationBody;
  const PushNotificationDialog({super.key, required this.title, required this.notificationBody});

  @override
  State<PushNotificationDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<PushNotificationDialog> {

  @override
  void initState() {
    super.initState();
    if(Get.find<AuthController>().isLoggedIn()){
      if(Get.find<AuthController>().isNotificationActive()){
        _startAlarm();
      }
    }
  }
  void _startAlarm() async {
    final player = AudioPlayer();
    player.play(AssetSource('notification.wav'));
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      child: Container(
        width: Dimensions.pushNotificationDialogWidth,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),

        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active, size: 60, color: Theme.of(context).colorScheme.primary),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          Row(
              children: [
                Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: const Size(1170, 40), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),),
                      child: Text(
                        'cancel'.tr,
                        textAlign: TextAlign.center,
                        style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            )),
            const SizedBox(width: Dimensions.paddingSizeLarge),
            Expanded(child: CustomButton(
              height: 40,
              buttonText: 'go'.tr,
              onPressed: () {
                Get.back();

                if(widget.notificationBody?.type == "booking" && widget.notificationBody?.bookingId!=null && widget.notificationBody?.bookingId!=""){
                  Get.toNamed(RouteHelper.getBookingDetailsScreen(widget.notificationBody!.bookingId!,"",'fromNotification'));
                }

                else if(widget.notificationBody?.type=="chatting"){

                  Get.toNamed(RouteHelper.getChatScreenRoute(
                    widget.notificationBody?.channelId??"",
                    widget.notificationBody?.userType == 'super-admin' ? "admin" : widget.notificationBody?.userName??"",
                    widget.notificationBody?.userProfileImage??"",
                    widget.notificationBody?.userPhone??"",
                    widget.notificationBody?.userType??"",
                    fromNotification: "fromNotification",
                  ));

                }

                else if(widget.notificationBody?.type == 'privacy_policy' && widget.notificationBody?.title != null && widget.notificationBody!.title !=''){
                  Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
                }

                else if(widget.notificationBody?.type == 'terms_and_conditions' && widget.notificationBody?.title != null && widget.notificationBody!.title !=''){
                  Get.toNamed(RouteHelper.getHtmlRoute("terms-and-condition"));
                }
                else if(widget.notificationBody?.type=="bidding") {
                  Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: "fromNotification"));
                } else if(widget.notificationBody?.type == "wallet"){
                  Get.toNamed(RouteHelper.getMyWalletScreen(fromNotification: "fromNotification"));
                }
                else if(widget.notificationBody?.type == "loyalty_point"){
                  Get.toNamed(RouteHelper.getLoyaltyPointScreen(fromNotification: "fromNotification"));
                }
                else if(widget.notificationBody?.type == "bid-withdraw"){
                  Get.toNamed(RouteHelper.getMyPostScreen(fromNotification: 'fromNotification'));
                }
                else{
                  Get.toNamed(RouteHelper.getNotificationRoute());
                }
              }),
            ),
          ]),

        ]),
      ),
    );
  }
}
