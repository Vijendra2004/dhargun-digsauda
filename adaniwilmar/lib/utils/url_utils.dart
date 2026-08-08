import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/utils.dart';

import '../flavor.dart';

class URLUtils {
  String getValidateUrl() {
    return Injector().baseUrl + "api/authenticate/validate";
  }

  String getNetSpeedUrl() {
    return Injector().baseUrl + "api/lookups/netspeed";
  }

  String getAuthorizeLoginUrl() {
    return Injector().baseUrl + "api/authorize/user" + selectedLanguage();
  }

  String getCountryListUrl() {
    return Injector().baseUrl + "api/authorize/user" + selectedLanguage();
  }

  String getAuthorizeLogoutUrl() {
    return Injector().baseUrl + "api/authorize/logout" + selectedLanguage();
  }

  String updatePushTokenUrl() {
    return Injector().baseUrl + "api/user/pushtoken/add" + selectedLanguage();
  }

  String forgotPasswordOtpUrl() {
    return Injector().baseUrl +
        "api/authorize/user/forgotpassword/otp" +
        selectedLanguage();
  }

  String forgotPasswordResendOtpUrl() {
    return Injector().baseUrl +
        "api/authorize/user/otp/resend" +
        selectedLanguage();
  }

  String forgotPasswordSubmitUrl() {
    return Injector().baseUrl +
        "api/authorize/user/resetpassword" +
        selectedLanguage();
  }

  String getNationalityListUrl() {
    return Injector().baseUrl +
        "api/lookups/nationalities/active" +
        selectedLanguage();
  }

  String getGenderUrl() {
    return Injector().baseUrl +
        "api/lookups/genders/active" +
        selectedLanguage();
  }

  String selectedLanguage() {
    return "?languageid=2";
  }

  String netSpeed() {
    return "&qualityid=${Utils().getInterNetSpeed()}";
  }

  //POST
  String getNotificationListUrl() {
    return Injector().baseUrl +
        "api/lookups/notification/all" +
        selectedLanguage() +
        netSpeed();
  }

  //POST  // It will used for the push notification view option for future use
  String getNotificationById() {
    return Injector().baseUrl +
        "api/lookups/notification/id" +
        selectedLanguage() +
        netSpeed();
  } //POST

  String getNotificationBadge() {
    return Injector().baseUrl +
        "api/lookups/notification/badges" +
        selectedLanguage() +
        netSpeed();
  }

  //PUT
  String notificationReadStatus() {
    return Injector().baseUrl +
        "api/dashboard/manualnotification" +
        selectedLanguage() +
        netSpeed();
  }

//PUT
  String notificationListClearUrl() {
    return Injector().baseUrl + "api/dashboard/notification/clearall"
        //  + selectedLanguage()
        //  + netSpeed()
        ;
  }

  String basicInfoOneRegisterUrl() {
    return Injector().baseUrl +
            "api/users/registration/otp" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String basicInfoOneChangePasswordUrl() {
    return Injector().baseUrl +
            "api/users/changepassword/otp" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String validateOTPUrl() {
    return Injector().baseUrl + "api/users/otp/validate" + selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String resendOTPUrl() {
    return Injector().baseUrl + "api/users/otp" + selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String userFinalPageRegisterUrl() {
    return Injector().baseUrl +
            "api/users/registration/basic" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  //POST
  String changePasswordUrl() {
    return Injector().baseUrl +
            "api/users/changepassword/save" +
            selectedLanguage()
        //  + netSpeed()
        ;
  }

  // String chatBotUrl() {
  //   return Injector().botBaseUrl +
  //       '&client_params=' +
  //       json.encode(ChatBotLaunchRequest(
  //           userId: SPUtil.getInt(Constants.USERID, defValue: 0),
  //           userType: SPUtil.getInt(Constants.USER_TYPEID, defValue: 0),
  //           token: SPUtil.getString(Constants.KEY_TOKEN_1)));
  // }

  String getZonalHeadList() {
    return Injector().baseUrl + "api/NationalHead/ZH/list" + selectedLanguage();
  }

  String getuserdicountList() {
    return Injector().baseUrl +
        "api/pricing/discountuser/list" +
        selectedLanguage();
  }

  String getMaterialList() {
    return Injector().baseUrl +
        "api/lookups/skulist/basedoncombination" +
        selectedLanguage();
  }

  String getMaterialByOilTypePackageTypeList() {
    return Injector().baseUrl +
        "api/lookups/sku/ddl/OiltypeIdsAndPackGroupIds" +
        selectedLanguage();
  }

  String getStateList() {
    return Injector().baseUrl +
        "api/lookups/active/state/list" +
        selectedLanguage();
  }

  String getPushToken() {
    return Injector().baseUrl + "api/user/pushtoken/add" + selectedLanguage();
  }

  String getTickerList() {
    return Injector().baseUrl +
        "api/mobiledashboard/ticker/list" +
        selectedLanguage();
  }

  String getPendingSaudaUrl(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/pendingsauda/chart" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/MobileApproval/pendingsauda/chart" +
          selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/Dashboard/PendingSaudaChart" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/Dashboard/PendingSaudaChart" +
          selectedLanguage();
    }
  }

  String getWeeklyOverallSales(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/salestarget" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/salestarget" +
          selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/Chart/WeekwiseOverallSales" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/Chart/WeekwiseOverallSales" +
          selectedLanguage();
    }
  }

  String getWeeklyOverallSauda(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/saudatarget" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/saudatarget" +
          selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/Chart/WeekwiseOverallSauda" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/Chart/WeekwiseOverallSauda" +
          selectedLanguage();
    }
  }

  String getOverallSauda(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/saudatarget/overall" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/saudatarget/overall" +
          selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/Chart/OverallSauda" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/Chart/OverallSauda" +
          selectedLanguage();
    }
  }

  String getOverallSales(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/salestarget/overall" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/salestarget/overall" +
          selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/Chart/OverallSales" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/Chart/OverallSales" +
          selectedLanguage();
    }
  }

  String getOverallSalesTarget() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/salestarget/overall" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/salestarget/overall" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/Chart/OverallSales" +
          selectedLanguage();
    }
  }

  String getOverallSalesUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/oiltypewise/salestarget/chart" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/chart/salestarget/overall" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.SALE) {
      return Injector().baseUrl +
          "api/mobilesales/chart/overallsales" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobileDealersales/chart/overallsales" +
          selectedLanguage();
    }
  }

  String getPendingSaudaChartDetailUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/pendingsauda/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/mobileApproval/pendingsauda/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/PendingSaudaChartDetail" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/PendingSaudaChartDetail" +
          selectedLanguage();
    }
  }

  String getExpiredAndNearExpiredUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/ExpiredAndNearExpiredSauda" +
        selectedLanguage();
  }

  String getOilPackageUrl() {
    return Injector().baseUrl +
        "api/lookups/oilpackingtype/list" +
        selectedLanguage();
  }

  String getOilPackageTypeIdUrl() {
    return Injector().baseUrl +
        "api/lookups/oilpackinggrouptype/list" +
        selectedLanguage();
  }

  String getDealerListUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/dealerSalesLists" +
        selectedLanguage();
  }

  String getDealerSaudaListUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/dealerSaudaLists" +
        selectedLanguage();
  }

  String getDealerSalesListUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/dealerSalesLists" +
        selectedLanguage();
  }

  String getSalesDetailsUrl() {
    return Injector().baseUrl +
        "api/MobileDashboard/Invoice/InvoiceDetailsByDealers" +
        selectedLanguage();
  }

  String getSaudaorderdetailsUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/Saudaorderdetails" +
        selectedLanguage();
  }

  String getBDOStatisticsUrl(int roleId) {
    if (roleId == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "/api/NationalHead/statistics" +
          selectedLanguage();
    } else if (roleId == Constants.ZHMANAGER) {
      return Injector().baseUrl + "/api/zh/statistics" + selectedLanguage();
    } else if (roleId == Constants.DEALER) {
      return Injector().baseUrl +
          "/api/mobileDealerDashboard/statistics" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/employees/BDO/statistics" +
          selectedLanguage();
    }
  }

  String getSaudaTarget() {
    return Injector().baseUrl +
        "api/NationalHead/chart/saudatarget" +
        selectedLanguage();
  }

  String getSalesTarget() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/chart/salestarget" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/zh/chart/salestarget" +
          selectedLanguage();
    }
  }

  String getDailyRateNewUrl() {
    if (Constants.AUTH_ROLEID == Constants.SALE) {
      return Injector().baseUrl +
          "api/mobileDealerDashboard/dailyrate/new" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobileDashboard/dailyrate/new" +
          selectedLanguage();
    }
  }

  String getCustomerLedgerUrl() {
    return Injector().baseUrl + "api/mobileDealerDashboard/ledger";
    // selectedLanguage();
  }

  String getOilTypeListUrl() {
    return Injector().baseUrl + "api/master/oiltype/list" + selectedLanguage();
  }

  String getCrossAndUpSellMandatoryURL() {
    return Injector().baseUrl + "api/crossandupsell/get/mandatory/skus";
  }

  String getOilTypeListBasedDivisionUrl() {
    return Injector().baseUrl +
        "api/lookups/oiltypes/verticalid" +
        selectedLanguage();
  }

  String getOilTypeListByLoginIdUrl() {
    return Injector().baseUrl +
        "api/master/oiltype/listbsdlogin" +
        selectedLanguage();
  }

  String getPlantDepotDetailsByDealerUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/PlantDepotDetailsByDealer" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/PlantDepotDetailsByDealer" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobileDashboard/BDOPlantDepotDetailsByDealer" +
          selectedLanguage();
    }
  }

  String getActiveZoneListUrl() {
    return Injector().baseUrl + "api/master/zone/list" + selectedLanguage();
  }

  String getStateListUrl() {
    return Injector().baseUrl +
        "api/master/getstates/zoneids" +
        selectedLanguage();
  }

  String getCityTerritoryUrl() {
    return Injector().baseUrl +
        "api/pricing/getcitydetails/territoryids" +
        selectedLanguage();
  }

  String getActiveStateListUrl() {
    return Injector().baseUrl +
        "api/lookups/active/state/list" +
        selectedLanguage();
  }

  String getZonalEmployeesUrl() {
    return Injector().baseUrl + "api/employees/usertarget/UserAssignedTo";
  }

  String getDistributorStateListUrl() {
    return Injector().baseUrl + "api/lookups/active/state/user";
  }

  String getIncoTermsListUrl() {
    return Injector().baseUrl + "api/master/incoterm/list" + selectedLanguage();
  }

  String getPlantListUrl() {
    return Injector().baseUrl + "api/master/plant/list" + selectedLanguage();
  }

  String getPlantListByStateUrl() {
    return Injector().baseUrl + "api/lookups/plant/stateid";
  }

  String getPlantListByUserUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl + "api/NationalHead/PlantDepotDetailsByDealer";
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/zh/PlantDepotDetailsByDealer";
    } else {
      return Injector().baseUrl +
          "api/mobileDashboard/BDOPlantDepotDetailsByDealer";
    }
  }

  String getDealerListByUserIdUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/user/dealerlist/all" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/user/dealerlist/all" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/user/dealerlist/userid" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/user/dealerlist/userid" +
          selectedLanguage();
    }
  }

  String getDistributorHeadListByUserIdUrl() {
    return Injector().baseUrl +
        "api/user/dealerlist/userid" +
        selectedLanguage();
  }

  String getDoNumberListByUserIdUrl() {
    return Injector().baseUrl + "api/master/donumber/list" + selectedLanguage();
  }

  String getDoMaterialListUrl() {
    return Injector().baseUrl +
        "api/lookups/salesdata/list" +
        selectedLanguage();
  }

  String getDueForTomorrowUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/duefortomorrow/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/DueForTomorrowList" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/DueForTomorrowList" +
          selectedLanguage();
    }
  }

  String getSalesOrganizationUrl() {
    return Injector().baseUrl +
        "api/lookups/getsalesOrganization" +
        selectedLanguage();
  }

  String getDistributionChannelUrl() {
    return Injector().baseUrl +
        "api/lookups/getdistributionChannel" +
        selectedLanguage();
  }

  String getDealerDetailUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/dealerDetail" +
        selectedLanguage();
  }

  String getSaudaOrderDetailUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/ExpiredAndNearExpiredSauda" +
        selectedLanguage();
  }

  String getVerticalUrl() {
    return Injector().baseUrl + "api/master/vertical/list" + selectedLanguage();
  }

  String getSubCategoryUrl() {
    return Injector().baseUrl + "api/master/subcategory/list";
  }

  String getMaterialDropDownUrl() {
    return Injector().baseUrl +
        "api/lookups/skus/oiltypesubcategory" +
        selectedLanguage();
  }

  String getSpecialRateRequestList() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialraterequestnew/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/mobileapproval/specialraterequestnew/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.SALE) {
      return Injector().baseUrl +
          "api/mobilesauda/specialrate/search" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobileDealersauda/specialrate/search/" +
          selectedLanguage();
    }
  }

  String getSpecialRateRequestViewUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/specialrate/view" +
        selectedLanguage();
  }

  String getUpdateQuantityLimitUrl() {
    return Injector().baseUrl +
        "api/NationalHead/specialityfat/list" +
        selectedLanguage();
  }

  String getQuantityAllocationListUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/quantitylimit/list" +
          selectedLanguage();
    } else if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/quantitylimit/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/quantityallocation/list" +
          selectedLanguage();
    }
  }

  String getQuantityAllocationRequestStatusUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/requestedquantitylimit/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/requestedquantitylimit/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobileapproval/specialityfat/requestedquantitylimit/list" +
          selectedLanguage();
    }
  }

  String getQuantityAllocationManagerRequestStatusUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/quantitylimitrequest/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/quantitylimitrequest/list" +
          selectedLanguage();
    }
  }

  String saveQuantityAllocationRequestUrl() {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/quantitylimit/request" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/quantitylimit/request" +
          selectedLanguage();
    }
  }

  String saveQuantityAllocationCreateRequestUrl() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/discountuser/add" +
        selectedLanguage();
  }

  String saveAssignedQuantityAllocationUpdateUrl() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/assigneddiscount/employee" +
        selectedLanguage();
  }

  String saveRequestQuantityCreateUrl() {
    return Injector().baseUrl +
        "api/pricing/specialtyfat/quantityrequest/add" +
        selectedLanguage();
  }

  String saveRequestQuantityStatusUpdateUrl() {
    return Injector().baseUrl +
        "api/pricing/specialtyfat/quantitylimit/update" +
        selectedLanguage();
  }

  String updateQuantityAllocationCreateRequestUrl() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/discountuser/update" +
        selectedLanguage();
  }

  String listQuantityAllocationCreateRequestUrl() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/discountuser/list" +
        selectedLanguage();
  }

  String listQuantityAssignedAllocationItems() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/assigneddiscount/list" +
        selectedLanguage();
  }

  String listRequestedQuantityItemsUrl() {
    return Injector().baseUrl + "api/pricing/mobile/quantityrequest/list";
  }

  String listFetchQAReqURL() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/discountuser/id" +
        selectedLanguage();
  }

  String listFetchAssignQAReqURL() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/assigneddiscount/id" +
        selectedLanguage();
  }

  String saveQuantityLimitRequestUrl() {
    return Injector().baseUrl +
        "api/pricing/specialityfat/discountuser/add" +
        selectedLanguage();
  }

  String updateQuantityLimitRequestUrl() {
    return Injector().baseUrl +
        "api/NationalHead/specialityfat/update" +
        selectedLanguage();
  }

  String updateAssignedQuantityLimitRequestUrl() {
    return Injector().baseUrl +
        "api/MobileApproval/specialityfat/assignedquantitylimit/update" +
        selectedLanguage();
  }

  String saveAllocateQuantityLimitRequestUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/quantitylimit/assign" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/quantitylimit/assign" +
          selectedLanguage();
    }
  }

  String getQuantityAssignedListUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/specialityfat/assignedquantitylimit/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileApproval/specialityfat/assignedquantitylimit/list" +
          selectedLanguage();
    }
  }

  String getDealerSaudaDetailsUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl + "api/mobileDealersauda/DealerSaudaDetails";
    } else {
      return Injector().baseUrl + "api/mobilesauda/DealerSaudaDetails";
    }
    // selectedLanguage();
  }

  String getDealerSaudaDefaultDetailsUrl() {
    return Injector().baseUrl + "api/mobilesauda/GetDealerSaudaDetails";
  }

  String getSalesOrderDataDetailsUrl() {
    return Injector().baseUrl + "api/mobilesauda/GetSalesOrderDataDetails";
  }

  String getFinalPriceSkuNameListForMobile() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobilefinalprice/skunamelist" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilefinalprice/skunamelist" +
          selectedLanguage();
    }
  }

  String getFinalPriceSkuNameListForDealerPopupUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/lookups/sku/listbyid" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/lookups/sku/listbyid" +
          selectedLanguage();
    }
  }

  String saveSaudaUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/create" +
          selectedLanguage();
    } else {
      return Injector().baseUrl + "api/mobilesauda/create" + selectedLanguage();
    }
  }

  String saveUserDiscountUrl() {
    return Injector().baseUrl +
        "api/pricing/discountuser/add" +
        selectedLanguage();
  }

  String updateUserDiscountUrl() {
    return Injector().baseUrl +
        "api/pricing/discountuser/update" +
        selectedLanguage();
  }

  String saveAssignedUserDiscountUrl() {
    return Injector().baseUrl +
        "api/pricing/employeeuserdiscount/add" +
        selectedLanguage();
  }

  String saveGeographyDiscountUrl() {
    return Injector().baseUrl +
        "api/pricing/geographydiscount/save" +
        selectedLanguage();
  }

  String updateGeographyDiscountUrl() {
    return Injector().baseUrl +
        "api/pricing/geographydiscount/update" +
        selectedLanguage();
  }

  /*  Change By Jaison*/
  String getBDOSaudaConversionPendingApprovedListUrl() {
    return Injector().baseUrl +
        "api/mobileDealersauda/saudaconversion/pendingapprovedlist/bdo" +
        selectedLanguage();
  }

  String getSaudaConversionSkuDetailsByIdUrl() {
    return Injector().baseUrl +
        "api/mobileDealersauda/saudaconversion/get/skudetails" +
        selectedLanguage();
  }

  String getSaudaExtensionPendingAndApprovalListForBdoUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/sauda/saudaextension/pendingandapprovallist" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/sauda/saudaextension/pendingandapprovallistfordealer" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/sauda/saudaextension/pendingandapprovallistforbdo" +
          selectedLanguage();
    }
  }

  String getBookedSaudaUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/mobileapproval/BookedSauda/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/BookedSauda" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/BookedSauda" +
          selectedLanguage();
    }
  }

  String getSaudaUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/mobilesauda/Saudaorderdetails" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/details" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/details" +
          selectedLanguage();
    }
  }

  String getCustomerAudioUrl() {
    // if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
    return Injector().baseUrl +
        "api/mobileapproval/audiofilesagainstcustomers" +
        selectedLanguage();
    // } else {
    //   return Injector().baseUrl +
    //       "api/mobileapproval/savesaudadetails/mappedagainstaudiofiles" +
    //       selectedLanguage();
    // }
  }

  String getCustomerAudioSaveUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/savesaudadetails/mappedagainstaudiofiles" +
        selectedLanguage();
  }

  String getSaudaImageUploadUrl() {
    return Injector().baseUrl +
        "api/media/upload/imageForSaudaCallRecordMapping?key=2";
  }

  String getBookedSaudaWithextensionDetailsListUrl() {
    return Injector().baseUrl +
        "api/sauda/saudaextension/bookedSaudaWithextensionDetailsList" +
        selectedLanguage();
  }

  String getAdminAppListUrl() {
    return Injector().baseUrl + "api/sauda/adminapp/list" + selectedLanguage();
  }

  String saveSaudaApprovalUrl() {
    return Injector().baseUrl + "api/sauda/status/change" + selectedLanguage();
  }

  String saveSaudaExtensionUrl() {
    return Injector().baseUrl +
        "api/mobileDealersauda/extension/sauda/add" +
        selectedLanguage();
  }

  String getLiftingRequestListUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/MobileApproval/liftingrequest/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/lifting/liftingRequest/DealersLiftingRequestList" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/lifting/liftingRequest/List" +
          selectedLanguage();
    }
  }

  String getDealerLiftingRequestListUrl() {
    return Injector().baseUrl +
        "api/MobileApproval/liftingrequest/dealerliftingrequestlist" +
        selectedLanguage();
  }

  String getLiftingRequestDetailUrl() {
    return Injector().baseUrl +
        "api/lifting/liftingRequest/detail" +
        selectedLanguage();
  }

  String saveSalesOrderApprovalUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/liftingrequest/approval" +
        selectedLanguage();
  }

  /* STP URLS */
  String getYourPerformanceUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/zh/Performance";
    } else {
      return Injector().baseUrl + "api/mobilesales/Performance";
    }
  }

  String getPerformanceRankingListUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/zh/performance/rank/list";
    } else {
      return Injector().baseUrl + "api/mobilesales/PerformanceRankingList";
    }
  }

  String getEmployeeKpiUrl() {
    return Injector().baseUrl + "api/employees/kpi";
  }

  String getCreditlimitOverViewUrl() {
    return Injector().baseUrl + "api/mobilesales/creditlimit/total";
  }

  String getCreditLimitExposureUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/creditlimitandcreditexposure/list";
  }

  String getSalesTourPlanChartUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl + "api/NationalHead/stp/chart";
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/zh/stp/chart";
    } else {
      return Injector().baseUrl + "api/mobileSTP/SalesTourPlanChart";
    }
  }

  String getListPCPUrl() {
    return Injector().baseUrl + "api/MobileApproval/pcp/view";
  }

  String getListMTPUrl() {
    return Injector().baseUrl + "api/MobileApproval/mtp/view";
  }

  String getViewPCPUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/MobileApproval/pcp/list";
    } else {
      return Injector().baseUrl + "api/mobileSTP/PJP/TotalPCPByUsers";
    }
  }

  String getCurrentMTPUrl() {
    return Injector().baseUrl +
        "api/SalesTourPlan/PJP/ApprovedPermanentJourneyPlanByUser";
  }

  String getCurrentMTPUpcommingUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/MobileApproval/mtp/list";
    } else {
      return Injector().baseUrl + "api/mobileSTP/MTP/currentOrUpcomingmonth";
    }
  }

  String getHolidaysUrl() {
    return Injector().baseUrl + "api/mobileSTP/holiday/list";
  }

  String getServerDateTimeUrl() {
    return Injector().baseUrl + "api/master/serverdatetime";
  }

  String getTodayActivitiesUrl() {
    return Injector().baseUrl + "api/SalesTourPlan/TodayActivities/list";
  }

  String getSaudaNumberUrl() {
    return Injector().baseUrl + "/api/mobilesauda/saudanumber/list";
  }

  String getSaveDealerVisitUrl() {
    return Injector().baseUrl + "api/mobileSTP/TodayActivities/Add";
  }

  String getAddProspectiveDealerUrl() {
    return Injector().baseUrl +
        "api/SalesTourPlan/TodayActivities/AddProspectiveDealer";
  }

  String getSubmitDailySalesReportUrl() {
    return Injector().baseUrl + "api/mobileSTP/MTP/novisit/remarks";
  }

  String getWholesalerVisitListUrl() {
    return Injector().baseUrl + "api/mobileSTP/WholeSellerVisit/list";
  }

  String getWholesalerVisitSecondarySalesUrl() {
    return Injector().baseUrl + "api/lookups/skus/skubasedonoiltype";
  }

  String getWholesalerVisitAddUrl() {
    return Injector().baseUrl + "api/mobileSTP/WholeSellerVisit/add";
  }

  String getApprovedMPDListUrl() {
    return Injector().baseUrl +
        "api/mobileSTP/MTPDeviation/ApprovedMonthlyPlanDeviation";
  }

  String getPendingMPDListUrl() {
    return Injector().baseUrl +
        "api/mobileSTP/MTPDeviation/PendingMonthlyPlanDeviation";
  }

  String getSTPReasonsListUrl() {
    return Injector().baseUrl + "api/SalesTourPlan/reasons/active";
  }

  String getApprovedMTPByUserUrl() {
    return Injector().baseUrl +
        "api/SalesTourPlan/MTPDeviation/ApprovedMonthlyTourPlanByUser";
  }

  String getApprovedMTPDetailByUserUrl() {
    return Injector().baseUrl +
        "api/SalesTourPlan/MTPDeviation/ApprovedMonthlyTourPlanDetailsByUser";
  }

  String getMTPDeviationAddUrl() {
    return Injector().baseUrl + "api/mobileSTP/MTPDeviation/add";
  }

  String getSecondarySalesFortheDayListUrl() {
    return Injector().baseUrl + "api/mobileSTP/SecondarySalesFortheDay/list";
  }

  String getSecondarySalesFortheDayDetailUrl() {
    return Injector().baseUrl + "api/mobileSTP/SecondarySalesFortheDay/detail";
  }

  String getGetShipToPartyListByCustomerIdUrl() {
    return Injector().baseUrl + "api/user/shiptoparty/list";
  }

  String getLoadabilityListUrl() {
    return Injector().baseUrl +
        "api/lifting/liftingRequest/VehicleLodabilityList";
  }

  String getSkuListForIndentRequest() {
    return Injector().baseUrl +
        "api/mobileDealersauda/skulistwithQty/contractnumber" +
        selectedLanguage();
  }

  String getContractListUrl() {
    return Injector().baseUrl +
        "api/mobileDealersauda/contractnumberlist" +
        selectedLanguage();
  }

  String getFillerSKUListUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/fillersku/list" +
        selectedLanguage();
  }

  String saveSalesOrderUrl() {
    return Injector().baseUrl +
        "api/lifting/liftingRequest/add" +
        selectedLanguage();
  }

  String saveLimitEnhancementUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/saudalimit/Add" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/saudalimit/Add" +
          selectedLanguage();
    }
  }

  String getLimitEnhancementHistoryUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/saudalimit/history" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/saudalimit/history" +
          selectedLanguage();
    }
  }

  String saveSpecialRateUrl() {
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/mobileDealersauda/specialrate/add" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesauda/specialrate/add" +
          selectedLanguage();
    }
  }

  String saveSpecialRateApprovalUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/specialrate/approveorreject" +
        selectedLanguage();
  }

  String getCompetitorListUrl() {
    return Injector().baseUrl +
        "api/lookups/bdo/competitors" +
        selectedLanguage();
  }

  String getSkuByOilTypeUrl() {
    return Injector().baseUrl +
        "api/lookups/skus/skubasedonoiltype" +
        selectedLanguage();
  }

  String savePriceDiscoveryUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/competitoranalysis/save" +
        selectedLanguage();
  }

  String getYourSalesPerformanceUrl() {
    return Injector().baseUrl +
        "api/mobilesales/Performance" +
        selectedLanguage();
  }

  String getYourSalesPerformanceRankUrl() {
    return Injector().baseUrl +
        "api/mobilesales/PerformanceRankingList" +
        selectedLanguage();
  }

  String getPackGroupListUrl() {
    return Injector().baseUrl +
        "api/lookups/oilpackingtype/list" +
        selectedLanguage();
  }

  String getUserDiscountListUrl() {
    return Injector().baseUrl +
        "api/pricing/discountuser/list" +
        selectedLanguage();
  }

  String getGeoDiscountListUrl() {
    return Injector().baseUrl +
        "api/pricing/getgeography/list" +
        selectedLanguage();
  }

  String getUserDiscountDetailsUrl() {
    return Injector().baseUrl +
        "api/pricing/discountuserdetails/list" +
        selectedLanguage();
  }

  String getAssignedDiscountListUrl() {
    return Injector().baseUrl +
        "api/pricing/employeeuserdiscount/list" +
        selectedLanguage();
  }

  String getPackGroupSalesUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/packwise/salestarget/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/packwise/salesTarget/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDealerDashboard/packgroupwise/sales" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/packgroupwise/sales" +
          selectedLanguage();
    }
  }

  String getPackGroupDealerSalesUrl() {
    return Injector().baseUrl +
        "api/MobileDashboard/packgroupwise/invoicesByDealers" +
        selectedLanguage();
  }

  String getBDOListUrl() {
    return Injector().baseUrl + "api/zh/bdo/list" + selectedLanguage();
  }

  String loginToFetchExternalAPIURL() {
    return "https://api-ilms.awlagri.in/admin/api/0.1/fetch/master/token";
  }

  String fetchExternalAPITrackOrdersURL(String urlParameters) {
    return "https://api-ilms.awlagri.in/vims/" + "api/v1/integrations/tracking-status?$urlParameters";
  }

  String fetchSalesDataListTrackOrdersURL() {
    return Injector().baseUrl +
        "api/lookups/salesdata/list" +
        selectedLanguage();
  }

  String getBDOListForTpUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl + "api/zh/bdo/list/fortp" + selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/NationalHead/ZH/list" +
          selectedLanguage();
    }
  }

  String getPackGroupInvoiceDetailUrl(bool isPendingSauda) {
    if (isPendingSauda) {
      return Injector().baseUrl +
          "api/MobileDashboard/Invoice/InvoiceDetailsByDealers" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/packgroupwise/InvoiceDetailsByDealers" +
          selectedLanguage();
    }
  }

  String getCreditLimitTotalUrl() {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/NationalHead/sales/statistics" +
          selectedLanguage();
    } else if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/zh/sales/statistics" +
          selectedLanguage();
    } else if (Constants.DEALER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/mobileDealersales/creditlimit/total" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesales/creditlimit/total" +
          selectedLanguage();
    }
  }

  String getChartOverallSalesUrl() {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/NationalHead/oiltypewise/salestarget/chart" +
          selectedLanguage();
    } else if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/zh/oilTypeWise/salesTarget/chart" +
          selectedLanguage();
    } else if (Constants.DEALER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/mobileDealersales/chart/overallsales" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesales/chart/overallsales" +
          selectedLanguage();
    }
  }

  String getDealerSalesUrl() {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/NationalHead/oiltypewise/salestarget/chart" +
          selectedLanguage();
    } else if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      return Injector().baseUrl +
          "api/zh/oilTypeWise/salesTarget/chart" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/mobilesales/chart/overallsales" +
          selectedLanguage();
    }
  }

  String getSpecialRateApprovalListManagerUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/mobileapproval/specialraterequestnew/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/NationalHead/specialraterequestnew/list" +
          selectedLanguage();
    }
  }

  String getPendingSaudaSlabUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/daterange/list" +
        selectedLanguage();
  }

  String getLatestUpdateUrl() {
    return Injector().baseUrl +
        "api/mobileupdate/bulletin/get/latestupdate" +
        selectedLanguage();
  }

  String getLatestUpdateListUrl() {
    return Injector().baseUrl +
        "api/mobileupdate/bulletin/list" +
        selectedLanguage();
  }

  String getFeedbackListUrl() {
    return Injector().baseUrl +
        "api/mobileupdate/feedbacktype/list" +
        selectedLanguage();
  }

  String getFeedbackAddUrl() {
    return Injector().baseUrl +
        "api/mobileupdate/feedback/add" +
        selectedLanguage();
  }

  String getNotificationUrl() {
    return Injector().baseUrl +
        "api/master/request/notification" +
        selectedLanguage();
  }

  String getSurveyUrl() {
    return Injector().baseUrl +
        "api/mobileupdate/question/list" +
        selectedLanguage();
  }

  String getSupportListUrl() {
    return Injector().baseUrl +
        "api/support/issue/listwithcomments" +
        selectedLanguage();
  }

  String getSupportCategoryListUrl() {
    return Injector().baseUrl +
        "api/support/category/list" +
        selectedLanguage();
  }

  String getAddSupportUrl() {
    return Injector().baseUrl + "api/support/add" + selectedLanguage();
  }

  String getPendingContractUrl() {
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/report/PendingContractReportForManager" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/report/PendingContractReportForMobile" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/report/PendingContractReportForMobile" +
          selectedLanguage();
    }
  }

  String getSaudaReportUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/DailyBookedSauda/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/DailyBookedSauda/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDashboard/DailyBookedSauda/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/DailyBookedSauda/list" +
          selectedLanguage();
    }
  }

  String getSalesReportUrl() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      return Injector().baseUrl +
          "api/NationalHead/SalesReport/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      return Injector().baseUrl +
          "api/zh/SalesReport/list" +
          selectedLanguage();
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      return Injector().baseUrl +
          "api/MobileDashboard/SalesReport/list" +
          selectedLanguage();
    } else {
      return Injector().baseUrl +
          "api/MobileDashboard/SalesReport/list" +
          selectedLanguage();
    }
  }

  String getChequesPendingUrl() {
    return Injector().baseUrl +
        "api/mobilesauda/chequestatus/getdetails" +
        selectedLanguage();
  }

  String getPendingContractFilterUrl() {
    return Injector().baseUrl +
        "api/report/OilTypesPendingContractReport" +
        selectedLanguage();
  }

  String getCallToCustomerListUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/contactlistforactivecalltocustomers" +
        selectedLanguage();
  }

  String getOilTypeSkuListUrl() {
    return Injector().baseUrl +
        "api/lookups/skus/oiltypeid" +
        selectedLanguage();
  }

  String saveCallToCustomerUrl() {
    return Injector().baseUrl +
        "api/mobileapproval/savedealerdetails" +
        selectedLanguage();
  }

  String getCustomerLedgerNHData() {
    return Injector().baseUrl +
        "api/mobileDealerDashboard/ledger/rolewise" +
        selectedLanguage();
  }

  String getSaudaBookingStatus() {
    return Injector().baseUrl +
        "api/lookups/saudabooking/configuration/rolewise" +
        selectedLanguage();
  }

  String getLastAliveTime() {
    return Injector().baseUrl +
        "api/user/GetUserLoginHistory/list" +
        selectedLanguage();
  }

  String getQPSUrl() {
    return Injector().baseUrl +
        "api/qps/QpsDiscountListWithSlab" +
        selectedLanguage();
  }

  String getQPSDiscountUrl() {
    return Injector().baseUrl +
        "api/qps/GetQPSDiscountForQuantity" +
        selectedLanguage();
  }

  String getGamificationDashboard() {
    return Injector().baseUrl +
        "api/master/GamificationDashboardId/gamificationdashboard" +
        selectedLanguage();
  }

  String getTdsQuestionsData() {
    return Injector().baseUrl +
        "api/dynamicform/sections/questions" +
        selectedLanguage();
  }

  String getTDSFormListApi() {
    return Injector().baseUrl +
        "/api/dynamicform/form/list" +
        selectedLanguage();
  }

  String submitSurveyQuestionsApi() {
    return Injector().baseUrl +
        "api/dynamicform/submitform/add" +
        selectedLanguage();
  }

  String getTanNumber() {
    return Injector().baseUrl +
        "/api/master/tannumber/getid" +
        selectedLanguage();
  }

  String updateTanNumber() {
    return Injector().baseUrl +
        "/api/master/tannumber/update" +
        selectedLanguage();
  }

  String getAccountStatementDate() {
    return Injector().baseUrl +
        "/api/master/validatecalendar" +
        selectedLanguage();
  }

  String getAccountStatementCountURL() {
    return Injector().baseUrl +
        "/api/master/accountstatement/count" +
        selectedLanguage();
  }

  String getAccountStatementStatusUpdateURL() {
    return Injector().baseUrl +
        "/api/master/accountstatementstatus/update" +
        selectedLanguage();
  }

  String getAccountStatementSubmit() {
    return Injector().baseUrl +
        "api/master/email/statement/save" +
        selectedLanguage();
  }

  String getCustomerStatementURL() {
    return "https://myapps.adaniwilmar.in:8441/RESTAdapter/CustomerStatement";
  }

  String getGeographyDiscountDetailsApi() {
    return Injector().baseUrl + "api/pricing/getgeographycitymobile/list";
  }

  String getRestrictionList() {
    return Injector().baseUrl + "/api/sauda/get/saudabooking/restrictionlist";
  }

  String getRolesApi() {
    return Injector().baseUrl + "/api/roles/get/booking/restrictionroleids";
  }

  String getStateTraderList() {
    return Injector().baseUrl + "api/lookups/GetBdoddl/list";
  }

  String getZonalTraderApi() {
    return Injector().baseUrl + "/api/lookups/ZonalTrader/listnew";
  }

  String getDistributorsList() {
    return Injector().baseUrl + "api/lookups/dealers/list";
  }

  String getOilTypeList() {
    return Injector().baseUrl + "/api/lookups/active/oiltype/list";
  }

  String saveSaudaRestriction() {
    return Injector().baseUrl + "/api/lookups/saudabooking/configuration";
  }

  String saveandUpdateRestriction() {
    return Injector().baseUrl + "/api/lookups/saudabooking/mobile/configuration";
  }

  String getModDistributorAPI() {
    return Injector().baseUrl + "/api/user/dealerlist/pendingcontractsanduserid";
  }
  String getModContractApi() {
    return Injector().baseUrl + "api/mobilesauda/pendingcontract/dealerid";
  }

  String getModOilMaterialAPi() {
    return Injector().baseUrl + "api/mobilesauda/oiltypesandskus/pendingcontractid";
  }
  String gettoSkuFromOilAPi() {
    return Injector().baseUrl + "/api/mobilesauda/toskus/fromskuoiltype";
  }

  String saveSaudaMod() {
    return Injector().baseUrl + "/api/mobilesauda/saudamodification/save";
  }

  String SaudaModListApi() {
    return Injector().baseUrl + "api/mobilesauda/saudamodification/pendingapprovedlist";
  }

  String getOilListApi() {
    return Injector().baseUrl + "api/mobilesauda/pendingcontractdetails/pendingcontract";
  }

  String getToSkuList() {
    return Injector().baseUrl + "/api/mobilesauda/toskuslist/saudamodification";
  }

  String getSaudaModDetails() {
    return Injector().baseUrl + "/api/mobilesauda/saudamodification/details";
  }

  String getSaudaApprovalList() {
    return Injector().baseUrl + "/api/mobilesauda/saudamodification/adminapp/list";
  }

  String getStatusChangeApiCall() {
    return Injector().baseUrl + "/api/mobilesauda/saudamodification/statuschange";
  }

  String getStockList() {
    return "${Injector().baseUrl}api/mobileDealerStock/skulist";
  }

  String saveStockList() {
    return "${Injector().baseUrl}api/mobileDealerStock/entry/save";
  }

  String getStockSubmissionList() {
    return "${Injector().baseUrl}api/mobileDealerStock/entry/list";
  }

  String getStockDistributorList() {
    return "${Injector().baseUrl}api/user/dealerlist/userid";
  }

  String getDealerStockReportList() {
    return "${Injector().baseUrl}api/mobileDealerStock/dealer/lateststock";
  }

  String getStateAndZonalList() {
    return "${Injector().baseUrl}api/zh/bdo/list";
  }

}
