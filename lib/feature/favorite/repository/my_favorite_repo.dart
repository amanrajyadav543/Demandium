import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';


class MyFavoriteRepo {
  final ApiClient apiClient;
  MyFavoriteRepo({required this.apiClient});

  Future<Response> getFavoriteServiceList(int offset) async {
    return await apiClient.getData('${AppConstants.getFavoriteServiceList}?offset=$offset&limit=10');
  }

  Future<Response> getFavoriteProviderList(int offset) async {
    return await apiClient.getData('${AppConstants.getFavoriteProviderList}?offset=$offset&limit=10');
  }

  Future<Response> removeFavoriteService(String serviceId) async {
    return await apiClient.postData('${AppConstants.removeFavoriteService}/$serviceId', {});
  }

  Future<Response> removeFavoriteProvider(String providerId) async {
    return await apiClient.postData('${AppConstants.removeFavoriteProvider}/$providerId', {});
  }



}