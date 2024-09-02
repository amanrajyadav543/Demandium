import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class ChooseLanguageBottomSheet extends StatelessWidget {
  const ChooseLanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: GetBuilder<LocalizationController>(
        initState: (_) {
          Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
        },
        builder: (localizationController){
          return Container(
            width: Dimensions.webMaxWidth,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Get.isDarkMode?Theme.of(context).cardColor:Theme.of(context).colorScheme.surface,
            ),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Container(
                      height: 5, width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).hintColor.withOpacity(0.15)
                      ),
                    ),
                    const SizedBox(height:Dimensions.paddingSizeExtraLarge),
                    Text("select_language".tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: Get.height * 0.5,
                        minHeight: Get.height * 0.1,
                      ),
                      child: ListView.builder(
                          itemCount: localizationController.languages.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) => InkWell (
                            onTap: () {
                              localizationController.setSelectIndex(index);
                            },
                            child: Container (
                              height: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                  border: Border.all(color: localizationController.selectedIndex == index ? Theme.of(context).primaryColor.withOpacity(0.15) : Colors.transparent ),
                                  color:  localizationController.selectedIndex == index ? Get.isDarkMode? Colors.grey.withOpacity(0.2) : Theme.of(context).primaryColor.withOpacity(0.03) : Colors.transparent
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.asset(localizationController.languages[index].imageUrl!, width: 36, height: 36),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Text(localizationController.languages[index].languageName!, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                ],
                              ),

                            ),
                          )
                      ),
                    ),

                    GetBuilder<LocalizationController>(builder: (localizationController){
                      return  CustomButton(
                        buttonText: 'select'.tr,
                        margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        onPressed: () {
                          Get.find<SplashController>().disableShowInitialLanguageScreen();
                          if(localizationController.languages.isNotEmpty && localizationController.selectedIndex != -1) {
                            localizationController.setLanguage(
                                Locale(
                                  localizationController.languages[localizationController.selectedIndex].languageCode!,
                                  localizationController.languages[localizationController.selectedIndex].countryCode,
                            ));
                            Get.back();
                            Get.offAllNamed(RouteHelper.getMainRoute('home'));
                          }else {
                            customSnackBar('select_a_language'.tr);
                          }
                        },
                      );
                    })
                  ],
                ),


                SizedBox(height: ResponsiveHelper.isMobile(context) ? Dimensions.paddingSizeSmall : 0),
              ]),
            ),
          );
        },
      ),
    );
  }
}
