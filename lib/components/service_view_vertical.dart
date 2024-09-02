import 'package:demandium/components/custom_shaking_widget.dart';
import 'package:get/get.dart';
import 'package:demandium/components/service_widget_vertical.dart';
import 'package:demandium/components/core_export.dart';

class ServiceViewVertical extends GetView<ServiceController> {
  final List<Service>? service;
  final EdgeInsetsGeometry? padding;
  final bool? isScrollable;
  final int? shimmerLength;
  final String? noDataText;
  final String? type;
  final NoDataType? noDataType;
  final GlobalKey<CustomShakingWidgetState>?  signInShakeKey;
  final String? fromPage;

  final Function(String type)? onVegFilterTap;
  const ServiceViewVertical( {super.key, this.fromPage="", required this.service, this.isScrollable = false, this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(Dimensions.paddingSizeSmall), this.noDataText, this.type, this.onVegFilterTap, this.noDataType, this.signInShakeKey});

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 1;

    isNull = service == null;
    if(!isNull){
      length = service!.length;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
        children: [
          isNull == false &&  length != 0 ?
          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeLarge,
              mainAxisSpacing:  Dimensions.paddingSizeLarge,
              mainAxisExtent: ResponsiveHelper.isDesktop(context) ?  270 : 240 ,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2 ),
            physics: isScrollable! ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            shrinkWrap: isScrollable! ? false : true,
            itemCount: service!.length,
            padding: padding,
            itemBuilder: (context, index) {
              return ServiceWidgetVertical(service: service![index], fromType: '',fromPage: fromPage??"", signInShakeKey: signInShakeKey,);
            },
          ) : length == 0 ? Center(
            child: SizedBox(height: ResponsiveHelper.isDesktop(context) ?  MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 0.55,
              child: noDataType == NoDataType.offers ? WebShadowWrap(
                child: NoDataScreen(
                  text: "no_offer_found".tr,
                  type:  NoDataType.offers,
                ),
              ) : ServiceNotAvailableScreen(fromPage: fromPage ?? "",),
            ),
          ) : GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.paddingSizeDefault,
              mainAxisSpacing:  Dimensions.paddingSizeDefault,
              mainAxisExtent: ResponsiveHelper.isDesktop(context) ?  270 : 240 ,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 5 : ResponsiveHelper.isTab(context) ? 3 : 2,
            ),
            physics: isScrollable! ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
            shrinkWrap: isScrollable! ? false : true,
            itemCount: shimmerLength,
            padding: padding,
            itemBuilder: (context, index) {
              return ServiceShimmer(isEnabled: true, hasDivider: index != shimmerLength! - 1);
        },
      ),
    ]);
  }
}