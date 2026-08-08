import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateFormat dobFormat = DateFormat("MM-dd-yyyy");

  // ignore: non_constant_identifier_names
  static DateFormat DD_MM_YYYY_Format = DateFormat("dd-MM-yyyy");

  // ignore: non_constant_identifier_names
  static DateFormat YYYY_MM_DD_Format = DateFormat("yyyy-MM-dd");

  // ignore: non_constant_identifier_names
  static DateFormat ServerFormat = DateFormat("yyyy-MM-dd'T'hh:mm:ss");

  static DateFormat ServerFormat1 = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
  static DateFormat ServerFormat2 = DateFormat("yyyy-MM-dd HH:mm:ss");

  // ignore: non_constant_identifier_names
  static DateFormat DD_MMM_YYYY_Format = DateFormat("dd MMM yyyy");

  static DateFormat DD_MMM_Format = DateFormat("dd MMM");

  static DateFormat YYYY_Format = DateFormat("yyyy");

  static DateFormat EEEE_Format = DateFormat("EEEE");

  static DateFormat DD_MM_YYYY_HH_MM_AA = DateFormat("dd-MM-yyyy - hh:mm a");

  static DateFormat DD_MM_YYYY_HH_MM_A = DateFormat("dd-MM-yyyy hh:mm a");
  static DateFormat DD_MM_YYYY_HH_MM = DateFormat("dd-MM-yyyy hh:mm");
  static DateFormat DD_MM_YYYY_HH_MM_24 = DateFormat("dd-MM-yyyy hh:mm");
  static DateFormat DD_MM_YYYY_HH_MM_24_format = DateFormat("dd-MM-yyyy HH:mm");

  DateTime stringToDate(String date, DateFormat format) {
    return format.parse(date);
  }

  String dateToStringFormat(DateTime date, DateFormat format) {
    return format.format(date);
  }

  String convertDateFormat(String inputDate) {
    try {
      // Parse the input date
      DateTime dateTime = DateFormat("dd-MMM-yyyy hh:mm a").parse(inputDate);

      // Format the date into the desired output format
      String formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);

      return formattedDate;
    } catch (e) {
      // Handle parsing errors, if any
      return '';
    }
  }

  String dateFormatConversion(String inputDate){
    DateTime dt = DateFormat("dd-MM-yyyy HH:mm").parse(inputDate, true);
    String formatted = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
    return formatted;
  }


  String dateToServerToDateFormat(
      String date, DateFormat actualFormat, DateFormat resultFormat) {
    // print(date);

    // var res = DateTime.parse(date);

    DateTime res = stringToDate(date, actualFormat).toLocal();

    String convertedDate = dateToStringFormat(res, resultFormat);
    // print(convertedDate);
    return convertedDate;
  }

  DateTime convertUTCToLocalDateTime(DateTime dateTime) {
    // print("dateUtc: $dateTime"); // 2019-10-10 12:05:01

// convert it to local
    var dateLocal = dateTime.toLocal();
    if (kDebugMode) {
      print("local: $dateLocal");
    } // 2019-

    return dateLocal;
  }

  static Map<String, DateTime> getChartDates(String selectedMethod) {
    Map<String, DateTime> resultDates = Map<String, DateTime>();
    DateTime resultFromDate = DateTime.now();
    DateTime resultToDate = DateTime.now();
    DateTime currentDate = DateTime.now();
    if (selectedMethod == "MTD") {
      resultFromDate = DateTime(currentDate.year, currentDate.month, 1);
      if (currentDate.month == 12) {
        resultToDate = DateTime(currentDate.year, currentDate.month, 31);
      } else {
        resultToDate = DateTime(currentDate.year, currentDate.month + 1, 0);
      }
    } else if (selectedMethod == "QTD") {
      if (currentDate.month <= 3) {
        resultFromDate = DateTime(currentDate.year, 1, 1);
        resultToDate = DateTime(currentDate.year, 3, 31);
      } else if (currentDate.month > 3 && currentDate.month <= 6) {
        resultFromDate = DateTime(currentDate.year, 4, 1);
        resultToDate = DateTime(currentDate.year, 6, 30);
      } else if (currentDate.month > 6 && currentDate.month <= 9) {
        resultFromDate = DateTime(currentDate.year, 7, 1);
        resultToDate = DateTime(currentDate.year, 9, 30);
      } else {
        resultFromDate = DateTime(currentDate.year, 10, 1);
        resultToDate = DateTime(currentDate.year, 12, 31);
      }
    } else if (selectedMethod == "YTD") {
      if (currentDate.month >= 1 && currentDate.month <= 3) {
        resultFromDate = DateTime(currentDate.year - 1, 4, 1);
        resultToDate = DateTime(currentDate.year, 3, 31);
      } else if (currentDate.month >= 4 && currentDate.month <= 12) {
        resultFromDate = DateTime(currentDate.year, 4, 1);
        resultToDate = DateTime(currentDate.year + 1, 3, 31);
      }
    }
    resultDates["fromdate"] = resultFromDate;
    resultDates["todate"] = resultToDate;
    return resultDates;
  }


  compareTwoDates( fromDate ,  toDate) {
    DateTime date1 = fromDate;
    DateTime date2 = toDate;
    if (date1.isBefore(date2)) {
      return ("date1 is earlier than date2");
    } else if (date1.isAtSameMomentAs(date2)) {
      return "both same";
    } else {
      return ("date1 is later than date2");
    }
  }

  convertDateType(String date)
  {
   return DateTime.parse(DateTimeUtils()
        .dateToServerToDateFormat(
        date,
        DateTimeUtils.DD_MM_YYYY_Format,
        DateTimeUtils.YYYY_MM_DD_Format));
  }
  convertServerDateType(String date)
  {
   return DateTime.parse(DateTimeUtils()
        .dateToServerToDateFormat(
        date,
        DateTimeUtils.DD_MM_YYYY_Format,
        DateTimeUtils.ServerFormat));
  }
  convertServerToDateType(String date)
  {
   return DateTime.parse(DateTimeUtils()
        .dateToServerToDateFormat(
        date,
        DateTimeUtils.ServerFormat2,
        DateTimeUtils.ServerFormat));
  }

  convertDateServerToLocalType(String date)
  {
    return DateTime.parse(DateTimeUtils()
        .dateToServerToDateFormat(
        date,
        DateTimeUtils. YYYY_MM_DD_Format ,
        DateTimeUtils.DD_MM_YYYY_Format));
  }

  String displayFormat(String? serverDate)
  {
      // Parse the date string in ISO 8601 format
      DateTime dateObj = DateTime.parse(serverDate??"");

      // Format the date as desired (15-05-2024)
      String formattedDate = DD_MM_YYYY_Format.format(dateObj);
return formattedDate;
  }

  static String formatDateFromString(String s, {required String fromFormat, required String toFormat}) {
    DateTime parsedDate = DateFormat(fromFormat).parse(s);
    String formattedDate = DateFormat(toFormat).format(parsedDate);
    return formattedDate;
  }
}
