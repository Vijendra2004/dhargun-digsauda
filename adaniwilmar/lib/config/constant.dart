import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Constant {
  static String? homeTitle1 = "Pending Sauda";
  static String? homeTitle2 = "Today";
  static String? homeTitle3 = "Due's";

  static Image? bgImgGlobal =
      Image.asset("assets/images/all_bg.png", fit: BoxFit.contain);

  static String? customerLedgerImage = "assets/images/ledger_bg.svg";
  static SvgPicture? bellIconNot =
      SvgPicture.asset("assets/images/notification.svg", width: 15, height: 12);
  static SvgPicture? searchIc =
      SvgPicture.asset("assets/images/search.svg", fit: BoxFit.contain);
  static Image? phoneIc =
      Image.asset("assets/images/phone_ic.png", fit: BoxFit.contain);
  static SvgPicture? locatoinIc =
      SvgPicture.asset("assets/images/location.svg", fit: BoxFit.contain);

  static Icon? checkIc = const Icon(Icons.check, size: 14, color: Colors.white);
  static Icon? closeIc = const Icon(Icons.close, size: 24, color: Colors.grey);

  static SvgPicture? filterIc =
      SvgPicture.asset("assets/images/filter.svg", fit: BoxFit.contain);

  static SvgPicture? editIc =
      SvgPicture.asset("assets/images/edit_icon.svg", fit: BoxFit.contain);

  static SvgPicture? homeBellIc = SvgPicture.asset(
    "assets/images/filter.svg",
    width: 12,
    height: 14,
    fit: BoxFit.none,
  );

  static SvgPicture? rightArow =
      SvgPicture.asset("assets/images/rightarrow.svg", width: 20, height: 20);

  static SvgPicture? homePendingImg1 =
      SvgPicture.asset("assets/images/Expired.svg", width: 24, height: 24);
  static SvgPicture? homePendingImg2 =
      SvgPicture.asset("assets/images/Near_Expired.svg", width: 24, height: 24);

  static SvgPicture homeTodayImg1 =
      SvgPicture.asset("assets/images/Todays_rate.svg", width: 24, height: 24);
  static SvgPicture? homeTodayImg2 =
      SvgPicture.asset("assets/images/Todays_Plan.svg", width: 24, height: 24);
  static Image? homeUserIc =
      Image.asset("assets/images/user_ic.png", width: 36, height: 36);
  static SvgPicture? rupeeSymbol =
      SvgPicture.asset("assets/images/Ellipse 883.svg", width: 24, height: 24);

  static Color? homeBoxPendingRed = const Color(0xffE71928);
  static Color? homeBoxPendingOrange = const Color(0xffF68C33);
  static Color? homeBoxTodayColor1 = const Color(0xff00A7D4);
  static Color? homeBoxTodayColor2 = const Color(0xffF5BD3A);
  static Color? colorYellow = const Color(0xffF5BD3A);
  static Color? homeBoxDueColor1 = const Color(0xffE71928);
  static Color? homeBoxDueColor2 = const Color(0xffE71928);
  static Color? homeBoxDueColor3 = const Color(0xffF68C33);
  static Color? colorGreencc = const Color(0xFF00974C);
  static Color? chartGreenColor = const Color(0xFF92C149);
  static Color? chartBlueColor = const Color(0xFF00A7D4);
  static Color? chartOrangeColor = const Color(0xFFF5BD3A);
  static Color? chartLineColor = const Color(0xFF111111).withOpacity(0.1);
  static Color tabSelColor = const Color(0xFFF68C33);

// Sauda ********************
  static Color? saudacolor1 = const Color(0xff92C149);
  static Color? saudacolor2 = const Color(0xff00974C);
  static Color? saudacolor3 = const Color(0xff0076AD);
  static Color? saudacolor4 = const Color(0xff00A7D4);
  static Color? saudacolor5 = const Color(0xff292F76);
  static Color? saudacolor6 = const Color(0xffF5BD3A);
  static Color? saudacolor7 = const Color(0xff9E275C);
  static Color? saudacolorDiscount = const Color(0xff27969E);
  static Color? saudacolorRestriction= const Color(0xFFF68C33);
  static IconData? saudaIcPlus = Icons.add;
  static IconData? cancelIc = Icons.cancel;
  static double? saudaBoxHeight = 110;
  static double? saudaImgWidth = 20;
  static double? saudaImgHeight = 20;
  static SvgPicture? sauduImage1 = SvgPicture.asset(
      "assets/images/sauda_conversion.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage2 = SvgPicture.asset(
      "assets/images/sauda_extension.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage3 = SvgPicture.asset(
      "assets/images/booked_sauda.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage4 = SvgPicture.asset(
      "assets/images/price_discovery.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage5 = SvgPicture.asset(
      "assets/images/limit_enhancement.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduDiscount = SvgPicture.asset(
      "assets/images/sauda_discount.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage6 = SvgPicture.asset(
      "assets/images/indent_status.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);
  static SvgPicture? sauduImage7 = SvgPicture.asset(
      "assets/images/sauda_conversion.svg",
      width: saudaImgWidth,
      height: saudaImgHeight);

  // Sales ******************
  static Color? salescolor1 = const Color(0xff00974C);
  static Color? salescolor2 = const Color(0xff00A7D4);
  static Color? salescolor3 = const Color(0xffF5BD3A);
  static Color? salescolor4 = const Color(0xff00A7D4);
  static String? salesTitle1 = "Sales Analysis";
  static String? salesTitle2 = "Credit Limit Overview";
  static double? salesImgWidth = 20;
  static double? salesImgHeight = 20;
  static SvgPicture? salesImage1 = SvgPicture.asset("assets/images/bp.svg",
      width: salesImgWidth, height: salesImgHeight);
  static SvgPicture? salesImage2 = SvgPicture.asset(
      "assets/images/performance.svg",
      width: salesImgWidth,
      height: salesImgHeight);
  static SvgPicture? salesImage3 = SvgPicture.asset(
      "assets/images/performance.svg",
      width: salesImgWidth,
      height: salesImgHeight);
  static SvgPicture? salesImage4 = SvgPicture.asset(
      "assets/images/Todays_rate.svg",
      width: salesImgWidth,
      height: salesImgHeight);
  static Image? updateImage = Image.asset(
    "assets/images/update_pic.png",
    fit: BoxFit.contain,
  );

  // login *****************
  static Image? loginImgBg = Image.asset("assets/images/login_bg.png");
  static Image? loginLogoImg = Image.asset(
    "assets/images/fortune_logo.png",
    width: 207,
    height: 135,
  );
  static Image? loginGroupLogo = Image.asset(
    "assets/images/adani_logo.png",
    width: 99,
    height: 64,
  );
  static Image? loginGroupLogoAboutUs = Image.asset(
    "assets/images/adani_logo.png",
    width: 50,
    height: 40,
  );
  static Image? loginUserIc = Image.asset("assets/images/login_user_ic.png",
      width: 12, height: 12, fit: BoxFit.contain);
  static Image? loginLockIc = Image.asset(
    "assets/images/login_lock_ic.png",
    width: 12,
    height: 12,
  );

  static SvgPicture? phone = SvgPicture.asset(
    "assets/images/phone-call.svg",
    width: 18,
    height: 18,
  );

  //Call to Customer
  static Color? callToCcolor1 = const Color(0xFFF68C33);
  static IconData? callToCsbIcon1 = Icons.phone;

  // static Icon? callToCsbIcon1 = Icon(Icons.phone_out).phone;

  static Color? callToCsbCol1 = const Color(0xFF00974C);

// Saudu conversion
  static IconData? sCIcon1 = Icons.location_city_rounded;

// Saudu Extention
  static Color? saExColorRed = const Color(0xFFE71928);

// Booked sauda status
  static Color? booSauStacolor = const Color(0xFF00974C);

  //Status Colors
  static Color? statusCompletedColor = const Color(0xFF00974C);
  static Color? statusPendingColor = const Color(0xFFF68C33);
  static Color? statusRejectedColor = const Color(0xFFE71928);

  static SvgPicture? cameraIc =
      SvgPicture.asset("assets/images/camera.svg", width: 13, height: 13);

  static SvgPicture? headphoneIc =
      SvgPicture.asset("assets/images/headphones.svg", width: 13, height: 13);

//Saudu priceDiscovery
  static Color? pricDisBocolor = const Color(0xFFA1A1A1);
  static Color? pricFIledCOl = const Color(0xFFFFFFFF);
  static Color? pricTxtCOl = const Color(0xFF000000);
  static double? pricTxtCOlSize = 14.0;
  static String? pricDisTitle1 = "Oil Type";
  static String? pricDisTitle2 = "Emami Quantity";
  static String? pricDisTitle3 = "Emami Price";
  static String? pricDisTitle4 = "Workable Price (Rs/case)";
  static String? pricDisTitle5 = "Competitor Name";
  static String? pricDisTitle6 = "Workable Price (Rs/case)";

  static String? pricButtonName = "Confirm Request";
  static double? pricbuttonNameSize = 14;
  static Color? pricbuttonTxtColor = Colors.white;
  static Color? pricbuttonColor = const Color(0xFFE71928);
  static double? pricbuttonHeight = 54;
  static double? pricbuttonRadiusTL = 15;
  static double? pricbutRadiusBL = 4;
  static Color? pricbuttonBorColorTre = const Color(0xFFE71928);

  static String? pricSkuName = "SKU Name";

  // COmmon Text form fiels
  static Color? textFormFieldColor = Colors.black;
  static double? textFormFieldSize = 13;
  static FontWeight? textFormFieldSizeFontW = FontWeight.normal;
  static Color textFormFocuBorCol = const Color(0xFFF68C33);
  static double textFormFocuBorWid = 1;
  static Color textFormEnaBorCol = const Color(0xFFA1A1A1);
  static double textFormEnaBorWid = 1;
  static double textFormborderRadiusTL = 15.0;
  static double textFormborderRadiusBR = 4.0;
  static double textFormcontentPadHor = 16.0;
  static double textFormcontentPadHVer = 2.0;

  //Sauda Limit Enhancement
  static String? saudaLETxt1 = "Distributor Name";
  static String? saudaLETxt2 = "Required Additional Sauda Limit (MT)";
  static String? saudaLETxt3 = "Remarks";
  static String? saudaLEButtonTxt1 = "Cancel";
  static String? saudaLEButtonTxt2 = "Confirm Request";
  static String? todayRateTxt1 = "Book Now";
  static int? saudaLETxt3MaxLine = 3;
  static Color? saudaLETbuttonBorder = const Color(0xFF757575);
  static Color? saudaLETbuttonColor = Colors.white;
  static Color? saudaLETTxtColor = const Color(0xFF757575);
  static String? saudaLETBox1Txt1 = "Available Sauda Limit";
  static String? saudaLETBox1SubTxt1 = "MT";
  static Color? saudaLETBoxColor1 = const Color(0xFF00974C);
  static String? saudaLETBox2Txt2 = "Total Sauda Limit";
  static String? saudaLETBox2SubTxt2 = "MT";
  static Color? saudaLETBoxColor2 = const Color(0xFF00A7D4);

  // More Dialog Box
  static SvgPicture? moreDialogIc1 =
      SvgPicture.asset("assets/images/updates.svg", width: 18, height: 15);
  static SvgPicture? moreDialogIc2 =
      SvgPicture.asset("assets/images/about_us.svg", width: 20, height: 20);
  static SvgPicture? moreDialogIc3 =
      SvgPicture.asset("assets/images/support.svg", width: 15, height: 17);
  static SvgPicture? stockImage =
  SvgPicture.asset("assets/images/stock.svg", width: 15, height: 17);
  static SvgPicture? moreDialogIc4 = SvgPicture.asset(
      "assets/images/pending_Contract.svg",
      width: 18,
      height: 34);
  static SvgPicture? moreDialogIc5 =
      SvgPicture.asset("assets/images/reports.svg", width: 20, height: 18);

  static SvgPicture? gamification =
  SvgPicture.asset("assets/images/gamificationDashboard.svg", width: 20, height: 18);

  static SvgPicture? moreDialogIc6 = SvgPicture.asset(
      "assets/images/check_status_report.svg",
      width: 20,
      height: 22);
  static SvgPicture? moreDialogIc7 =
      SvgPicture.asset("assets/images/logout.svg", width: 17, height: 14);

  static SvgPicture? completedico =
      SvgPicture.asset("assets/images/completed.svg", width: 17, height: 14);

  static SvgPicture? inprogressico =
      SvgPicture.asset("assets/images/in_progress.svg", width: 17, height: 14);

  static SvgPicture? pendingico =
      SvgPicture.asset("assets/images/pending.svg", width: 17, height: 14);

  static SvgPicture? truckico =
      SvgPicture.asset("assets/images/truck.svg", width: 24, height: 24);

  // font size ***************
  static double? headingSix = 16.0;
  static double? fontSize0 = 0.0;
  static double? fontSize09 = 9.0;
  static double? fontSize10 = 10.0;
  static double? fontSize11 = 11.0;
  static double? fontSize12 = 12.0;
  static double? fontSize13 = 13.0;
  static double? fontSize14 = 14.0;
  static double? fontSize15 = 15.0;
  static double? fontSize16 = 16.0;
  static double? fontSize17 = 17.0;
  static double? fontSize18 = 18.0;
  static double? fontSize19 = 19.0;
  static double? fontSize20 = 20.0;
  static double? fontSize21 = 21.0;
  static double? fontSize22 = 22.0;
  static double? fontSize23 = 23.0;
  static double? fontSize24 = 24.0;
  static double? fontSize25 = 25.0;

  // font weight *************
  static FontWeight? fontWeight400 = FontWeight.w500;
  static FontWeight? fontWeight500 = FontWeight.w600;
  static FontWeight? fontWeight600 = FontWeight.w700;
  static FontWeight? fontWeight700 = FontWeight.w800;

  // color ********************
  static Color? colorBlack = const Color(0xFF000000);
  static Color? colorLightGray = const Color(0xFFA1A1A1);
  static Color? colorWhite = const Color(0xFFffffff);
  static Color? colorRed = const Color(0xFFE71928);
  static Color? colorGray75 = const Color(0xFF757575);
  static Color? colorGray45 = const Color(0x45000000);
  static Color? colorOrange = const Color(0xFFF68C34);
  static Color? saudaAppDullColor = const Color(0xFF757575);
  static Color? colorDullYellow = const Color(0xFFFEF8EB);
  static Color? colorLightGreen = const Color(0xFF39A50A);

  // static Color? colorDullYellow = const Color(0x01BD3A1A);

  static Color? colorDullOrange = const Color(0xFFFFFBF7);
  static Color? colorDullGray77 = const Color(0xFF757575);
  static Color? colorVerLightGray = const Color(0xFFF1F1F1);
  static Color? colorOfGray = const Color(0xFFECECEC);
  static Color? colorBtn = const Color(0xFFE71928);

  // commom *******************
  static double? containerWrapper = 8;
  static double? containerTopWrapper = 50;
  static double? containerTopWrapperApproval = 60;
  static double? afterTabSize = 12.0;
  static double? afterHeadingSize = 4.0;
  static double appBarHeight = 60;
}
