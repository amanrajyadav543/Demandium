import 'package:get/get.dart';

enum BnbItem {home, bookings, cart, offers, more}
class BottomNavController extends GetxController implements GetxService{
  static BottomNavController get to => Get.find();

  var currentPage = BnbItem.home.obs;
  void changePage(BnbItem bnbItem) {
    currentPage.value = bnbItem;
  }

  int _currentMenuPageIndex = 0;
  int get currentMenuPageIndex => _currentMenuPageIndex;

  void updateMenuPageIndex(int index, {bool shouldUpdate = false}){
    _currentMenuPageIndex = index;
    if(shouldUpdate){
      update();
    }
  }
}
