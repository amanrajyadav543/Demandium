import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';


class ServiceOverview extends StatelessWidget {
  final String description;
  const ServiceOverview({super.key, required this.description}) ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebShadowWrap(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeEight),
          width: Dimensions.webMaxWidth,
          constraints:  ResponsiveHelper.isDesktop(context) ? BoxConstraints(
            minHeight: !ResponsiveHelper.isDesktop(context) && Get.size.height < 600 ? Get.size.height : Get.size.height - 550,
          ) : null,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              color: ResponsiveHelper.isMobile(context) ?  Theme.of(context).cardColor:Colors.transparent,
              child: HtmlWidget(description)),
        ),
      ),
    );
  }
}