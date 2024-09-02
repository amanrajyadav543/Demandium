import 'dart:convert';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/core/helper/checkout_helper.dart';
import 'package:demandium/feature/cart/widget/available_provider_widgets.dart';
import 'package:demandium/feature/checkout/view/payment_screen.dart';
import 'package:universal_html/html.dart' as html;
import 'package:get/get.dart';

class ProceedToCheckoutButtonWidget extends StatefulWidget {
  final String pageState;
  final String addressId;
  const ProceedToCheckoutButtonWidget({super.key, required this.pageState, required this.addressId}) ;

  @override
  State<ProceedToCheckoutButtonWidget> createState() => _ProceedToCheckoutButtonWidgetState();
}

class _ProceedToCheckoutButtonWidgetState extends State<ProceedToCheckoutButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController){
      return GetBuilder<CartController>(builder: (cartController){

        String? errorText = cartController.checkScheduleBookingAvailability();
        List<CartModel> cartList = cartController.cartList;
        bool walletPaymentStatus = cartController.walletPaymentStatus;
        double totalAmount = cartController.totalPrice ;

        bool isPartialPayment = CheckoutHelper.checkPartialPayment(walletBalance: cartController.walletBalance, bookingAmount: cartController.totalPrice);
        double dueAmount = CheckoutHelper.calculateDueAmount(cartList: cartList, walletPaymentStatus: walletPaymentStatus, walletBalance:cartController.walletBalance, bookingAmount: cartController.totalPrice, referralDiscount: cartController.referralAmount);
        String? schedule = scheduleController.scheduleTime;

        ConfigModel configModel = Get.find<SplashController>().configModel;


        return GetBuilder<CheckOutController>(builder: (checkoutController){
          return Padding( padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),

                child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children:[
                  Text('${ cartController.walletPaymentStatus && isPartialPayment ? "due_amount".tr : "total_price".tr} ', style: ubuntuRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
                  )),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(PriceConverter.convertPrice(  cartController.walletPaymentStatus && isPartialPayment ? dueAmount :totalAmount),
                      style: ubuntuBold.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),
                ]))),

              InkWell(
                child: CustomButton(
                  height: 50,
                  isLoading: checkoutController.isLoading,
                  buttonText: !isPartialPayment && cartController.walletPaymentStatus? "place_booking".tr :'proceed_to_checkout'.tr,
                  onPressed : (widget.pageState == "payment" || checkoutController.currentPageState == PageState.payment) && checkoutController.othersPaymentList.isEmpty && checkoutController.digitalPaymentList.isEmpty ? null : () {
                    if(errorText !=null && scheduleController.selectedScheduleType != ScheduleType.asap ){
                      customSnackBar(errorText.tr);
                    }
                    else if( checkoutController.acceptTerms){
                      AddressModel? addressModel = Get.find<LocationController>().selectedAddress ?? Get.find<LocationController>().getUserAddress();

                      if(Get.find<CartController>().cartList.isEmpty) {

                        Get.offAllNamed(RouteHelper.getMainRoute('home'));
                      }
                      else if(cartController.cartList.isNotEmpty &&  cartController.cartList.first.provider !=null
                          && (cartController.cartList[0].provider?.serviceAvailability == 0 || cartController.cartList[0].provider?.isActive== 0)){

                        Future.delayed(const Duration(milliseconds: 50)).then((value){

                          Future.delayed(const Duration(milliseconds: 500)).then((value){
                            showModalBottomSheet(
                              useRootNavigator: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context, builder: (context) =>  AvailableProviderWidget(
                              subcategoryId:Get.find<CartController>().cartList.first.subCategoryId,
                              showUnavailableError: true,
                            ),);
                          });

                          customSnackBar("your_selected_provider_is_unavailable_right_now".tr,duration: 3);

                        });

                      }

                      else if(checkoutController.currentPageState == PageState.orderDetails && PageState.orderDetails.name == widget.pageState){

                        if(schedule == null && scheduleController.selectedScheduleType != ScheduleType.asap) {
                          customSnackBar("select_your_preferable_booking_time".tr);
                        }
                        else if(scheduleController.selectedScheduleType == ScheduleType.schedule && configModel.content?.scheduleBookingTimeRestriction == 1 && scheduleController.checkValidityOfTimeRestriction(Get.find<SplashController>().configModel.content!.advanceBooking!) != null){
                          customSnackBar(scheduleController.checkValidityOfTimeRestriction(Get.find<SplashController>().configModel.content!.advanceBooking!));
                        }
                        else if(addressModel == null){
                          customSnackBar("add_address_first".tr);
                        }
                        else if((addressModel.contactPersonName == "null" || addressModel.contactPersonName == null || addressModel.contactPersonName!.isEmpty) || (addressModel.contactPersonNumber=="null" || addressModel.contactPersonNumber == null || addressModel.contactPersonNumber!.isEmpty)){
                          customSnackBar("please_input_contact_person_name_and_phone_number".tr);

                        }
                        else{

                          if( !isPartialPayment && cartController.walletPaymentStatus ){

                            checkoutController.placeBookingRequest(
                              paymentMethod: "wallet_payment",
                              schedule: schedule,
                              isPartial: 0,
                              address: addressModel,
                            );

                          }else{
                            checkoutController.updateState(PageState.payment);
                            if(GetPlatform.isWeb) {
                              Get.toNamed(RouteHelper.getCheckoutRoute(
                                'cart',Get.find<CheckOutController>().currentPageState.name,widget.pageState == 'payment' ? widget.addressId : addressModel.id.toString(),
                                reload: false,
                              ));
                            }
                          }
                        }
                      }
                      else if(checkoutController.currentPageState == PageState.payment || PageState.payment.name == widget.pageState){

                        if(checkoutController.selectedPaymentMethod == PaymentMethodName.none){
                          customSnackBar("select_payment_method".tr);
                        }
                        else if(checkoutController.selectedPaymentMethod == PaymentMethodName.cos){
                          checkoutController.placeBookingRequest(
                            paymentMethod: "cash_after_service",
                            schedule: schedule!,
                            isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
                            address: addressModel!,

                          );
                        }
                        else if(checkoutController.selectedPaymentMethod == PaymentMethodName.walletMoney){
                          if(Get.find<CartController>().walletBalance >= Get.find<CartController>().totalPrice){
                            checkoutController.placeBookingRequest(
                                paymentMethod: "wallet_payment",
                                schedule: schedule!,
                                isPartial: 0,
                                address: addressModel!
                            );
                          }
                          else{
                            customSnackBar("insufficient_wallet_balance".tr);
                          }
                        } else if(checkoutController.selectedPaymentMethod == PaymentMethodName.offline){

                          if(checkoutController.selectedOfflineMethod != null && checkoutController.showOfflinePaymentInputData){

                            checkoutController.placeBookingRequest(
                              paymentMethod: "offline_payment",
                              schedule: schedule!,
                              isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
                              address: addressModel!,
                              offlinePaymentId: checkoutController.selectedOfflineMethod?.id,
                              customerInformation:  base64Url.encode(utf8.encode(jsonEncode(checkoutController.offlinePaymentInputFieldValues))),
                            );
                          } else{
                            customSnackBar("provide_offline_payment_info".tr);
                          }

                        }else if( checkoutController.selectedPaymentMethod == PaymentMethodName.digitalPayment){

                          if(checkoutController.selectedDigitalPaymentMethod != null && checkoutController.selectedDigitalPaymentMethod?.gateway != "offline"){
                            _makeDigitalPayment(addressModel, checkoutController.selectedDigitalPaymentMethod, isPartialPayment);
                          }else{
                            customSnackBar("select_any_payment_method".tr);
                          }

                        }
                      }
                      else {
                        if (kDebugMode) {
                          print("In Here");
                        }
                      }
                    }
                    else{
                      customSnackBar('please_agree_with_terms_conditions');
                    }
                  },
                ),
              ),
            ]),
          );
        });
      });
    });
  }

  _makeDigitalPayment(AddressModel? address , DigitalPaymentMethod?  paymentMethod, bool isPartialPayment) {

    String url = '';
    String hostname = html.window.location.hostname!;
    String protocol = html.window.location.protocol;
    String port = html.window.location.port;
    String? path = html.window.location.pathname;


    String? schedule = Get.find<ScheduleController>().scheduleTime;
    String userId = Get.find<UserController>().userInfoModel?.id?? Get.find<SplashController>().getGuestId();
    String encodedAddress = base64Encode(utf8.encode(jsonEncode(address?.toJson())));
    String addressId = (address?.id == "null" || address?.id == null) ? "" : address?.id ?? "";
    String  zoneId = Get.find<LocationController>().getUserAddress()?.zoneId??"";
    String callbackUrl = GetPlatform.isWeb ? "$protocol//$hostname:$port$path" : AppConstants.baseUrl;
    int isPartial = Get.find<CartController>().walletPaymentStatus && isPartialPayment ? 1 : 0;
    String platform = ResponsiveHelper.isWeb() ? "web" : "app" ;

    url = '${AppConstants.baseUrl}/payment?payment_method=${paymentMethod?.gateway}&access_token=${base64Url.encode(utf8.encode(userId))}&zone_id=$zoneId'
        '&service_schedule=$schedule&service_address_id=$addressId&callback=$callbackUrl&service_address=$encodedAddress&is_partial=$isPartial&payment_platform=$platform';

    if (GetPlatform.isWeb) {
      printLog("url_with_digital_payment:$url");
      html.window.open(url, "_self");
    } else {
      printLog("url_with_digital_payment_mobile:$url");
      Get.to(()=> PaymentScreen(url:url, fromPage: "checkout",));
    }
  }
}
