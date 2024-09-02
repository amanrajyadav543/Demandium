import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/cart/widget/available_provider_widgets.dart';
import 'package:demandium/feature/provider/model/provider_model.dart';
import 'package:get/get.dart';

class ProviderDetailsCard extends StatelessWidget {
  final ProviderData?  providerData;
  const ProviderDetailsCard({super.key, this.providerData}) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController){


      bool timeSlotAvailable;
      if(  cartController.cartList[0].provider!= null && cartController.cartList[0].provider!.timeSchedule != null ){
        String? startTime = cartController.cartList[0].provider?.timeSchedule?.startTime;
        String? endTime = cartController.cartList[0].provider?.timeSchedule?.endTime;
        final weekends = cartController.cartList[0].provider?.weekends ?? [];
        String currentTime = DateConverter.convertStringTimeToDate(DateTime.now());

        String dayOfWeek = DateConverter.dateToWeek(DateTime.now());

        if(startTime!=null && endTime !=null){
          timeSlotAvailable = _isUnderTime(currentTime, startTime, endTime) && (!weekends.contains(dayOfWeek.toLowerCase()));
        }else{
          timeSlotAvailable = false;
        }
      }else{
        timeSlotAvailable = false;
      }


      return Column(children: [

        Text('provider_information'.tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5),
            color: Theme.of(context).hoverColor.withOpacity(0.5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(children: [
                  ClipRRect( borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                      image: "${providerData?.logoFullPath}",
                      height: 60,width: 60,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault,),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [

                        Text(providerData?.companyName ??"", style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),

                        InkWell(
                          onTap: () =>  showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context, builder: (context) => AvailableProviderWidget(
                            subcategoryId: cartController.subcategoryId,
                          ),
                          ),
                          child: Image.asset(Images.editButton,width: 20.0,height: 20.0,),),
                        ],
                      ),


                      Text.rich(
                        TextSpan(
                          style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
                          children:  [
                            WidgetSpan(child: Icon(Icons.star,color: Theme.of(context).colorScheme.primaryContainer,size: 15,), alignment: PlaceholderAlignment.middle),
                            const TextSpan(text: " "),
                            TextSpan(text: providerData?.avgRating.toString(),style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault))
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault,)
                    ],
                    ),
                  )
                ]),
              ),

               cartController.cartList[0].provider!= null && cartController.cartList[0].provider!.timeSchedule != null ?
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(Dimensions.radiusSmall),bottomLeft: Radius.circular(Dimensions.radiusSmall)),
                  color: cartController.cartList[0].provider?.serviceAvailability == 0 ? Theme.of(context).colorScheme.error.withOpacity(0.1) : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),

                child:  Center(
                  child: RichText(
                    text: TextSpan(
                      text: timeSlotAvailable && cartController.cartList[0].provider?.serviceAvailability == 1 ? 'available_from'.tr : "provider_is_currently_on_a_break".tr,
                      style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault,  color: Theme.of(context).textTheme.bodySmall!.color),
                      children: <TextSpan>[
                        if(timeSlotAvailable && cartController.cartList[0].provider?.serviceAvailability == 1)
                        TextSpan(
                          text: " : ${DateConverter.convertTimeToTime(cartController.cartList[0].provider!.timeSchedule!.startTime!)} ${'to'.tr} ${DateConverter.convertTimeToTime(cartController.cartList[0].provider!.timeSchedule!.endTime!)}",
                          style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault,  color: Theme.of(context).textTheme.bodyLarge!.color),
                        )

                      ],
                    ),
                  ),
                ),

              ) : const SizedBox()
            ],
          ),
        ),
      ]);
    });
  }
  bool _isUnderTime(String time, String startTime, String? endTime) {
    return DateConverter.convertTimeToDateTime(time).isAfter(DateConverter.convertTimeToDateTime(startTime))
        && DateConverter.convertTimeToDateTime(time).isBefore(DateConverter.convertTimeToDateTime(endTime!));
  }
}
