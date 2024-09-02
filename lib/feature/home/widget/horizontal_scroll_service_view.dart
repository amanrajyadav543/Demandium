import 'package:demandium/components/service_widget_vertical.dart';
import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';

class HorizontalScrollServiceView extends GetView<ServiceController> {
  final String? fromPage;
  final List<Service>? serviceList;
  const HorizontalScrollServiceView({super.key, required this.fromPage,required this.serviceList});
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    if(serviceList != null && serviceList!.isEmpty){
      return const SizedBox();
    }else{
      if(serviceList!= null){
        return Stack(
          children: [
            fromPage=='recently_view_services'
            ? ClipPath(
              clipper: TsClip2(),
              child: Container(
                width: double.infinity,
                height: 200,
                color: Theme.of(context).primaryColor,
              ),
            ): fromPage == 'popular_services' ?
            Container(height: 330,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.07),
                image: DecorationImage(
                  image: AssetImage(
                   Images.popularServicesBackgroundImage
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.5
                ),
              ),
            ): const SizedBox(),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeExtraSmall,
                  ),
                  child: TitleWidget(
                    textDecoration: TextDecoration.underline,
                    title: fromPage!,
                    onTap: () => fromPage == "popular_services" ? Get.toNamed(RouteHelper.getSearchResultRoute(fromPage: "popular")) : Get.toNamed(RouteHelper.allServiceScreenRoute(fromPage!)),

                  ),
                ),
                SizedBox(
                  height: Get.find<LocalizationController>().isLtr ?ResponsiveHelper.isMobile(context) ? 260 :270 :  270,
                  child:ListView.builder(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeExtraSmall,top: Dimensions.paddingSizeExtraSmall),
                    itemCount: serviceList!.length > 10 ? 10 : serviceList!.length,
                    itemBuilder: (context, index){
                      return Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                        child: SizedBox(
                          width: ResponsiveHelper.isTab(context)? 250 : Get.width / 2.3,
                          child: ServiceWidgetVertical(service: serviceList![index], fromType: '',fromPage: fromPage??""),
                        ),
                      );
                    },
                  ) ,
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault,)
              ],
            ),
          ],
        );
      }
      else{
        return const PopularServiceShimmer(enabled: true,);
      }
    }
  }
}


class TsClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height/2);
    path.quadraticBezierTo(
        size.width / 1.3, size.height+70, size.width, size.height/1.3);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class PopularServiceShimmer extends StatelessWidget {
  final bool enabled;
  const PopularServiceShimmer({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall,left: Dimensions.paddingSizeSmall,top: Dimensions.paddingSizeSmall,),
        itemCount: 10,
        itemBuilder: (context, index){
          return Container(
            height: 80, width: ResponsiveHelper.isTab(context)? 250 : Get.width / 2.3,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall,bottom: 10,top: 10),
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: Get.isDarkMode?null:[BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
            ),
            child: Shimmer(
              duration: const Duration(seconds: 1),
              interval: const Duration(seconds: 1),
              enabled: enabled,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                Container(
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      color: Theme.of(context).shadowColor
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 15, width: 100, color: Theme.of(context).shadowColor),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 130, color: Theme.of(context).shadowColor),
                      const SizedBox(height: 5),
                      Container(height: 10, width: 130, color: Theme.of(context).shadowColor),

                    ]),
                  ),
                ),

              ]),
            ),
          );
        },
      ),
    );
  }
}

