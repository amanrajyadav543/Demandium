import 'package:demandium/components/custom_loader_widget.dart';
import 'package:demandium/feature/cart/widget/provider_item_view.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class AvailableProviderWidget extends StatefulWidget {
  final String subcategoryId;
  final bool showUnavailableError;
  const AvailableProviderWidget({super.key, required this.subcategoryId, this.showUnavailableError = false});
  @override
  State<AvailableProviderWidget> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<AvailableProviderWidget> {
  @override
  void initState() {
    super.initState();
    Get.find<CartController>().getProviderBasedOnSubcategory(widget.subcategoryId, true);
  }

  @override
  Widget build(BuildContext context) {
    if(ResponsiveHelper.isDesktop(context)) {
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
        backgroundColor: Theme.of(context).cardColor,
      );
    }
    return pointerInterceptor();
  }

  pointerInterceptor(){
    return GetBuilder<CartController>(builder: (cartController){
      List<ProviderData> ? providerList = cartController.providerList;
      return  Padding(
        padding: EdgeInsets.only(top: ResponsiveHelper.isWeb()? 0 :Dimensions.cartDialogPadding),
        child: PointerInterceptor(
          child: Container(
            width: ResponsiveHelper.isDesktop(context) && providerList != null ? Dimensions.webMaxWidth/2 : ResponsiveHelper.isDesktop(context) && providerList == null ? 120 : Dimensions.webMaxWidth,
            padding: const EdgeInsets.all( Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
            ),
            child: providerList != null ? Column(mainAxisSize:  MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

              Column(mainAxisSize: MainAxisSize.min, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(width: Dimensions.paddingSizeLarge,),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                    child: Hero(tag: "provider_image",
                      child: Image.asset(Images.providerImage,width: 50,height: 50,),
                    ),
                  ),
                  Container(
                    height: 40, width: 40, alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white70.withOpacity(0.6),
                      boxShadow:Get.isDarkMode ? null : [BoxShadow(
                        color: Colors.grey[300]!, blurRadius: 2, spreadRadius: 1,
                      )],
                    ),
                    child: InkWell( onTap: () => Get.back(), child: const Icon(Icons.close, color: Colors.black54,),),
                  )]
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: Dimensions.paddingSizeEight),
                  Text("available_providers".tr,
                    style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                    textAlign: TextAlign.center, maxLines: 2,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeMini,),
                  Text(
                    providerList.length > 1 ? "${providerList.length} ${'providers_available'.tr}" : "${providerList.length} ${'provider_available'.tr}",
                    style: ubuntuRegular.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5)
                    ),
                  ),
                ],),
              ],),



              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: Get.height * 0.45
                  ),
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Stack(children: [
                          GestureDetector(
                            onTap: (){
                              cartController.updateProviderSelectedIndex(-1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5),width: 0.5),
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                              child: Row(children: [
                                ClipRRect( borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: Image.asset(Images.providerImage,height: 50,width: 50,),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeDefault,),
                                Expanded(child: Text('${'let'.tr} ${AppConstants.appName} ${'choose_for_you'.tr}'.tr,style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),)),
                              ]),
                            ),
                          ),
                          if(cartController.selectedProviderIndex==-1)
                            Positioned(
                              top: 15,
                              right: Get.find<LocalizationController>().isLtr ? 10 : null,
                              left: Get.find<LocalizationController>().isLtr ? null : 10,
                              child: Icon(Icons.check_circle_rounded,color:Get.isDarkMode?Colors.white60: Theme.of(context).primaryColor,),
                            ),
                        ],),

                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: providerList.length,
                          itemBuilder: (context, index) {
                            return ProviderCartItemView(providerData: providerList[index], index: index);
                          },
                        ),
                      ]),
                    ],),
                  ),
                ),
              ),


              cartController.checkProviderUnavailability() ? Padding(
                padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeSmall),
                child: Text("* ${"your_selected_provider_is_unavailable_right_now".tr} ${'or'.tr} ${'let'.tr} ${AppConstants.appName} ${'choose_for_you'.tr}",
                  style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ) : const SizedBox(),

              CustomButton(height: ResponsiveHelper.isDesktop(context)? 50 : 45,
                onPressed: () async  {
                  await cartController.updateProvider(
                      cartController.selectedProviderIndex !=-1 ? cartController.providerList![cartController.selectedProviderIndex] : null
                  );
                  Get.back();
                },
                isLoading: cartController.isCartLoading,
                buttonText: 'confirm'.tr,
              )
            ]) : SizedBox(height: 150, width: 50, child : CustomLoaderWidget(color: Theme.of(context).colorScheme.primary)),
          ),
        ),
      ) ;

    });
  }
}
