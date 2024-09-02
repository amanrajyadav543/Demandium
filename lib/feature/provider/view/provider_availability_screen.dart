import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/provider/widgets/provider_details_top_card.dart';
import 'package:get/get.dart';

class ProviderAvailabilityScreen extends StatelessWidget {
  final String subCategories;
  final String providerId;
  const ProviderAvailabilityScreen({super.key, required this.subCategories, required this.providerId}) ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'provider_availability'.tr),
      endDrawer:ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      body: GetBuilder<ProviderBookingController>(

          initState: (_){
            Get.find<ProviderBookingController>().getProviderDetailsData(providerId, false);
          },
          builder: (providerBookingController){

            final daysOfWeek = [ "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday","friday"];
            final weekends = providerBookingController.providerDetailsContent?.provider?.weekends ?? [];
            List<String> workingDays = [];
            for (var element in daysOfWeek) {
              if(!weekends.contains(element)){
                workingDays.add(element);
              }
            }
            String? startTime = providerBookingController.providerDetailsContent?.provider?.timeSchedule?.startTime;
            String? endTime = providerBookingController.providerDetailsContent?.provider?.timeSchedule?.endTime;
            String currentTime = DateConverter.convertStringTimeToDate(DateTime.now());
            String dayOfWeek = DateConverter.dateToWeek(DateTime.now());

            bool timeSlotAvailable;
            if(startTime !=null && endTime !=null){
              timeSlotAvailable = _isUnderTime(currentTime, startTime, endTime) && (!weekends.contains(dayOfWeek.toLowerCase()));
            }else{
              timeSlotAvailable = false;
            }


            return FooterBaseView(
              isScrollView: true,
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: providerBookingController.providerDetailsContent!=null ?
                Column(children: [


                  if(providerBookingController.providerDetailsContent?.provider?.serviceAvailability ==0)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.error))
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                    child: Center(child: Text('provider_is_currently_unavailable'.tr, style: ubuntuMedium,)),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    child: ProviderDetailsTopCard(isAppbar: false,subcategories: subCategories,providerId: providerId,),
                  ),

                  (providerBookingController.providerDetailsContent?.provider?.serviceAvailability ==0) ? Container(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.error.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),

                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center , children: [

                        Icon(Icons.schedule,size: Dimensions.fontSizeLarge, color:Theme.of(context).textTheme.bodyLarge?.color ,),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                        Text("availability".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                      ],),

                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      Text("unavailability_hint_text".tr,
                        style: ubuntuRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ],),
                  ) :

                  Container(
                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.3)),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      Text("availability".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                      const SizedBox(height: Dimensions.paddingSizeEight,),
                      Row(mainAxisAlignment: MainAxisAlignment.center , children: [

                        Icon(Icons.schedule,size: Dimensions.fontSizeDefault, color:Theme.of(context).textTheme.bodySmall?.color ,),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall,),
                        Text( timeSlotAvailable ? "${'today_available_till'.tr} ${DateConverter.convertTimeToTime(endTime ?? "00:00")}" : "provider_is_currently_on_a_break".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),
                      ],),


                      weekends.length == 7 || providerBookingController.providerDetailsContent?.provider?.timeSchedule == null ? const SizedBox(height: Dimensions.paddingSizeDefault,) :
                      Column(children: [

                        const SizedBox(height: Dimensions.paddingSizeEight,),
                        Divider(color: Theme.of(context).hintColor,),
                        const SizedBox(height: Dimensions.paddingSizeEight,),

                        workingDays.isNotEmpty ?  Column(children: [
                          Text(providerBookingController.formatDays(workingDays), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),textAlign: TextAlign.center,),
                          const SizedBox(height: Dimensions.paddingSizeEight,),

                          if(providerBookingController.providerDetailsContent?.provider?.timeSchedule != null)
                            Text("${DateConverter.convertTimeToTime(startTime!)} - ${DateConverter.convertTimeToTime(endTime!)}", style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),

                          const SizedBox(height: Dimensions.paddingSizeExtraLarge,),
                        ],) : const SizedBox(),

                        weekends.isNotEmpty ? Column(children: [
                          Text(providerBookingController.formatDays(weekends), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,),
                          const SizedBox(height: Dimensions.paddingSizeEight,),
                          Text("day_off".tr, style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodySmall?.color),),
                        ],) : const SizedBox()

                      ],),
                    ],),
                  )
                ],
                ):const Center(child: CircularProgressIndicator()),
              ),
            );
          }),
    );
  }

  bool _isUnderTime(String time, String startTime, String? endTime) {
    return DateConverter.convertTimeToDateTime(time).isAfter(DateConverter.convertTimeToDateTime(startTime))
        && DateConverter.convertTimeToDateTime(time).isBefore(DateConverter.convertTimeToDateTime(endTime!));
  }
}
