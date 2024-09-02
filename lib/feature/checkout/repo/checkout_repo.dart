import 'dart:convert';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';


class CheckoutRepo extends GetxService {
  final ApiClient apiClient;
  CheckoutRepo({required this.apiClient});

  Future<Response> getPostDetails(String postId, String bidId) async {
    return await apiClient.getData('${AppConstants.getPostDetails}/$postId?post_bid_id=$bidId');
  }

  Future<Response> getOfflinePaymentMethod() async {
    Response response = await apiClient.getData(AppConstants.offlinePaymentUri);
    return response;
  }


  Future<Response> placeBookingRequest({
    required String paymentMethod, String? serviceAddressID, required AddressModel serviceAddress,String? schedule,
    required String zoneId, required int isPartial, required String offlinePaymentId, required String customerInformation
  }) async {
    String address = jsonEncode(serviceAddress);
    return await apiClient.postData(AppConstants.placeRequest, {
      "payment_method" : paymentMethod,
      "zone_id" : zoneId,
      "service_schedule" : schedule,
      "service_address_id" : serviceAddressID,
      "guest_id" : Get.find<SplashController>().getGuestId(),
      "service_address" : address,
      "is_partial" : isPartial,
      "offline_payment_id" : offlinePaymentId,
      "customer_information" : customerInformation
    });
  }
}
