
import 'package:get/get.dart';

class ServiceAreaBindings extends Bindings {
  @override
  void dependencies() async {
    //Get.lazyPut(() => ServiceAreaController(serviceAreaRepo: ServiceAreaRepo(apiClient: Get.find(), sharedPreferences: Get.find())));

  }
}