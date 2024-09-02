import 'package:get/get.dart';
import 'package:demandium/components/ripple_button.dart';
import 'package:demandium/components/core_export.dart';


class MenuButton extends StatelessWidget {
  final MenuModel menu;
  const MenuButton({super.key, required this.menu, });

  @override
  Widget build(BuildContext context) {

    int count = ResponsiveHelper.isTab(context) ? 6 : 4;
    double size = ((context.width > Dimensions.webMaxWidth ? Dimensions.webMaxWidth : context.width)/count)-Dimensions.paddingSizeDefault;

    return Stack(
      children: [
        Column(children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            height: size - (size * 0.25),
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            child: Image.asset(menu.icon!, width: size, height: size),
          ),
          const SizedBox(height: Dimensions.paddingSizeEight),
          Text(menu.title!, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center),
        ]),
        Positioned.fill(child: RippleButton(onTap: () async {
          if(menu.isLogout) {
            Get.back();
            if(Get.find<AuthController>().isLoggedIn()) {
              Get.dialog(ConfirmationDialog(
                  icon: Images.logoutIcon,
                  description: 'are_you_sure_to_logout'.tr, isLogOut: true,
                  onYesPressed: () {
                    Get.find<AuthController>().clearSharedData();
                Get.find<AuthController>().logOut();
                Get.find<AuthController>().googleLogout();
                Get.find<AuthController>().signOutWithFacebook();
                Get.find<LocationController>().updateSelectedAddress(null);
                Get.offAllNamed(RouteHelper.getInitialRoute());
                // customSnackBar("logged_out_successfully".tr, isError: false);
              }), useSafeArea: false);
            }else {
              Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
            }
          }
          else if(menu.route!.startsWith('http')) {
            if(await canLaunchUrlString(menu.route!)) {
          launchUrlString(menu.route!, mode: LaunchMode.externalApplication);}
          } else {
            if(menu.route!.contains('/language')){
              Get.back();
              Get.bottomSheet(const ChooseLanguageBottomSheet(), backgroundColor: Colors.transparent, isScrollControlled: true);
            } else {
              Get.offNamed(menu.route!);
            }
          }
        }))
      ],
    );
  }
}

