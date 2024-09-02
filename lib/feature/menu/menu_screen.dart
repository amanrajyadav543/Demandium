import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'widget/menu_button.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<BottomNavController>().updateMenuPageIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
    ConfigModel configModel  = Get.find<SplashController>().configModel;
    double ratio =  ResponsiveHelper.isTab(context) ? 1.1 : 1.2;

    final List<MenuModel> menuList = [
      MenuModel(icon: Images.profileIcon, title: 'profile'.tr, route: RouteHelper.getProfileRoute()),
      MenuModel(icon: Images.chatImage, title: 'inbox'.tr, route:isLoggedIn? RouteHelper.getInboxScreenRoute() :  RouteHelper.getNotLoggedScreen(RouteHelper.chatInbox,"inbox")),
      MenuModel(icon: Images.translate, title: 'language'.tr, route: RouteHelper.getLanguageScreen('fromSettingsPage')),
      MenuModel(icon: Images.settings, title: 'settings'.tr, route: RouteHelper.getSettingRoute()),
      MenuModel(icon: Images.bookingsIcon, title: configModel.content?.guestCheckout == 0 || isLoggedIn ? 'bookings'.tr : "track_booking".tr, route: !isLoggedIn && configModel.content?.guestCheckout == 1
          ? RouteHelper.getTrackBookingRoute() : !isLoggedIn ? RouteHelper.getNotLoggedScreen("booking","my_bookings")
          : RouteHelper.getBookingScreenRoute(true)
      ),
      MenuModel(icon: Images.voucherIcon, title: 'vouchers'.tr, route: RouteHelper.getVoucherRoute(fromPage: 'menu')),

      MenuModel(icon: Images.myFavorite, title: 'my_favorite'.tr, route:!isLoggedIn ? RouteHelper.getNotLoggedScreen(RouteHelper.myFavorite,"my_favorite"): RouteHelper.getMyFavoriteScreen()),
      if(configModel.content?.biddingStatus == 1)
        MenuModel(icon: Images.customPostIcon, title: 'my_posts'.tr,
            route: isLoggedIn ? RouteHelper.getMyPostScreen() : RouteHelper.getNotLoggedScreen(RouteHelper.myPost,"my_posts")
        ),
      if(configModel.content!.walletStatus != 0 && isLoggedIn)
        MenuModel(icon: Images.walletMenu, title: 'my_wallet'.tr, route: RouteHelper.getMyWalletScreen()),
      if(configModel.content!.loyaltyPointStatus != 0 && isLoggedIn)
        MenuModel(icon: Images.myPoint, title: 'loyalty_point'.tr, route: RouteHelper.getLoyaltyPointScreen()),

      if(Get.find<SplashController>().configModel.content?.referEarnStatus==1)
        MenuModel(
          title:'refer_and_earn'.tr, icon: Images.shareIcon, route: isLoggedIn ? RouteHelper.getReferAndEarnScreen() : RouteHelper.getNotLoggedScreen(RouteHelper.referAndEarn, "refer_and_earn"),
        ),
      MenuModel(icon: Images.areaMenuIcon, title: 'service_area'.tr, route: RouteHelper.getServiceArea()),

      MenuModel(icon: Images.aboutUs, title: 'about_us'.tr, route: RouteHelper.getHtmlRoute('about_us')),
      MenuModel(icon: Images.helpIcon, title: 'help_&_support'.tr, route: RouteHelper.getSupportRoute()),

      if(configModel.content?.providerSelfRegistration == 1)
        MenuModel(icon: Images.providerImage, title: 'become_a_provider'.tr, route: GetPlatform.isWeb ? '${AppConstants.baseUrl}/provider/auth/sign-up' : RouteHelper.getProviderWebView()),
      MenuModel(icon: Images.privacyPolicyIcon, title: 'privacy_policy'.tr, route: RouteHelper.getHtmlRoute('privacy-policy')),
      if(Get.find<SplashController>().configModel.content!.termsAndConditions != "")
        MenuModel(icon: Images.termsIcon, title: 'terms_and_conditions'.tr, route: RouteHelper.getHtmlRoute('terms-and-condition')),
      if(Get.find<SplashController>().configModel.content!.refundPolicy != "")
        MenuModel(icon: Images.refundPolicy, title: 'refund_policy'.tr, route: RouteHelper.getHtmlRoute('refund_policy')),

      if(Get.find<SplashController>().configModel.content!.cancellationPolicy != "")
        MenuModel(icon: Images.cancellationPolicy, title: 'cancellation_policy'.tr, route: RouteHelper.getHtmlRoute('cancellation_policy')),


    ];
    menuList.add(MenuModel(icon: Images.logout, title: isLoggedIn ? 'logout'.tr : 'sign_in'.tr, route: '', isLogout: true));

    int menuCountInSinglePage = ResponsiveHelper.isTab(context) && menuList.length > 17 ? 18
        : ResponsiveHelper.isTab(context) && menuList.length < 18 ? menuList.length
        : ResponsiveHelper.isMobile(context) && menuList.length > 11 ? 12
        : menuList.length ;

    int totalPageSize = (menuList.length/ menuCountInSinglePage).ceil();

    return PointerInterceptor(
      child: GetBuilder<BottomNavController>(builder: (bottomNavController){
        return Container(
          width: Dimensions.webMaxWidth,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Theme.of(context).cardColor,
          ),
          child: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.keyboard_arrow_down_rounded, size: 30,color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: Get.height * 0.15,
                  maxHeight: Get.height * 0.4
                ),
                child: PageView.builder(
                  onPageChanged: (value) {
                    bottomNavController.updateMenuPageIndex(value, shouldUpdate: true);
                  },
                  itemCount: totalPageSize,
                  itemBuilder: (context, index) => GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:  ResponsiveHelper.isMobile(context) ? 4 : 6,
                      childAspectRatio: (1/ratio),
                      crossAxisSpacing: Dimensions.paddingSizeExtraSmall, mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
                    ),
                    itemCount: totalPageSize == 1 || (bottomNavController.currentMenuPageIndex + 1 < totalPageSize) ? menuCountInSinglePage : (menuList.length - (menuCountInSinglePage * (totalPageSize-1))),
                    itemBuilder: (context, index) {
                      return MenuButton(menu: menuList[( menuCountInSinglePage* bottomNavController.currentMenuPageIndex) + index]);
                    },
                  ),
                ),
              ),

              if(totalPageSize > 1) SizedBox(
                height: 15,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate( totalPageSize, (index) => PagerDot(index: index, currentIndex: bottomNavController.currentMenuPageIndex)
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Text("${'app_version'.tr} ${AppConstants.appVersion}",style: ubuntuMedium.copyWith(color: Theme.of(context).colorScheme.primary),),
              SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeDefault : 0),

            ]),
          ),
        );
      }),
    );
  }
}
