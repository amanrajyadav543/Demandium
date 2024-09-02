import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class SettingScreen extends StatelessWidget {

   const SettingScreen({super.key}) ;

  @override
  Widget build(BuildContext context) {
    List<Widget> settingsItems = [
      Container(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeSmall,
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeExtraSmall,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetBuilder<ThemeController>(builder: (themeController){
                return CupertinoSwitch(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: themeController.darkTheme, onChanged: (value){
                  themeController.toggleTheme();
                });
              }),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Text(Get.isDarkMode ? "light_mode".tr:"dark_mode".tr ,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
            ],
          ),
        ),),
      Container(
        padding: const EdgeInsets.fromLTRB(
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeSmall,
          Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeExtraSmall,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: Get.find<ThemeController>().darkTheme ? null : cardShadow,
            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall))
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<AuthController>(builder: (authController){
                return CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.primary,
                    value: authController.isNotificationActive(), onChanged: (value){
                  authController.toggleNotificationSound();
                });
              }),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              Text(
                'notification_sound'.tr,
                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                textAlign: TextAlign.center,

              ),
            ],
          ),
        ),),
    ];

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(
        isBackButtonExist: true,
        bgColor: Theme.of(context).primaryColor, title: 'settings'.tr,),

      body: FooterBaseView(
        isScrollView:true,
        //isCenter:false,
        child: SizedBox(
          width: Dimensions.webMaxWidth,
          child: GridView.builder(
            shrinkWrap: true,
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeLarge ,
              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeLarge ,
              childAspectRatio: 1,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
            ),
            physics:  const NeverScrollableScrollPhysics(),
            itemCount: settingsItems.length,
            padding: const EdgeInsets.only(top: 50 ,right: Dimensions.paddingSizeDefault,left: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeDefault),
            itemBuilder: (context, index) {
              return settingsItems.elementAt(index);
            },
          ),
        ),
      ),
    );
  }

}
