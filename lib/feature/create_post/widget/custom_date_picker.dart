import 'package:demandium/components/core_export.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatelessWidget {
  final DateRangePickerController dateRangePickerController;
  const CustomDatePicker({super.key, required this.dateRangePickerController}) ;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, width: 500,
      child: GetBuilder<ScheduleController>(builder: (scheduleController){
        return SfDateRangePicker(
          backgroundColor: Theme.of(context).cardColor,
          controller: dateRangePickerController,
         showNavigationArrow: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
            if(args.value !=null){
              scheduleController.selectedDate =  DateFormat('yyyy-MM-dd').format(args.value);
              scheduleController.updateScheduleType(scheduleType: ScheduleType.schedule);
            }
          },
          initialSelectedDate: scheduleController.getSelectedDateTime(),
          selectionMode: DateRangePickerSelectionMode.single,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          viewSpacing: 10,
          headerHeight: 50,
          toggleDaySelection: true,
          enablePastDates: false,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
            textAlign: TextAlign.center,
            textStyle: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
            ),
          ),
        );
      }),
    );
  }
}
