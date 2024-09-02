import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/splash/controller/splash_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateConverter {

  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss a').format(dateTime);
  }

  static String dateToTimeOnly(DateTime dateTime) {
    return DateFormat(_timeFormatter()).format(dateTime);
  }

  static String dateToDateAndTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String dateToDateOnly(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }

  static String dateTimeStringToDateTime(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static String dateTimeStringToDateOnly(String dateTime) {
    return DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime));
  }

  static DateTime dateTimeStringToDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime);
  }

  static DateTime isoUtcStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').parse(dateTime, true).toLocal();
  }

  static String isoStringToDateTimeString(String dateTime) {
    return DateFormat('dd MMM yyyy  ${_timeFormatter()}').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM yyyy').format(isoStringToLocalDate(dateTime));
  }

  static String stringToLocalDateOnly(String dateTime) {
    return DateFormat('dd MMM, yyyy').format(DateFormat('yyyy-MM-dd').parse(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dateTime);
  }

  static String convertTimeToTime(String time) {
    return DateFormat(_timeFormatter()).format(DateFormat('HH:mm').parse(time));
  }

  static String convertStringTimeToDate(DateTime time) {
    return _localDateFormatter(_timeFormatter()).format(time);
  }

  static String convertStringTimeToDateTime (DateTime time){
    return DateFormat('EEE \'at\' ${_timeFormatter()}').format(time.toLocal());
  }

  static DateTime convertStringTimeToDateOnly(String time) {
    return DateFormat('yyyy-MM-dd').parse(time);
  }

  static String dateMonthYearTime(DateTime ? dateTime) {
    return _localDateFormatter('d MMM, y, ${_timeFormatter()}').format(dateTime!);
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm aa').format(isoStringToLocalDate(dateTime));
  }

  static String dateStringMonthYear(DateTime ? dateTime) {
    return DateFormat('d MMM,y').format(dateTime!);
  }

  static String dateToWeek(DateTime ? dateTime) {
    return DateFormat('EEEE').format(dateTime!);
  }

  static DateTime convertTimeToDateTime(String time) {
    return DateFormat("HH:mm").parse(time);
  }


  static String convert24HourTimeTo12HourTimeWithDay(DateTime time, bool isToday) {
    if(isToday){
      return DateFormat('\'Today at\' ${_timeFormatter()}').format(time);
    }else{
      return DateFormat('\'Yesterday at\' ${_timeFormatter()}').format(time);
    }

  }




  static String _timeFormatter() {
    return Get.find<SplashController>().configModel.content?.timeFormat == '24' ? 'HH:mm' :
    'hh:mm a';
  }

  static int countDays(DateTime ? dateTime) {
    final startDate = dateTime!;
    final endDate = DateTime.now();
    final difference = endDate.difference(startDate).inDays;
    return difference;
  }

  static String dateMonthYearTimeTwentyFourFormat(DateTime dateTime) {
    return _localDateFormatter('d MMM,y ${_timeFormatter()}').format(dateTime);
  }


  static String isoStringToLocalDateAndTime(String dateTime) {
    return _localDateFormatter('dd MMM yyyy \'at\' ${_timeFormatter()}').format(isoUtcStringToLocalDate(dateTime));
  }


  static String convert24HourTimeTo12HourTime(DateTime time) {
    return _localDateFormatter(_timeFormatter()).format(time);
  }


  static DateFormat _localDateFormatter(String format){
    return DateFormat(format
        //, Get.find<LocalizationController>().locale.languageCode
    );
  }


  // static String numberConvertion(String number){
  //   final number = 13330842.0857192;
  //   final formatter = NumberFormat.decimalPatternDigits(locale: 'bn', decimalDigits: 2);
  //   final formattedNumber = formatter.format(number);
  //   return formattedNumber;
  // }


}
