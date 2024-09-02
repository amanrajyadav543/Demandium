import 'package:demandium/feature/coupon/widgets/custom_coupon_snackber.dart';
import 'package:demandium/feature/coupon/widgets/remove_coupon_dialog.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';


class Voucher extends StatelessWidget {
  final bool isExpired;
  final CouponModel couponModel;
  final int index;
  final bool fromCheckout;
  const Voucher({super.key,required this.couponModel,required this.isExpired, required this.index, this.fromCheckout = false}) ;

  @override
  Widget build(BuildContext context) {

   bool isCouponAvailableInCart =  Get.find<CartController>().cartList.isNotEmpty && Get.find<CartController>().cartList.first.couponCode !=null ;



    return GetBuilder<CouponController>(builder: (couponController){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).hoverColor,
          boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
        ),
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,),
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall,),
        width: context.width,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Image.asset(Images.voucherImage,fit: BoxFit.fitWidth,)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    couponModel.couponCode!,
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),

                  Wrap(runAlignment: WrapAlignment.start,children: [
                    Text(
                      "${'use_code'.tr} ${couponModel.couponCode!} ${'to_save_upto'.tr}",
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),
                    ),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        " ${PriceConverter.convertPrice(couponModel.discount!.discountAmountType == 'amount'?
                        couponModel.discount!.discountAmount!.toDouble() : couponModel.discount!.maxDiscountAmount!.toDouble())} ",
                        style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),
                      ),
                    ),

                    Text('on_your_next_purchase'.tr,
                      style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),
                    ),
                  ],),

                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("valid_till".tr,
                            style: ubuntuRegular.copyWith(
                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6),
                                fontSize: Dimensions.fontSizeSmall),),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                          Text(couponModel.discount!.endDate.toString(),
                              style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.6), fontSize: 12))
                        ],
                      ),
                      couponController.isLoading && index == couponController.selectedCouponIndex ?
                      const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: SizedBox(height: 20,width: 20,child: CircularProgressIndicator()),
                      ) : InkWell(
                        onTap: isCouponAvailableInCart && couponModel.isUsed == 0 ? (){
                          showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context, builder: (context) =>  RemoveCouponWidget(
                            isReplace: true,
                            couponModel: couponModel,
                            index: index,
                            fromCheckout: fromCheckout,
                          ),);
                        }  : isCouponAvailableInCart && couponModel.isUsed == 1 ?
                            (){
                          showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context, builder: (context) =>  RemoveCouponWidget(
                            isReplace: false,
                            couponModel: couponModel,
                            index: index,
                            fromCheckout: fromCheckout,
                          ),);
                        } : !isExpired ? ()async {
                          couponController.updateSelectedCouponIndex(index);

                          if(Get.find<AuthController>().isLoggedIn()){

                            if( Get.find<CartController>().cartList.isNotEmpty){
                              bool addCoupon = false;
                              Get.find<CartController>().cartList.forEach((cart) {
                                if(cart.totalCost >= couponModel.discount!.minPurchase!.toDouble()) {
                                  addCoupon = true;
                                }
                              });
                              if(addCoupon)  {

                                await Get.find<CouponController>().applyCoupon(couponModel, index).then((value) async {
                                  if(value.isSuccess!){
                                    Get.find<CartController>().getCartListFromServer();
                                    if(fromCheckout){
                                      Get.back();
                                    }
                                    Get.find<CartController>().updateIsOpenPartialPaymentPopupStatus(true);
                                    customCouponSnackBar("coupon_applied_successfully".tr, subtitle : "review_your_cart_for_applied_discounts".tr, isError: false);

                                  }else{
                                    Get.find<CartController>().updateIsOpenPartialPaymentPopupStatus(false);
                                    customCouponSnackBar("can_not_apply_coupon", subtitle :"${value.message}");
                                  }
                                },);

                              }else{
                                customCouponSnackBar("can_not_apply_coupon", subtitle : "${'valid_for_minimum_booking_amount_of'.tr} ${PriceConverter.convertPrice(couponModel.discount?.minPurchase ?? 0)} ");
                            }
                            }else{
                              customCouponSnackBar("oops", subtitle :"looks_like_no_service_is_added_to_your_cart");
                            }
                          }else{
                            customCouponSnackBar("sorry_you_can_not_use_coupon",  subtitle :"please_login_to_use_coupon" );
                          }
                        } : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                              color: isExpired || couponModel.isUsed == 1 ? Theme.of(context).disabledColor : Theme.of(context).colorScheme.primary,
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
                          ),
                          child: Center(
                            child: Text(
                              isExpired ?'expired'.tr : couponModel.isUsed == 1 ? "used".tr :'use'.tr,
                              style: ubuntuRegular.copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: Dimensions.fontSizeDefault,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
                ),
              ),),
          ],
        ),
      );
    });
  }
}
