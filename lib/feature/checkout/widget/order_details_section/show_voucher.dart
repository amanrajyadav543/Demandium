import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class ShowVoucher extends StatelessWidget {
  const ShowVoucher({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController){

        bool couponApplied = cartController.cartList.isNotEmpty && cartController.cartList[0].couponCode != null
            && cartController.cartList[0].couponCode != "" ;

        return couponApplied ? Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).hoverColor : Theme.of(context).cardColor, boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow),
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getVoucherRoute(fromPage: 'checkout')),
              child: Row( children: [
                Image.asset(Images.couponIcon,width: 20.0,height: 20.0,),
                const SizedBox(width: Dimensions.paddingSizeDefault,),
                Text(cartController.cartList[0].couponCode??"",
                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                Text("applied".tr,style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6),),),
              ]),
            ),

            GetBuilder<CouponController>(builder: (couponController){
              return TextButton(
                onPressed: couponController.isLoading ? null : () async {
                  await Get.find<CouponController>().removeCoupon(fromCheckout: true);
                  Get.find<CartController>().openWalletPaymentConfirmDialog();
                },
                child: Text('remove'.tr,
                  style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.error),),
              );
            })
          ]),

        ): const ApplyVoucher();
      }
    );
  }
}
