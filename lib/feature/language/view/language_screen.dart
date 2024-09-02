import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class LanguageScreen extends StatefulWidget {
  final String fromPage;

  const LanguageScreen({super.key, required this.fromPage}) ;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<LocalizationController>().filterLanguage(shouldUpdate: false, isChooseLanguage: true, fromPage: widget.fromPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar:widget.fromPage != "fromOthers" ? CustomAppBar(title: "language".tr) : null,
      body: GetBuilder<LocalizationController>(
        builder: (localizationController){
          return FooterBaseView(
            isScrollView: (ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context)) ? false: true,
            isCenter: true,
            child: SizedBox(
              width: Dimensions.webMaxWidth,
              child: Stack(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(
                        top: Dimensions.paddingSizeDefault,
                        right: Dimensions.paddingSizeDefault,
                        left: Dimensions.paddingSizeDefault,
                        bottom:(ResponsiveHelper.isMobile(context) || ResponsiveHelper.isTab(context)) ?Dimensions.paddingSizeDefault: 80.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(widget.fromPage != "fromSettingsPage")
                          Image.asset(
                            Images.logo,
                            width: Dimensions.logoSize,
                          ),
                        const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                        Align(
                          alignment:Get.find<LocalizationController>().isLtr ?  Alignment.centerLeft : Alignment.centerRight,
                          child: Text('select_language'.tr,style: ubuntuMedium)),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        GridView.builder(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 4 : 2,
                            childAspectRatio: (1/1),
                          ),
                          itemCount: localizationController.languages.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) => LanguageWidget(
                            languageModel: localizationController.languages[index],
                            localizationController: localizationController, index: index,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Align(
                            alignment:Get.find<LocalizationController>().isLtr ?  Alignment.centerLeft : Alignment.centerRight,
                            child: Text('you_can_change_language'.tr,style: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)),)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.paddingSizeDefault,
                    left: Dimensions.paddingSizeDefault,
                    right: Dimensions.paddingSizeDefault,
                    child: SafeArea(
                      child: CustomButton(
                        onPressed: (){
                          Get.find<SplashController>().disableShowInitialLanguageScreen();
                          localizationController.setLanguage(Locale(
                            localizationController.languages[localizationController.selectedIndex].languageCode!,
                            localizationController.languages[localizationController.selectedIndex].countryCode,),
                            isInitial: true,
                          );
                          if(Get.find<SplashController>().isShowOnboardingScreen()){
                            Get.offNamed(RouteHelper.onBoardScreen);
                          }else{
                            Get.offAllNamed(RouteHelper.getInitialRoute());
                          }
                        },
                        buttonText: 'save'.tr,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}