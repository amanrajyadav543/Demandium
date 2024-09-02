import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class FavoriteTabBarView extends StatelessWidget {
  final TabController? tabController;
  const FavoriteTabBarView({super.key,this.tabController});

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.isDesktop(context) ? Container(
      width: Dimensions.webMaxWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight:  Radius.circular(15))
      ),
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
      child: Center(
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),),
          ),
          child: TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            controller: tabController,
            tabs: [
              Tab(child: Text('services'.tr),),
              Tab(child: Text('providers'.tr),),
            ],

          ),
        ),
      ),
    ) : Container(
      height: 45,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.0),
          border: Border(bottom: BorderSide(color: Theme.of(context).primaryColor, width: 0.5),),
        ),
        child: TabBar(
          unselectedLabelColor: Colors.grey,
          physics: const NeverScrollableScrollPhysics(),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelColor: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          controller: tabController,
          tabs: [
            Tab(child: Text('services'.tr),),
            Tab(child: Text('providers'.tr),),
          ],

        ),
      ),
    );
  }
}
