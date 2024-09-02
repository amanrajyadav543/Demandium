import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/coupon/widgets/custom_coupon_snackber.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class RemoveCouponWidget extends StatefulWidget {
  final bool isReplace;
  final CouponModel couponModel;
  final int index;
  final bool fromCheckout;
  const RemoveCouponWidget({super.key, required this.isReplace, required this.couponModel, required this.index, required this.fromCheckout});
  @override
  State<RemoveCouponWidget> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<RemoveCouponWidget> {

  @override
  Widget build(BuildContext context) {
    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor(){
    return Padding(
      padding: EdgeInsets.only(top: ResponsiveHelper.isWeb()? 0 :Dimensions.cartDialogPadding),
      child: PointerInterceptor(
        child: GetBuilder<CouponController>(builder: (couponController){
          return Container(
            width:ResponsiveHelper.isDesktop(context)? Dimensions.webMaxWidth/2:Dimensions.webMaxWidth,
            padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            child:  Column(mainAxisSize: MainAxisSize.min, children: [


              Container(
                height: Dimensions.paddingSizeExtraSmall,
                width: Dimensions.paddingSizeLarge * 2,
                decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
                ),),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),


              Image.asset(widget.isReplace ?Images.replaceCoupon : Images.couponWarning,
                  height: Dimensions.paddingSizeExtraLarge * 3,
                  width: Dimensions.paddingSizeExtraLarge * 3
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text(widget.isReplace ? "want_to_replace_existing_coupon".tr : "want_to_remove_coupon".tr , style: ubuntuBold.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge
              )),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeDefault
                ),
                child: Text(widget.isReplace ? "new_coupon_use_text".tr : "remove_coupon_text".tr,
                  textAlign: TextAlign.center, style: ubuntuRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      height: 1.5
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Padding(
                padding: const EdgeInsets.only(
                    left: Dimensions.paddingSizeExtraLarge,
                    right: Dimensions.paddingSizeExtraLarge
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Expanded(child: CustomButton(
                      buttonText: 'cancel'.tr,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      onPressed: () => Get.back(),
                      textColor: Colors.black,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeDefault),


                    Expanded(child: CustomButton(
                      buttonText: widget.isReplace? 'yes_continue'.tr : "yes_remove".tr,
                      backgroundColor: Theme.of(context).primaryColor,
                      isLoading: couponController.isLoading,
                      onPressed: widget.isReplace ? () async {
                        couponController.updateSelectedCouponIndex(-1);
                        if(Get.find<AuthController>().isLoggedIn()){

                          if( Get.find<CartController>().cartList.isNotEmpty){
                            bool addCoupon = false;
                            Get.find<CartController>().cartList.forEach((cart) {
                              if(cart.totalCost >= widget.couponModel.discount!.minPurchase!.toDouble()) {
                                addCoupon = true;
                              }
                            });
                            if(addCoupon)  {

                              await Get.find<CouponController>().applyCoupon(widget.couponModel, widget.index).then((value) async {
                                if(value.isSuccess!){
                                  Get.find<CartController>().getCartListFromServer();
                                  if(widget.fromCheckout){
                                    Get.back();
                                  }
                                  Get.back();
                                  Get.find<CartController>().updateIsOpenPartialPaymentPopupStatus(true);
                                  customCouponSnackBar("coupon_applied_successfully".tr, subtitle :"${value.message}", isError: false);

                                }else{
                                  Get.back();
                                  Get.find<CartController>().updateIsOpenPartialPaymentPopupStatus(false);
                                  customCouponSnackBar("can_not_apply_coupon", subtitle :"${value.message}");
                                }
                              },);

                            }else{
                              Get.back();
                              customCouponSnackBar("can_not_apply_coupon", subtitle : "${'valid_for_minimum_booking_amount_of'.tr} ${PriceConverter.convertPrice(widget.couponModel.discount?.minPurchase ?? 0)} ");}
                          }else{
                            Get.back();
                            customCouponSnackBar("oops", subtitle :"looks_like_no_service_is_added_to_your_cart");
                          }
                        }else{
                          Get.back();
                          customCouponSnackBar("sorry_you_can_not_use_coupon",  subtitle :"please_login_to_use_coupon" );
                        }

                      } :() async {
                       await  couponController.removeCoupon(index: widget.index, );

                      },
                      // textColor: Theme.of(context).cardColor,
                    )),


                  ],),
              ),

              const SizedBox(height: Dimensions.paddingSizeExtraLarge,)

            ],),
          );
        }),
      ),
    );
  }
}
