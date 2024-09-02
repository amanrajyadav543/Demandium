import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatefulWidget {
  final AddressModel ? previousAddress;
  final bool showServiceNotAvailableDialog;
  final int pageIndex;
  const  BottomNavScreen({super.key, required this.pageIndex, this.previousAddress, required this.showServiceNotAvailableDialog});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _pageIndex = 0;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.pageIndex;

    if(_pageIndex==1){
      Get.find<BottomNavController>().changePage(BnbItem.bookings);
    }else if(_pageIndex==2){
      Get.find<BottomNavController>().changePage(BnbItem.cart);
    }
    else if(_pageIndex==3){
      Get.find<BottomNavController>().changePage(BnbItem.offers);
    }else{
      Get.find<BottomNavController>().changePage(BnbItem.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = Get.find<AuthController>().isLoggedIn();
    return CustomPopScopeWidget(
      canPop: ResponsiveHelper.isWeb() ? true : false,
      onPopInvoked: () {
        if (Get.find<BottomNavController>().currentPage.value != BnbItem.home) {
          Get.find<BottomNavController>().changePage(BnbItem.home);
        } else {
          if (_canExit) {
            if(!GetPlatform.isWeb) {
              exit(0);
            }
          } else {
            customSnackBar('back_press_again_to_exit'.tr, isError: false);
            _canExit = true;
            Timer(const Duration(seconds: 2), () {
              _canExit = false;
            });
          }
        }
      },

      child: Scaffold(
        floatingActionButton: ResponsiveHelper.isDesktop(context) ? null : InkWell(
          onTap: () => Get.toNamed(RouteHelper.getCartRoute()),
          child: Container(
            height: 70, width: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _pageIndex == 2 ? null : Get.isDarkMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
              gradient: _pageIndex == 2 ? const LinearGradient(
                colors: [Color(0xFFFBBB00), Color(0xFFFF833D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ) : null,
            ),
            child: CartWidget(color: Get.isDarkMode ? Theme.of(context).primaryColorLight : Colors.white, size: 30),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,

        bottomNavigationBar: ResponsiveHelper.isDesktop(context) ? const SizedBox() :
        SafeArea(
          child: Container(
            height: ResponsiveHelper.isMobile(context) ?  55  : 60 + MediaQuery.of(context).padding.top,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            color:Get.isDarkMode ? Theme.of(context).cardColor.withOpacity(.5) : Theme.of(context).primaryColor,
            child: Row(children: [

              _bnbItem(
                icon: Images.home, bnbItem: BnbItem.home, context: context,
                onTap: () => Get.find<BottomNavController>().changePage(BnbItem.home),
              ),

              _bnbItem(
                icon: Images.bookings, bnbItem: BnbItem.bookings, context: context,
                onTap: () {
                  if (!isUserLoggedIn && Get.find<SplashController>().configModel.content?.guestCheckout == 1) {
                    Get.toNamed(RouteHelper.getTrackBookingRoute());
                  } else  if(!isUserLoggedIn){
                    Get.toNamed(RouteHelper.getNotLoggedScreen("booking","my_bookings"));
                  } else {
                    Get.find<BottomNavController>().changePage(BnbItem.bookings);
                  }
                },
              ),

              _bnbItem(
                icon: '', bnbItem: BnbItem.cart, context: context,
                onTap: () {
                  if (!isUserLoggedIn) {
                    Get.toNamed(
                        RouteHelper.getSignInRoute(RouteHelper.main));
                  } else {
                    Get.find<BottomNavController>().changePage(BnbItem.cart);
                  }
                },
              ),

              _bnbItem(
                icon: Images.offerMenu, bnbItem: BnbItem.offers, context: context,
                onTap: () => Get.find<BottomNavController>().changePage(BnbItem.offers),
              ),

              _bnbItem(
                icon: Images.menu, bnbItem: BnbItem.more,context: context,
                onTap: () => Get.bottomSheet(const MenuScreen(),
                  backgroundColor: Colors.transparent, isScrollControlled: true,
                ),

              ),
            ]),
          ),
        ),

        body: Obx(() => _bottomNavigationView(widget.previousAddress, widget.showServiceNotAvailableDialog)),

      ),
    );
  }

  Widget _bnbItem({required String icon, required BnbItem bnbItem, required GestureTapCallback onTap, context}) {
    return Obx(() => Expanded(
      child: InkWell(
        onTap: bnbItem != BnbItem.cart ? onTap : null,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          icon.isEmpty ? const SizedBox(width: 20, height: 20) : Image.asset(icon, width: 18, height: 18,
            color: Get.find<BottomNavController>().currentPage.value == bnbItem ? Colors.white : Colors.white60,
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(bnbItem != BnbItem.cart ? bnbItem.name.tr : '',
            style: ubuntuRegular.copyWith( fontSize: Dimensions.fontSizeSmall,
              color: Get.find<BottomNavController>().currentPage.value == bnbItem ? Colors.white : Colors.white60,
            ),
          ),

        ]),
      ),
    ));
  }

  _bottomNavigationView(AddressModel? previousAddress, bool showServiceNotAvailableDialog) {
    PriceConverter.getCurrency();
    switch (Get.find<BottomNavController>().currentPage.value) {
      case BnbItem.home:
        return HomeScreen(addressModel: previousAddress, showServiceNotAvailableDialog: showServiceNotAvailableDialog,);
      case BnbItem.bookings:
        if (!Get.find<AuthController>().isLoggedIn()) {
          break;
        } else {
          return const BookingListScreen();
        }
      case BnbItem.cart:
        if (!Get.find<AuthController>().isLoggedIn()) {
          break;
        } else {
          return Get.toNamed(RouteHelper.getCartRoute());
        }
      case BnbItem.offers:
        return const OfferScreen();
      case BnbItem.more:
        break;
    }
  }
}

