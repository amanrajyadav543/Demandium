import 'package:demandium/feature/home/controller/advertisement_controller.dart';
import 'package:demandium/feature/home/repository/advertisement_repo.dart';
import 'package:demandium/feature/notification/repository/notification_repo.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(() => BannerController(bannerRepo: BannerRepo(apiClient: Get.find())));
    Get.lazyPut(() => AdvertisementController(advertisementRepo: AdvertisementRepo(apiClient: Get.find())));
    Get.lazyPut(() => CampaignController( campaignRepo: CampaignRepo(apiClient: Get.find())));
    Get.lazyPut(() => CategoryController(categoryRepo: CategoryRepo(apiClient: Get.find())));
    Get.lazyPut(() => ServiceController(serviceRepo: ServiceRepo(apiClient:Get.find())));
    Get.lazyPut(() => UserController(userRepo: UserRepo(apiClient: Get.find())));
    Get.lazyPut(() => ProviderBookingController(providerBookingRepo: ProviderBookingRepo(apiClient: Get.find())));
    Get.lazyPut(() => ServiceBookingController(serviceBookingRepo: ServiceBookingRepo(sharedPreferences: Get.find(),apiClient: Get.find())));
    Get.lazyPut(() => NotificationController( notificationRepo: NotificationRepo(apiClient:Get.find() , sharedPreferences: Get.find())));
  }
}