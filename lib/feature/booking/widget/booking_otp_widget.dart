import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class BookingOtpWidget extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;
  const BookingOtpWidget({super.key, required this.bookingDetailsContent}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: Get.find<ThemeController>().darkTheme ? null : shadow,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),

      child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Text('otp_verification_code'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7)),),
        Padding(padding: const EdgeInsets.symmetric(vertical: 5),
          child: RichText(text: TextSpan(text: "${'your_otp_is'.tr} : ",
            style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(1)),
            children: <TextSpan>[
              TextSpan(
                text: bookingDetailsContent.bookingOtp?.replaceAll("null", " ") ?? "",
                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              )
            ],
          ),),
        ),
        const Row(),
      ],),
    );
  }
}
