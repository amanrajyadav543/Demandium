import 'package:demandium/components/time_picker_snipper.dart';
import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';

class CustomTimePicker extends StatelessWidget {
  const CustomTimePicker({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault ),
      child: Row(
        children: [
          Text('time'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(Get.context!).colorScheme.primary)),
          const SizedBox(width: Dimensions.paddingSizeLarge,),
          GetBuilder<ScheduleController>(builder: (createPostController){
            return TimePickerSpinner(
              is24HourMode: Get.find<SplashController>().configModel.content?.timeFormat == '24',
              normalTextStyle: ubuntuRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall),
              highlightedTextStyle: ubuntuMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge*1, color: Theme.of(context).colorScheme.primary,
              ),
              spacing: Dimensions.paddingSizeDefault,
              itemHeight: Dimensions.fontSizeLarge + 2,
              itemWidth: 50,
              alignment: Alignment.topCenter,
              isForce2Digits: true,
              onTimeChange: (time) {
                createPostController.selectedTime = "${time.hour}:${time.minute}:${time.second}";
                //createPostController.buildSchedule(scheduleType: ScheduleType.schedule);
              },
            );
          }),
        ],
      ),
    );
  }
}
