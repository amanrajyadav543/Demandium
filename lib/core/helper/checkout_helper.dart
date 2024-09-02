import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

enum DiscountType {general, coupon, campaign, refer}

class CheckoutHelper {

  static final ConfigModel configModel = Get.find<SplashController>().configModel;

  static double getAdditionalCharge(){
    return Get.find<SplashController>().configModel.content?.additionalCharge == 1 ? configModel.content?.additionalChargeFeeAmount ?? 0.0 : 0.0;
  }


  static bool checkPartialPayment({required double walletBalance, required double bookingAmount }) => walletBalance < bookingAmount;

  static double calculatePaidAmount({required double walletBalance, required double bookingAmount }) => checkPartialPayment(walletBalance: walletBalance, bookingAmount: bookingAmount) ? walletBalance : bookingAmount;



  static double calculateDiscount({required List<CartModel> cartList, required DiscountType discountType }){
    double discount = 0;
    for (var cartModel in cartList) {
      if(discountType == DiscountType.general){
        discount = discount + cartModel.discountedPrice ;
      }else if(discountType == DiscountType.campaign){
        discount = discount + cartModel.campaignDiscountPrice;
      }
      else if(discountType == DiscountType.coupon){
        discount = discount + cartModel.couponDiscountPrice;
      }
    }
    return discount;
  }


  static double calculateVat({required List<CartModel> cartList}){
    double vat = 0;
    for (var cartModel in cartList) {
      vat = vat + cartModel.taxAmount;
    }
    return vat;
  }


  static double calculateSubTotal({required List<CartModel> cartList}){
    double subTotalPrice  = 0;
    for (var cartModel in cartList) {
      subTotalPrice = subTotalPrice + (cartModel.serviceCost * cartModel.quantity);
    }
    return subTotalPrice ;
  }

  static double calculateGrandTotal({required List<CartModel> cartList , required double referralDiscount}){
    return
      calculateSubTotal(cartList: cartList)
      + calculateVat(cartList: cartList)
      + getAdditionalCharge()
      - (calculateDiscount(cartList: cartList, discountType: DiscountType.general)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.coupon)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.campaign)
          + referralDiscount
      );
  }


  static double calculateTotalAmountWithoutCoupon({required List<CartModel> cartList}){
    return
      calculateSubTotal(cartList: cartList)
          + calculateVat(cartList: cartList)
          + getAdditionalCharge()
          - (calculateDiscount(cartList: cartList, discountType: DiscountType.general)
          + calculateDiscount(cartList: cartList, discountType: DiscountType.campaign)
      );
  }

  static double calculateDueAmount({required List<CartModel> cartList, required bool walletPaymentStatus, required double walletBalance, required double bookingAmount, required double referralDiscount}){
    return calculateGrandTotal(cartList: cartList, referralDiscount: referralDiscount) - (walletPaymentStatus ? calculatePaidAmount(walletBalance: walletBalance, bookingAmount: bookingAmount) : 0);
  }

  static double calculateRemainingWalletBalance({required double walletBalance, required double bookingAmount}){
    return checkPartialPayment(walletBalance: walletBalance, bookingAmount: bookingAmount)  ? 0 : walletBalance - bookingAmount;
  }

}