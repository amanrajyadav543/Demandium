import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/provider_details_card.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/wallet_payment_card.dart';
import 'package:get/get.dart';

class OrderDetailsPageWeb extends StatelessWidget {
  const OrderDetailsPageWeb({super.key}) ;

  @override
  Widget build(BuildContext context) {

    ConfigModel configModel = Get.find<SplashController>().configModel;
    bool showWalletPaymentCart = Get.find<AuthController>().isLoggedIn() && Get.find<CartController>().walletBalance > 0
        && configModel.content?.walletStatus == 1 && configModel.content?.partialPayment == 1;

    return Center( child: SizedBox(width: Dimensions.webMaxWidth,
      child: GetBuilder<CartController>(builder: (cartController){
        return Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(child: WebShadowWrap( minHeight: Get.height * 0.1, child: Column( mainAxisSize: MainAxisSize.min, children: [
            const ServiceSchedule(),
            const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: AddressInformation()),
            ( cartController.cartList.isNotEmpty && cartController.cartList.first.provider !=null) ?  ProviderDetailsCard(
              providerData: cartController.cartList.first.provider,
            ) : const SizedBox(),

            const SizedBox(height: Dimensions.paddingSizeDefault,),

            Get.find<AuthController>().isLoggedIn() ? const ShowVoucher() : const SizedBox(),

            showWalletPaymentCart ? const WalletPaymentCard(fromPage: "checkout",) : const SizedBox(),
          ]))),

          const SizedBox(width: 50,),
          Expanded(child: WebShadowWrap( minHeight: Get.height * 0.1  ,child: const CartSummery()),),

        ]);
      }),
    ));
  }
}
