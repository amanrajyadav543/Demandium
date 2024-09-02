import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/favorite/controller/my_favorite_controller.dart';
import 'package:demandium/feature/favorite/widget/favorite_provider_list_view.dart';
import 'package:demandium/feature/favorite/widget/favorite_service_list_view.dart';
import 'package:demandium/feature/favorite/widget/favorite_tabbar_view.dart';
import 'package:get/get.dart';

class MyFavoriteScreen extends StatefulWidget {
  final String? fromPage;
  const MyFavoriteScreen({super.key, this.fromPage}) ;

  @override
  State<MyFavoriteScreen> createState() => _MyFavoriteScreenState();
}

class _MyFavoriteScreenState extends State<MyFavoriteScreen> with SingleTickerProviderStateMixin {

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    Get.find<MyFavoriteController>().getFavoriteServiceList(1, true);
    Get.find<MyFavoriteController>().getProviderList(1, true);
  }


  @override
  Widget build(BuildContext context) {
    return CustomPopScopeWidget(
      onPopInvoked: (){
        Get.offAllNamed(RouteHelper.getInitialRoute());
      },
      child: Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
        appBar: CustomAppBar(
          title: "my_favorite".tr,
          onBackPressed: () {
            if(widget.fromPage == 'fromNotification'){
              Get.offAllNamed(RouteHelper.getInitialRoute());
            }else{
              if(Navigator.canPop(context)){
                Get.back();
              }else{
                Get.offAllNamed(RouteHelper.getInitialRoute());
              }
            }
          },
        ),
        body: FooterBaseView(
          isScrollView: ResponsiveHelper.isDesktop(context) ? true : false,
          child: GetBuilder<MyFavoriteController>(builder: (myFavoriteController){
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  children: [

                    FavoriteTabBarView(tabController: tabController,),

                    SizedBox(
                      height : ResponsiveHelper.isDesktop(context) ? Get.height * 0.8 : Get.height * 0.83,
                      child: TabBarView( controller: tabController, children: const [
                        FavoriteServiceListView(),
                        FavoriteProviderListView(),
                      ]),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
