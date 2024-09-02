import 'package:get/get.dart';
import 'package:demandium/feature/profile/model/profile_cart_item_model.dart';
import 'package:demandium/components/core_export.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({super.key}) ;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    if(Get.find<AuthController>().isLoggedIn()){
      Get.find<UserController>().getUserInfo(reload: false);
    }
  }
  @override
  Widget build(BuildContext context) {

    final profileCartModelList = [
      ProfileCardItemModel( 'my_address'.tr, Images.address,Get.find<AuthController>().isLoggedIn() ?
      RouteHelper.getAddressRoute('fromProfileScreen') : RouteHelper.getNotLoggedScreen(RouteHelper.profile,"profile"),
      ),
      ProfileCardItemModel(
        'notifications'.tr, Images.notification, RouteHelper.getNotificationRoute(),
      ),
      if(!Get.find<AuthController>().isLoggedIn() )
      ProfileCardItemModel(
        'sign_in'.tr, Images.logout, RouteHelper.getSignInRoute(RouteHelper.profile),
      ),


      if(Get.find<AuthController>().isLoggedIn() )
        ProfileCardItemModel(
          'suggest_new_service'.tr, Images.suggestServiceIcon,RouteHelper.getNewSuggestedServiceScreen() ,
        ),

      if(Get.find<AuthController>().isLoggedIn() )
        ProfileCardItemModel(
          'delete_account'.tr, Images.accountDelete, 'delete_account',
        ),

      if(Get.find<AuthController>().isLoggedIn() )
        ProfileCardItemModel(
        'logout'.tr, Images.logout, 'sign_out',
      ),

    ];

    return CustomPopScopeWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: CustomAppBar(
          title: 'profile'.tr,
          centerTitle: true,
          bgColor: Theme.of(context).primaryColor,
          isBackButtonExist: true,
          onBackPressed: (){
            if(Navigator.canPop(context)){
              Get.back();
            }else{
              Get.offAllNamed(RouteHelper.getMainRoute("home"));
            }
          },
        ),

        body: GetBuilder<UserController>(
          builder: (userController) {
            return userController.userInfoModel == null  && Get.find<AuthController>().isLoggedIn() ?
            const Center(child: CircularProgressIndicator()) :
            FooterBaseView(
              child: WebShadowWrap(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileHeader(userInfoModel: userController.userInfoModel,),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                        childAspectRatio: 6,
                        crossAxisSpacing: Dimensions.paddingSizeExtraLarge,
                        mainAxisSpacing: Dimensions.paddingSizeSmall,
                      ),
                      itemCount: profileCartModelList.length,
                      itemBuilder: (context, index) {
                        return ProfileCardItem(
                          title: profileCartModelList[index].title,
                          leadingIcon: profileCartModelList[index].loadingIcon,
                          onTap: () {
                            if(profileCartModelList[index].routeName == 'sign_out'){
                              if(
                              Get.find<AuthController>().isLoggedIn()) {
                                Get.dialog(ConfirmationDialog(
                                    icon: Images.logoutIcon, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: ()async {
                                  Get.find<AuthController>().clearSharedData();
                                  Get.find<AuthController>().googleLogout();
                                  Get.find<AuthController>().signOutWithFacebook();
                                  Get.find<AuthController>().signOutWithFacebook();
                                  Get.offAllNamed(RouteHelper.getInitialRoute());
                                }), useSafeArea: false);
                              }else {
                                Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                              }
                            }else if(profileCartModelList[index].routeName == 'delete_account'){
                              Get.dialog(
                                  ConfirmationDialog(
                                      icon: Images.deleteProfile,
                                      title: 'are_you_sure_to_delete_your_account'.tr,
                                      description: 'it_will_remove_your_all_information'.tr,
                                      isLogOut: true,
                                      yesText: 'delete',
                                      noText: 'cancel',
                                      descriptionTextColor: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
                                      onYesPressed: () => userController.removeUser()),
                                  useSafeArea: false
                              );
                            }
                            else{
                              Get.toNamed(profileCartModelList[index].routeName);
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height:Dimensions.paddingSizeDefault,)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

