import 'package:demandium/feature/onboarding/controller/on_board_pager_controller.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class PagerContent extends StatelessWidget {
  const PagerContent({super.key, required this.image, required this.text, required this.subText, required this.topImage}) ;
  final String image;
  final String text;
  final String subText;
  final String topImage;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardController>(builder: (onBoardingController){
      return onBoardingController.pageIndex == 2 ? Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(Images.onBoardingTopTwo, width : Get.width, fit: BoxFit.cover,),
                Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraMoreLarge),
                  child: Column(mainAxisSize: MainAxisSize.min,children: [

                    SizedBox( child: Image.asset(image, height: Get.height * 0.22)),
                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),

                    Text(text,
                      textAlign: TextAlign.center,
                      style: ubuntuBold.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: Dimensions.fontSizeLarge),
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                      child: Text(subText,
                        textAlign: TextAlign.center,
                        style: ubuntuRegular.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge),
                    CustomButton(buttonText: "get_started".tr, height: 40, width: 150,
                      onPressed: (){
                        _checkPermissionAndNavigate();
                      },
                    )
                  ],),
                )
              ],
            ),
          ),

          SizedBox(
            height: Get.height * 0.25,
            child: Image.asset(Images.onBoardingBottomThree, width: Get.width, fit: BoxFit.fitHeight,),
          )
        ],
      ) : Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(Images.onBoardingTop, width: Get.width, fit: BoxFit.cover,),
              SafeArea(
                child: InkWell(
                  onTap: () {
                    _checkPermissionAndNavigate();
                  },
                  child: Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Text(
                        "skip".tr,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 40,
                right: 40,
                child: Image.asset(topImage,),
              ),
            ],
          ),

          SizedBox(height: Get.height * 0.07,),

          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text(text,
                textAlign: TextAlign.center,
                style: ubuntuBold.copyWith(color: Theme.of(context).colorScheme.primary, fontSize: Dimensions.fontSizeLarge),
              ),
            
              const SizedBox(height: Dimensions.paddingSizeDefault,),
            
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                child: Text(subText,
                  textAlign: TextAlign.center,
                  style: ubuntuRegular.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
            
              const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
            
              Expanded(child: Image.asset(image,)),
            ],),
          ),
        ],
      );
    });
  }
}

void _checkPermissionAndNavigate() async {

  Get.find<SplashController>().disableShowOnboardingScreen();

  LocationPermission permission = await Geolocator.checkPermission();
  if(permission == LocationPermission.denied ) {
    permission = await Geolocator.requestPermission();
  }
  if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    Get.offAllNamed(RouteHelper.getPickMapRoute("",false,"",null,null));
  }else {
    Get.dialog(const CustomLoader(), barrierDismissible: false);
    AddressModel address = await Get.find<LocationController>().getCurrentLocation(true);
    ZoneResponseModel response = await Get.find<LocationController>().getZone(address.latitude!, address.longitude!, false);

    if(response.isSuccess) {
      Get.find<LocationController>().saveAddressAndNavigate(address, false, '', false, true);
    }else {
      Get.back();
      Get.offAllNamed(RouteHelper.getPickMapRoute("",false,"",null,null));
    }
  }
}