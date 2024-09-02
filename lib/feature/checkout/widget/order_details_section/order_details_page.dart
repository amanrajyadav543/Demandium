import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/provider_details_card.dart';
import 'package:demandium/feature/checkout/widget/order_details_section/wallet_payment_card.dart';
import 'package:get/get.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key}) ;

  @override
  Widget build(BuildContext context) {
    ConfigModel configModel = Get.find<SplashController>().configModel;
    bool showWalletPaymentCart = Get.find<AuthController>().isLoggedIn() && Get.find<CartController>().walletBalance > 0
        && configModel.content?.walletStatus == 1 && configModel.content?.partialPayment == 1;
    return GetBuilder<CartController>(builder: (cartController){
      return SingleChildScrollView( child: Column(children: [

        const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: ServiceSchedule(),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: AddressInformation(),
        ),

       cartController.cartList.isNotEmpty &&  cartController.cartList.first.provider!= null ?
        ProviderDetailsCard( providerData: Get.find<CartController>().cartList.first.provider,): const SizedBox(),

        Get.find<AuthController>().isLoggedIn() ? const ShowVoucher() : const SizedBox(),

        showWalletPaymentCart? const WalletPaymentCard(fromPage: 'checkout',): const SizedBox(),

        const CartSummery()

      ]));
    });
  }
}
