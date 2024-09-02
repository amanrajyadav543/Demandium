import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/booking/widget/booking_otp_widget.dart';
import 'package:demandium/feature/booking/widget/booking_screen_shimmer.dart';
import 'package:demandium/feature/booking/widget/booking_summery_widget.dart';
import 'package:get/get.dart';


class WebBookingDetailsScreen extends StatelessWidget {
  final TabController? tabController;
  const WebBookingDetailsScreen({super.key, this.tabController}) ;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FooterBaseView(
        child: GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){

          if(bookingDetailsController.bookingDetailsContent !=null){
            return Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column( mainAxisAlignment : MainAxisAlignment.start, children: [

                  BookingDetailsTopCard(bookingDetailsContent: bookingDetailsController.bookingDetailsContent!),

                  BookingTabBar(tabController: tabController),

                  SizedBox(
                    height: 650,
                    child: TabBarView(controller: tabController, children: [
                      WebBookingDetailsSection(bookingDetailsContent: bookingDetailsController.bookingDetailsContent!,),
                      const BookingHistory()]),
                  ),
                ],
                ),
              ),
            );
          }else{
            return const Center(child: SizedBox(width: Dimensions.webMaxWidth,child: BookingScreenShimmer()));
          }

        }),
      ),
    );

  }



}

class BookingDetailsTopCard extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;
  const BookingDetailsTopCard({super.key, required this.bookingDetailsContent}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).colorScheme.primary.withOpacity(0.07) : Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(Dimensions.radiusLarge),
            bottomRight: Radius.circular(Dimensions.radiusLarge),
          )
      ),
      child: Column( children: [
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'booking'.tr} # ',
              style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            Text(bookingDetailsContent.readableId!.toString(),textDirection: TextDirection.ltr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ],
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${'booking_place'.tr} : ',
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            Text(DateConverter.dateMonthYearTimeTwentyFourFormat(DateConverter.isoUtcStringToLocalDate(bookingDetailsContent.createdAt!.toString())),textDirection: TextDirection.ltr,
              style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
          ],
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${'service_scheduled_date'.tr} : ",
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
            ),
            Text(DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.tryParse(bookingDetailsContent.serviceSchedule!)!),
              style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
              textDirection:  TextDirection.ltr,),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall,),
        SizedBox(
          width: Dimensions.webMaxWidth/2,
          child: RichText(
            textAlign: TextAlign.center,
            text:  TextSpan(
              text: '${'address'.tr} : ',
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color,),
              children: [
                TextSpan(
                  text: bookingDetailsContent.serviceAddress != null? bookingDetailsContent.serviceAddress!.address! : 'no_address_found'.tr,
                  style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeSmall,),
        RichText(
          text:  TextSpan(
            text: '${'booking_status'.tr} : ',
            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color),
            children: [
              TextSpan(
                  text: bookingDetailsContent.bookingStatus!.tr,
                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color:  Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
        Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
      ],),
    );
  }
}

class WebBookingDetailsSection extends StatelessWidget {
  final BookingDetailsContent bookingDetailsContent;
  const WebBookingDetailsSection({super.key, required this.bookingDetailsContent}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Expanded(child: SizedBox(height: 630,
              child: SingleChildScrollView(child: BookingSummeryWidget(bookingDetailsContent: bookingDetailsContent),
              ),
            )),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(
              child: Column( mainAxisAlignment: MainAxisAlignment.start, children: [


                (Get.find<SplashController>().configModel.content!.confirmationOtpStatus! && (bookingDetailsContent.bookingStatus == "accepted" || bookingDetailsContent.bookingStatus== "ongoing")) ?
                BookingOtpWidget(bookingDetailsContent: bookingDetailsContent) : const SizedBox(),

                (Get.find<SplashController>().configModel.content!.confirmationOtpStatus! && (bookingDetailsContent.bookingStatus == "accepted" || bookingDetailsContent.bookingStatus== "ongoing")) ?
                 const SizedBox() : const SizedBox(height: Dimensions.paddingSizeEight),

                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)), boxShadow: Get.find<ThemeController>().darkTheme ? null : searchBoxShadow
                  ),//boxShadow: shadow),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('payment_method'.tr, style:ubuntuBold.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!, decoration: TextDecoration.none,
                      )),
                      const SizedBox(height: Dimensions.radiusDefault),

                      Text(
                          bookingDetailsContent.paymentMethod!.tr,
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: Dimensions.radiusDefault),

                      Text(
                          '${'transaction_id'.tr} : ${bookingDetailsContent.transactionId?.tr  ?? ''}',
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6)),
                          overflow: TextOverflow.ellipsis),
                    ],
                    ),

                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text( '${bookingDetailsContent.isPaid == 0 ? 'unpaid'.tr: 'paid'.tr} ',
                          style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault,
                              color: bookingDetailsContent.isPaid == 0?Theme.of(context).colorScheme.error : Colors.green, decoration: TextDecoration.none)
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                            PriceConverter.convertPrice(bookingDetailsContent.totalBookingAmount!.toDouble(),isShowLongPrice: true),
                            style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary,)),
                      ),

                    ],
                    ),
                  ],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),


                //const BookingCancelButton(),


                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  bookingDetailsContent.provider != null ? SizedBox(
                    height: 165, width: 285,
                    child: Container(
                      width:double.infinity,
                      decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)), boxShadow: Get.find<ThemeController>().darkTheme ? null : searchBoxShadow
                      ),//boxShadow: shadow),
                      child: Column(
                        children: [
                          Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Text("provider_info".tr, style: ubuntuMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge!.color!))
                          ),
                          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),


                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
                            child: SizedBox(
                              width: Dimensions.imageSize,
                              height: Dimensions.imageSize,
                              child:  CustomImage(image:"${bookingDetailsContent.provider?.logoFullPath}"),

                            ),
                          ),
                          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
                          Text("${bookingDetailsContent.provider?.companyName}",style:ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
                          Text("${bookingDetailsContent.provider?.companyPhone}",style:ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
                        ],
                      ),
                    ),
                  ) : const SizedBox(),

                  bookingDetailsContent.serviceman != null ?
                  SizedBox(
                    height: 165, width: 285,
                    child: Container(
                      width:double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall)),
                        color: Theme.of(context).primaryColor.withOpacity(0.05),
                      ),
                      child: Column(
                        children: [
                          Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Text("service_man_info".tr, style: ubuntuMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).textTheme.bodyLarge!.color!))
                          ),
                          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),


                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraLarge)),
                            child: SizedBox(
                              width: Dimensions.imageSize,
                              height: Dimensions.imageSize,
                              child:  CustomImage(image: bookingDetailsContent.serviceman?.user?.profileImageFullPath ??"" ),

                            ),
                          ),
                          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
                          Text("${bookingDetailsContent.serviceman!.user?.firstName} ${bookingDetailsContent.serviceman!.user?.lastName}",style:ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
                          Text("${bookingDetailsContent.serviceman!.user!.phone}",style:ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                          Gaps.verticalGapOf(Dimensions.paddingSizeDefault),
                        ],
                      ),
                    ),
                  ) : const SizedBox(),
                ],
                ),

              ],
              ),
            ),


          ])
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Get.find<AuthController>().isLoggedIn() ? GetBuilder<BookingDetailsController>(builder: (bookingDetailsController){
        if(bookingDetailsController.bookingDetailsContent !=null ){
          return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Expanded(child: SizedBox()),
            Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [

                FloatingActionButton( hoverColor: Colors.transparent, elevation: 0.0,
                  backgroundColor: Theme.of(context).colorScheme.primary, onPressed: () {
                    BookingDetailsContent bookingDetailsContent = bookingDetailsController.bookingDetailsContent!;

                    if (bookingDetailsContent.provider != null ) {
                      showModalBottomSheet( useRootNavigator: true, isScrollControlled: true,
                        backgroundColor: Colors.transparent, context: context, builder: (context) => CreateChannelDialog(
                          customerID: bookingDetailsContent.customerId,
                          providerId: bookingDetailsContent.provider?.userId,
                          serviceManId: bookingDetailsContent.serviceman?.userId ,
                          referenceId: bookingDetailsContent.readableId.toString(),
                          providerData: bookingDetailsContent.provider,
                        ),
                      );
                    } else {
                      customSnackBar('provider_or_service_man_assigned'.tr);
                    }
                  },
                  child: Icon(Icons.message_rounded, color: Theme.of(context).primaryColorLight),
                ),
              ]),
            ),

            !ResponsiveHelper.isDesktop(context) && bookingDetailsController.bookingDetailsContent!.bookingStatus == 'completed' ?
            Row(
              children: [
                Expanded(
                  child: CustomButton (radius: 0, buttonText: 'review'.tr, onPressed: () {
                    showModalBottomSheet(context: context,
                      useRootNavigator: true, isScrollControlled: true,
                      backgroundColor: Colors.transparent, builder: (context) => ReviewRecommendationDialog(
                        id: bookingDetailsController.bookingDetailsContent!.id!,
                      ),
                    );},
                  ),
                ),

                Container(
                  width: 3, height: 50,
                  color: Theme.of(context).disabledColor,
                ),

                GetBuilder<ServiceBookingController>(
                    builder: (serviceBookingController) {
                      return Expanded(
                        child: serviceBookingController.isLoading ? const Center(child: CircularProgressIndicator()) : CustomButton (radius: 0, buttonText: 'rebook'.tr,  onPressed: () {
                          serviceBookingController.checkCartSubcategory(bookingDetailsController.bookingDetailsContent!.id!, bookingDetailsController.bookingDetailsContent!.subCategoryId!);

                        },
                        ),
                      );
                    }
                ),
              ],
            )
                : const SizedBox()

          ]);
        }else{
          return const SizedBox();
        }
      }) : null,
    );
  }
}


