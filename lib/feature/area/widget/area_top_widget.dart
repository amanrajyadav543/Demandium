import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class AreaTopWidget extends StatelessWidget {
  const AreaTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.webMaxWidth,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Image.asset(Images.areaTopIcon, height: 60, width: 50),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text("we_are_available_in_these_areas".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text("get_you_desired_service".tr, style: ubuntuMedium.copyWith( fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor), textAlign: TextAlign.center),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
      ),
    );
  }
}
