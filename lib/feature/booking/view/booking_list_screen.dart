import 'package:get/get.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_item_card.dart';
import 'package:demandium/feature/booking/widget/booking_status_tabs.dart';

class BookingListScreen extends StatefulWidget {
  final bool isFromMenu;
  const BookingListScreen({super.key, this.isFromMenu = false}) ;

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    Get.find<ServiceBookingController>().getAllBookingService(offset: 1,bookingStatus: "all",isFromPagination:false);
    Get.find<ServiceBookingController>().updateBookingStatusTabs(BookingStatusTabs.all, firstTimeCall: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController bookingScreenScrollController = ScrollController();
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(
        isBackButtonExist: widget.isFromMenu? true : false,
        onBackPressed: () => Get.back(),
        title: "my_bookings".tr,
      ),
      body: GetBuilder<ServiceBookingController>(
        builder: (serviceBookingController){
          List<BookingModel>? bookingList = serviceBookingController.bookingList;
          return CustomScrollView(  controller: bookingScreenScrollController, slivers : [

            SliverPersistentHeader(delegate: ServiceRequestSectionMenu(), pinned: true, floating: true,),

            SliverToBoxAdapter(child: SizedBox( height : ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeDefault : 0),),

            serviceBookingController.bookingList != null ? SliverToBoxAdapter(

              child: bookingList!.isNotEmpty ? Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Dimensions.webMaxWidth,
                    minHeight: Get.height * 0.7
                  ),
                  child: PaginatedListView(
                    scrollController:  bookingScreenScrollController,
                    totalSize: serviceBookingController.bookingContent!.total!,
                    onPaginate: (int offset) async => await serviceBookingController.getAllBookingService(
                      offset: offset,
                      bookingStatus: serviceBookingController.selectedBookingStatus.name.toLowerCase(),
                      isFromPagination: true,
                    ),
                    offset: serviceBookingController.bookingContent?.currentPage,
                    itemView: GridView.builder(
                      padding: EdgeInsets.symmetric( horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault,),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ResponsiveHelper.isDesktop(context)? 2 : 1,
                        mainAxisExtent: Get.find<LocalizationController>().isLtr ? 140 : 175,
                        crossAxisSpacing: Dimensions.paddingSizeDefault,
                        mainAxisSpacing : Dimensions.paddingSizeDefault,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: bookingList.length,
                      itemBuilder: (context, index) {
                        return  BookingItemCard(bookingModel: bookingList.elementAt(index), index: index);
                      },
                    ),
                  ),
                ),
              ) : Center(
                child: SizedBox(
                  height: Get.height * 0.7, width: Dimensions.webMaxWidth,
                  child: NoDataScreen(
                    text: 'no_booking_request_available'.tr,
                    type: NoDataType.bookings,
                  ),
                ),
              ),

            ): const SliverToBoxAdapter(
              child: Center(child: SizedBox(width: Dimensions.webMaxWidth,child: BookingListItemShimmer())),
            ),

            SliverToBoxAdapter(child: ResponsiveHelper.isDesktop(context) ? const FooterView() : const SizedBox(),)

          ]);
        },
      ),
    );
  }
}


class BookingListItemShimmer extends StatelessWidget {
  const BookingListItemShimmer({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
        mainAxisExtent: ResponsiveHelper.isDesktop(context)? 130 : 120,
        crossAxisSpacing: Dimensions.paddingSizeDefault,
        mainAxisSpacing :  ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : Dimensions.paddingSizeExtraSmall,
      ),
      shrinkWrap: true, itemCount: 10,
      itemBuilder: (context ,index){
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeSmall- 3,
          horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault,
        ),
        child: Shimmer(child: Container(
          height: 90, width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: Get.isDarkMode ?null : [BoxShadow(color: Colors.grey[300]!, blurRadius: 10, spreadRadius: 1)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded( flex: 2,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container( height: 17,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).shadowColor,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall,),

                Container( height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).shadowColor,
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall,),

                Container( height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ],),
            ),

            const Expanded(child: SizedBox()),

            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container( height: 17, width:  50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Container( height: 15, width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ],)
          ],
          ),
        )),
      );
    },);
  }
}
