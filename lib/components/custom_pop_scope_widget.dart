import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class CustomPopScopeWidget extends StatelessWidget {
  final Widget child;
  final bool? canPop;
  final Function()? onPopInvoked;
  const CustomPopScopeWidget({super.key, required this.child, this.onPopInvoked, this.canPop}) ;

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop:  canPop ?? Navigator.canPop(context),
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        if(onPopInvoked != null && context.mounted) {
          onPopInvoked!();
        } else if( !Navigator.canPop(context) && Get.find<LocationController>().getUserAddress() !=null && context.mounted && onPopInvoked == null){
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }


      },
      child: child,
    );
  }
}