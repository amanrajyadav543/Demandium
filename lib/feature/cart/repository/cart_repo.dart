import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  CartRepo({required this.sharedPreferences,required this.apiClient});


  Future<Response> addToCartListToServer(CartModelBody cartModel) async {
    return await apiClient.postData(AppConstants.addToCart, cartModel.toJson());
  }

  Future<Response> getCartListFromServer() async {
    return await apiClient.getData("${AppConstants.getCartList}&&guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> removeCartFromServer(String cartID) async {
    return await apiClient.deleteData("${AppConstants.removeCartItem}$cartID?guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> removeAllCartFromServer() async {
    return await apiClient.deleteData("${AppConstants.removeAllCartItem}?guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> updateCartQuantity(String cartID, int quantity)async{
    return await apiClient.putData("${AppConstants.updateCartQuantity}$cartID?guest_id=${Get.find<SplashController>().getGuestId()}", { 'quantity': quantity});
  }

  Future<Response> updateProvider(String providerId)async{
    return await apiClient.postData(AppConstants.updateCartProvider,
      { 'provider_id': providerId,
        "_method":"put",
        "guest_id": Get.find<SplashController>().getGuestId()
      });
  }

  Future<Response> getProviderBasedOnSubcategory(String subcategoryId) async {
    return await apiClient.getData("${AppConstants.getProviderBasedOnSubcategory}?sub_category_id=$subcategoryId");
  }

  Future<Response> addRebookToServer(String bookingId) async {
    return await apiClient.postData(AppConstants.rebookApi, {'booking_id' : bookingId, 'guest_id' : Get.find<SplashController>().getGuestId()} );
  }


}