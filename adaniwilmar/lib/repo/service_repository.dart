import 'dart:async';
import 'dart:convert';

import 'package:adaniwilmar/gmcore/model/Meta.dart';
import 'package:adaniwilmar/gmcore/network/GMCore.dart';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:adaniwilmar/models/AccountStatementRequest.dart';
import 'package:adaniwilmar/models/EssentialSkuMapping.dart';
import 'package:adaniwilmar/models/GeoDiscountDetailRequest.dart';
import 'package:adaniwilmar/models/Quantity_allocation_create_req.dart';
import 'package:adaniwilmar/models/SaudaModApprovalRequest.dart';
import 'package:adaniwilmar/models/SaveSaudaRestReqmodel.dart';
import 'package:adaniwilmar/models/StockCreationRequest.dart';
import 'package:adaniwilmar/models/SubmitRequestModel.dart';
import 'package:adaniwilmar/models/customer_audio_file.dart';
import 'package:adaniwilmar/models/dealer_visit_request.dart';
import 'package:adaniwilmar/models/deviation_add_request.dart';
import 'package:adaniwilmar/models/limit_enhancement_request.dart';
import 'package:adaniwilmar/models/new_sauda_request.dart';
import 'package:adaniwilmar/models/price_discovery_request.dart';
import 'package:adaniwilmar/models/qps_req_model.dart';
import 'package:adaniwilmar/models/qty_allocation.dart';
import 'package:adaniwilmar/models/sales_order_approval_request.dart';
import 'package:adaniwilmar/models/sales_order_request.dart';
import 'package:adaniwilmar/models/sauda_approval_request.dart';
import 'package:adaniwilmar/models/sauda_extension_request.dart';
import 'package:adaniwilmar/models/special_rate_approval_input.dart';
import 'package:adaniwilmar/models/stock_item.dart';
import 'package:adaniwilmar/models/support_list_response.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:adaniwilmar/utils/url_utils.dart';
import 'package:flutter/foundation.dart';

import '../models/AccountStatementResponse.dart';
import '../models/SaudaModificationCreationModel.dart';
import '../models/geography_discount_request.dart';
import '../models/request_quantity_create_req.dart';
import '../models/request_quantity_status_update_req.dart';
import '../models/track_order_model.dart';
import '../models/user_discount_request.dart';
import '../utils/datetime_utils.dart';

class ServiceRepository {
  URLUtils utils = URLUtils();

  Future<Meta> logoutUser(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.getAuthorizeLogoutUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.response);
    }
    return m;
  }

  Future<Meta> forgotPasswordOtp(String userName) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserName"] = userName;
    input['VerticalId'] = 0;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.forgotPasswordOtpUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.response);
    }
    return m;
  }

  Future<Meta> forgotPasswordResendOtp(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.forgotPasswordResendOtpUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.response);
    }
    return m;
  }

  Future<Meta> forgotPasswordSubmit(int userId, String password, String otpNumber) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    input["NewPassword"] = password;
    input["OtpNumber"] = otpNumber;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.forgotPasswordSubmitUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.response);
    }
    return m;
  }

  Future<Meta> getPendingSauda(int userId, int roleId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    Meta m = await service.processPostURL(utils.getPendingSaudaUrl(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.response);
    }
    return m;
  }

  Future<Meta> getWeeklyData(int userId, int roleId, {int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (zhId > 0) {
      input["ZhId"] = zhId;
    }
    Meta m = await service.processPostURL(utils.getWeeklyOverallSauda(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOverallData(int userId, String fromDate, String toDate, int roleId, bool isShowDealer, {int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["RoleId"] = roleId;
    input["IsShowDealer"] = isShowDealer;
    if (zhId > 0) {
      input["ZhId"] = zhId;
    }
    Meta m = await service.processPostURL(utils.getOverallSauda(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getWeeklySalesData(int userId, int roleId, {int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (zhId > 0) {
      input["ZhId"] = zhId;
    }
    Meta m = await service.processPostURL(utils.getWeeklyOverallSales(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOverallSalesData(int userId, String fromDate, String toDate, int roleId, bool isShowDealer, {int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["RoleId"] = roleId;
    input["IsShowDealer"] = isShowDealer;
    if (zhId > 0) {
      input["ZhId"] = zhId;
    }
    Meta m = await service.processPostURL(utils.getOverallSales(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBDOStatistics(int userId, String fromDate, String toDate, int roleId, bool isShowDealer, {int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["RoleId"] = roleId;
    input["IsShowDealer"] = isShowDealer;
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      input["ZhId"] = zhId;
    }
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getBDOStatisticsUrl(roleId), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" bdo stats data:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDailyRateNew(
      int userId, String frieghtRouteId, String oilTypeId, String incotermId, String plantId, String stateId, String salesOrgId, String distrChannelId, String divisionId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    // input["FrieghtRouteId "]=frieghtRouteId;
    input["OilTypeId"] = oilTypeId;
    input["IncotermId"] = incotermId;
    input["LoginUserId"] = userId;
    input["PlantId"] = plantId;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distrChannelId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getDailyRateNewUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPendingSaudaChartDetail(int userId, {int bdoId = 0, bool isFromPendingSauda = false}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      input["BDOId"] = bdoId;
    } else if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      input["ZhId"] = bdoId;
    }
    input["IsPendingSauda"] = isFromPendingSauda;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getPendingSaudaChartDetailUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilPackingType() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};

    Meta m = await service.processGetURL(utils.getOilPackageUrl(),Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }


  Future<Meta> getOilPackingTypeId() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};

    Meta m = await service.processGetURL(utils.getOilPackageTypeIdUrl(),Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }


  Future<Meta> getDealerDetail(int userId, int dealerId, {int salesOrgId = 1, int distributionId = 1, int divisionId = 1}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = dealerId;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    input['LoginUserId'] = userId;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getDealerDetailUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerSaudaList(int userId, int dealerId, {int salesOrgId = 0, int distributionId = 0, int divisionId = 0, String fromDate = "", String toDate = ""}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = dealerId;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getDealerSaudaListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerSalesList(int userId, int dealerId, {int salesOrgId = 0, int distributionId = 0, int divisionId = 0, String fromDate = "", String toDate = ""}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = dealerId;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getDealerSalesListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCustomerLedger(String dealerCode) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["DealerCode"] = dealerCode;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getCustomerLedgerUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilTypeList(int userId, {int salesOrgId = 0, int distriChannelId = 0, int divisionId = 0, bool isFromSauda = false, bool isFromQuantityAllocationCreateUpdate = false}) async {
    String url = "";
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (!isFromQuantityAllocationCreateUpdate) {
      input["LoginUserId"] = userId;
      input["IsToReturnInactiveData"] = false;
      input["SalesOrganizationId"] = salesOrgId;
      input["DistributionChannelId"] = distriChannelId;
      input["IsSaudaConfig"] = isFromSauda;
      input["DivisionId"] = divisionId;
      url = utils.getOilTypeListUrl();
    } else {
      url = utils.getOilTypeListBasedDivisionUrl();
      input["Id"] = divisionId;
    }

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(url, input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" OilTypeData:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }


  Future<Meta> getCrossAndUpSellMandatory(int userId, {int salesOrgId = 0, int distriChannelId = 0, int divisionId = 0,
    List<Sku> skuIds = const [],int dealerId = 0,plantId = 0}) async {
    String url = "";
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};

      input["LoginUserId"] = userId;
    input["Skus"] = skuIds.map((e) => e.toJson()).toList();
      input["DealerId"] = dealerId;
      input["PlantId"] = plantId;
      input["SalesOrganizationId"] = salesOrgId;
      input["DistributionChannelId"] = distriChannelId;
      input["DivisionId"] = divisionId;
      url = utils.getCrossAndUpSellMandatoryURL();


    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(url, input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" getCrossAndUpSellMandatory:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilTypeListByLoginId(int userId, {int salesOrgId = 0, int distriChannelId = 0, int divisionId = 0, bool isFromSauda = false}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    /* input["IsToReturnInactiveData"] = false;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distriChannelId;
    input["DivisionId"] = divisionId;
    input["IsSaudaConfig"] = isFromSauda;*/

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getOilTypeListByLoginIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" OilTypeData:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getActiveStateList() async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getActiveStateListUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  // Future<Meta> getActiveZoneList() async {
  //   GMAPIService service = GMAPIService();
  //   Meta m = await service.processGetURL(
  //       utils.getActiveZoneListUrl(), Constants.AUTH_TOKEN);
  //   if (kDebugMode) {
  //     
  //     GMLogger.v(m.statusMsg);
  //   }
  //   return m;
  // }

  Future<Meta> getActiveZoneList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getActiveZoneListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getStateIDList(List<int> zoneId) async {
    GMAPIService service = GMAPIService();
    if (kDebugMode) {
      GMLogger.v(zoneId);
    }
    Meta m = await service.statePostURL(utils.getStateListUrl(), zoneId.toString(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCityTerritoryList(List<int> cityTerritoryId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["TerritoryIds"] = cityTerritoryId;
    if (kDebugMode) {
      GMLogger.v(cityTerritoryId);
    }
    Meta m = await service.processPostURL(utils.getCityTerritoryUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributorStateList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    Meta m = await service.processPostURL(utils.getDistributorStateListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSTPReasonsList() async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getSTPReasonsListUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getServerDateTime() async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getServerDateTimeUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getIncoTermsList() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    Meta m = await service.processPostURL(utils.getIncoTermsListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPlantList() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsToReturnInactiveData"] = false;
    Meta m = await service.processPostURL(utils.getPlantListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPlantListByState(int stateId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = stateId;
    Meta m = await service.processPostURL(utils.getPlantListByStateUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPlantListByUser(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    Meta m = await service.processPostURL(utils.getPlantListByUserUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerByUserIdList(int userId, int salesOrgId, int distributionId, int divisionId, {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsToReturnInactiveData"] = false;
    input["LoginUserId"] = userId;
    if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      input["ZHId"] = userId;
      input["BdoIds"] = bdoIds;
    } else if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      if (bdoIds.length > 0) {
        input["ZHId"] = bdoIds[0];
      } else {
        input["ZHId"] = 0;
      }
    }
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerListByUserIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudhaRestriction(int userId, int salesOrgId, int distributionId, int divisionId, int stateId, int dealerId, int skuId, {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    input["SkuId"] = skuId;
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      input["LoginUserId"] = Constants.AUTH_USERID;
      input["DealerId"] = dealerId;
      input["StateTraderId"] = stateId;
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      input["LoginUserId"] = Constants.AUTH_USERID;
      input["DealerId"] = 0;
      input["StateTraderId"] = 0;
    } else if (Constants.AUTH_ROLEID == Constants.SALE) {
      input["LoginUserId"] = Constants.AUTH_USERID;
      input["DealerId"] = dealerId;
      input["StateTraderId"] = 0;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaBookingStatus(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLastAliveTime() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["LoginDate"] = DateTimeUtils.ServerFormat.format(DateTime.now().toUtc());

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLastAliveTime(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributorHeadByUserIdList(int userId, int salesOrgId, int distributionId, int divisionId, {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsToReturnInactiveData"] = false;
    input["LoginUserId"] = userId;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDistributorHeadListByUserIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDoNumberList(List<String> distributorEmpCode) async {
    GMAPIService service = GMAPIService();
    if (kDebugMode) {
      GMLogger.v(distributorEmpCode);
    }
    Meta m = await service.doNumberPutURL(utils.getDoNumberListByUserIdUrl(), distributorEmpCode, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDoMaterialList(int userId, String doNumber, bool isLiftingId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsLiftingId"] = isLiftingId;
    input["DoNumber"] = doNumber;
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDoMaterialListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  ///Dealer List by national list
  Future<Meta> getDealerListByNationalId(int userId, int nationalId, int salesOrgId, int distributionId, int divisionId, {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsToReturnInactiveData"] = false;
    input["LoginUserId"] = userId;
    input["ZHId"] = nationalId;
    input["BdoIds"] = bdoIds;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerListByUserIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

/*
  Future<Meta> getZonalEmployeesList( int salesOrgId,
      int distributionId, int divisionId,
      {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = Constants.AUTH_ROLEID;
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);

    }
    Meta m = await service.processPostURL(
        utils.getZonalEmployeesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }*/

  Future<Meta> getZonalEmployeesList(int userId, int salesOrgId, int distributionId, int divisionId,
      {int stateId = 0, List<int> bdoIds = const [], int zhId = 0, bool isFromQuantityAllocationCU = false}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (isFromQuantityAllocationCU) {
      input["Id"] = Constants.AUTH_ROLEID;
    }

    input["LoginUserId"] = userId;
    // if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
    //   input["ZHId"] = userId;
    //   input["BdoIds"] = bdoIds;
    // } else if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
    //   if (bdoIds.length > 0) {
    //     input["ZHId"] = bdoIds[0];
    //   } else {
    //     input["ZHId"] = 0;
    //   }
    // }
    input["SalesOrganizationId"] = salesOrgId;
    input["DistributionChannelId"] = distributionId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getZonalEmployeesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTomorrowDueList(int userId, int dealerId, {int dueStatus = 1}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (dealerId > 0) {
      input["DealerIds"] = [dealerId];
    }
    input["DueStatus"] = dueStatus;
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(jsonEncode(input));
    }
    Meta m = await service.processPostURL(utils.getDueForTomorrowUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSalesOrganization(int stateId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = stateId;
    Meta m = await service.processGetURL(utils.getSalesOrganizationUrl() + "&Id=" + stateId.toString(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSalesOrganizationQA() async {
    GMAPIService service = GMAPIService();
    // Map<String, dynamic> input = <String, dynamic>{};
    // input["Id"] = stateId;
    Meta m = await service.processGetURL(utils.getSalesOrganizationUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributionChannel(int organizationId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = organizationId;
    Meta m = await service.processPostURL(utils.getDistributionChannelUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" data:" + m.statusMsg);
    }
    return m;
  }

  Future<Meta> getVertical(int distributionChannelId, {bool isToReturnInactiveData = false, int loginUserId = 0, bool isFromQuantityAllocationCreateUpdate = false}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["DistributionId"] = distributionChannelId;
    if (isFromQuantityAllocationCreateUpdate) {
      input["IsToREturnInactiveData"] = isToReturnInactiveData;
      input["LoginUserId"] = Constants.AUTH_USERID;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getVerticalUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSubCategory() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsReturnInactiveData"] = false;
    input["LoginUserId"] = Constants.AUTH_USERID;

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSubCategoryUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getMaterialDropDownList(String? oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["OilTypeId"] = oilTypeId;
    // input["SubCategoryId"] = 0;

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getMaterialDropDownUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSpecialRateRequestList(int userId, int dealerId, fromDate, toDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (dealerId != 0) {
      input["DealerId"] = dealerId;
      // input["OilTypeId"] = 11;
    }
    // if(Constants.DEALER==Constants.AUTH_ROLEID){
    //   input["OilTypeId"] = 1;
    // }
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSpecialRateRequestList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSpecialRateRequestView(int userId, int dealerId, int specialRateId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["SpecialRateId"] = specialRateId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSpecialRateRequestViewUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQuantityAllocationList(int userId, int oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (Constants.AUTH_ROLEID == Constants.SALE) {
      input["OilTypeId"] = oilTypeId;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getQuantityAllocationListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQuantityAllocationRequestStatusList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getQuantityAllocationRequestStatusUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQuantityAllocationManagerRequestStatusList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getQuantityAllocationManagerRequestStatusUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getUserDiscountList(int userId, String date) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["Date"] = date;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getUserDiscountListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getUserDiscountDetails(int Id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = Id;
    input["isRequestFromWeb"] = false;

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getUserDiscountDetailsUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAssignedDiscountList(int userId, String date) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["Date"] = date;
    input["isRequestFromWeb"] = false;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getAssignedDiscountListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getGeoDiscountList(int userId, String date) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["Date"] = date;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getGeoDiscountListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveQuantityAllocationRequest(int userId, int oilTypeId, int specialtyLimtId, int skuId, double quantity) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["OilTypeId"] = oilTypeId;
    input["SKuId"] = skuId;
    input["SpecialtyFatQuantityLimitId"] = specialtyLimtId;
    input["Quantity"] = quantity;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveQuantityAllocationRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveQuantityAllocationCreateUpdateRequest(QuantityAllocationCreateReq allocationCreateReq) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    // input["LoginUserId"] = userId;
    // input["OilTypeId"] = oilTypeId;
    // input["SKuId"] = skuId;
    // input["SpecialtyFatQuantityLimitId"] = specialtyLimtId;
    // input["Quantity"] = quantity;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(
        allocationCreateReq.id == null ? utils.saveQuantityAllocationCreateRequestUrl() : utils.updateQuantityAllocationCreateRequestUrl(), allocationCreateReq.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveAssignedQuantityAllocationUpdateRequest(QuantityAllocationCreateReq allocationCreateReq) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveAssignedQuantityAllocationUpdateUrl(), allocationCreateReq.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveRequestQuantityCreate(RequestQuantityCreateReq requestQuantityCreateReq) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveRequestQuantityCreateUrl(), requestQuantityCreateReq.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveRequestQuantityStatusUpdate(RequestQuantityStatusUpdateReq requestQuantityStatusUpdateReq) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveRequestQuantityStatusUpdateUrl(), requestQuantityStatusUpdateReq.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> listQuantityAllocationItems() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["IsToReturnInactiveData"] = true;

    if (kDebugMode) {
      GMLogger.v(utils.listQuantityAllocationCreateRequestUrl());
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.listQuantityAllocationCreateRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> listRequestedQuantityItems() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    if (kDebugMode) {
      GMLogger.v("listRequestedQuantityItems" + utils.listRequestedQuantityItemsUrl());
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.listRequestedQuantityItemsUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> listQuantityAssignedAllocationItems() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["IsToReturnInactiveData"] = true;

    if (kDebugMode) {
      GMLogger.v("listQuantityAssignedAllocationItems" + utils.listQuantityAssignedAllocationItems());
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.listQuantityAssignedAllocationItems(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> listQAItemFetch(int id) async {
    GMAPIService service = GMAPIService();
    // Map<String, dynamic> input = <String, dynamic>{};
    // input["id"] = id;

    if (kDebugMode) {
      GMLogger.v(id);
    }
    Meta m = await service.statePostURL(utils.listFetchQAReqURL(), id.toString(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> listFetchAssignQAReqURL(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = id;
    if (kDebugMode) {
      GMLogger.v(id);
    }
    Meta m = await service.statePostURL(utils.listFetchAssignQAReqURL(), input.toString(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveQuantityLimit(CreateQuantityLimitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveQuantityLimitRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> updateQuantityLimit(UpdateQuantityLimitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.updateQuantityLimitRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveAllocateQuantityLimit(AllocateQuantityLimitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveAllocateQuantityLimitRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> updateAssignedQuantityLimit(AssignedQuantityLimitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.updateAssignedQuantityLimitRequestUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilTypeSkuList(int userId, int oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = oilTypeId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getOilTypeSkuListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQuantityLimitList(int userId, bool isAssigned) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (isAssigned) {
      input["LoginUserId"] = userId;
    } else {
      input["ZHId"] = userId;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(isAssigned ? utils.getQuantityAssignedListUrl() : utils.getUpdateQuantityLimitUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerSaudaDetails(int dealerId, int salesOrganizationId, int distributionChannelId, int divisionId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = dealerId;
    input["SalesOrganizationId"] = salesOrganizationId;
    input["DistributionChannelId"] = distributionChannelId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerSaudaDetailsUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
      GMLogger.v(m.statusCode);
    }
    return m;
  }

  Future<Meta> getDealerSaudaDefaultDetails(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerSaudaDefaultDetailsUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
      GMLogger.v(m.statusCode);
    }
    return m;
  }

  Future<Meta> getSalesOrderDataDetails(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSalesOrderDataDetailsUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
      GMLogger.v(m.statusCode);
    }
    return m;
  }

  Future<Meta> getFinalPriceSkuNameListForMobile(int dealerId, int userId, int saudaBookingTypeId, int plantId, int oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    // input["SaudaBookingTypeId"] = saudaBookingTypeId;
    input["plantId"] = plantId;
    input["OilTypeId"] = oilTypeId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getFinalPriceSkuNameListForMobile(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getFinalPriceSkuNameListForDealerPopup(int dealerId, int userId, int saudaBookingTypeId, int plantId, int oilTypeId, int skuId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    // input["SaudaBookingTypeId"] = saudaBookingTypeId;
    input["plantId"] = plantId;
    input["OilTypeId"] = oilTypeId;
    input["SkuId"] = skuId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getFinalPriceSkuNameListForDealerPopupUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSauda(NewSaudaRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSaudaUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveUserDiscount(UserDiscountRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveUserDiscountUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> updateUserDiscount(UserDiscountRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.updateUserDiscountUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveAssignedUserDiscount(AssignedDiscountRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveAssignedUserDiscountUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveGeographyDiscount(GeographyDiscountRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveGeographyDiscountUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> updateUserGeographyDiscount(GeographyDiscountRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.updateGeographyDiscountUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBDOSaudaConversionPendingApprovedList(
    int userId,
    String fromDate,
    String toDate,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getBDOSaudaConversionPendingApprovedListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaConversionSkuDetailsById(int saudaConversionId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["SaudaConversionId"] = saudaConversionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaConversionSkuDetailsByIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaExtensionPendingAndApprovalListForBdo(
    int userId,
    String fromDate,
    String toDate,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaExtensionPendingAndApprovalListForBdoUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBookedSauda(int userId, String fromDate, String toDate, {int bdoId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (bdoId > 0) {
      input["BdoIds"] = [bdoId];
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getBookedSaudaUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSauda(
    int userId,
    int saudaId,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["SaudaId"] = saudaId;
    input["UserId"] = userId;
    // input["ToDate"] = toDate;
    // input["DealerId"] = 3;
    // input["SalesOrganizationIds"] = [2];
    // input["DistributionChannelIds"] = [1];
    // input["DivisionIds"] = [1];

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaOrderDetail(
    int userId,
    int saudaId,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["SaudaOrderId"] = saudaId;
    // input["UserId"] = userId;
    // input["ToDate"] = toDate;
    // input["DealerId"] = 3;
    // input["SalesOrganizationIds"] = [2];
    // input["DistributionChannelIds"] = [1];
    // input["DivisionIds"] = [1];

    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaOrderDetailUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCustomerAudio(
    int dealerId,
    int brokerId,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["DealerId"] = dealerId;
    input["BrokerId"] = brokerId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCustomerAudioUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveAudioMapping(SaveAudioRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCustomerAudioSaveUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBookedSaudaWithextensionDetailsList(int userId, {int dealerId = 0, int bdoId = 0, int oilTypeId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = userId;
    if (dealerId > 0) {
      input["DealerIds"] = [dealerId];
    }
    if (bdoId > 0) {
      input["BdoIds"] = [bdoId];
    }
    if (oilTypeId > 0) {
      input["OilTypeIds"] = [oilTypeId];
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getBookedSaudaWithextensionDetailsListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAdminAppList(int userId, String fromDate, String toDate, int salesOrganizationId, int statusId, int pageNo, int distributionChannelId, int divisionId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["SalesOrganizationId"] = salesOrganizationId;
    input["StatusId"] = statusId;
    input["PageNo"] = pageNo;
    input["DistributionChannelId"] = distributionChannelId;
    input["DivisionId"] = divisionId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getAdminAppListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSaudaApproval(SaudaApprovalRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSaudaApprovalUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSaudaExtension(SaudaExtensionRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSaudaExtensionUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLiftingRequestList(int userId, int bdoId, int statusId, {String fromDate = "", String toDate = ""}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["BDOId"] = bdoId;
    input["StatusId"] = statusId;
    if (Constants.DEALER == Constants.AUTH_ROLEID) {
      input["DealerId"] = userId;
      input["FromDate"] = fromDate;
      input["ToDate"] = toDate;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLiftingRequestListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerLiftingRequestList(int userId, int dealerId, int statusId, String fromDate, String toDate, bool isFilter) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["StatusId"] = statusId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["IsFilter"] = isFilter;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerLiftingRequestListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLiftingRequestDetail(int userId, int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLiftingRequestDetailUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSalesOrderApproval(SaveSalesOrderApprovalRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSalesOrderApprovalUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  /* Sales And STP */
  Future<Meta> getYourPerformance(int userId, int dealerId, int statusId, String fromDate, String toDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["StatusId"] = statusId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getYourPerformanceUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPerformanceRankingList(int userId, int dealerId, int statusId, String fromDate, String toDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["StatusId"] = statusId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPerformanceRankingListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCreditlimitOverView(int userId, String fromDate, String toDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["IsToReturnInactiveData"] = true;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCreditlimitOverViewUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCreditLimitExposure(List<int> bdoIds, List<int> dealerIds, int creditId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["BdoIds"] = bdoIds;
    input["CreditId"] = creditId;
    if (dealerIds.isNotEmpty) {
      input["DealerIds"] = dealerIds;
    }
    input['LoginUserId'] = Constants.AUTH_USERID;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCreditLimitExposureUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSalesTourPlanChart(int userId, String fromDate, String toDate, int financialYearId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["financialYearId"] = financialYearId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSalesTourPlanChartUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getViewPCP(int userId, int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = id;
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getViewPCPUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getViewPCPDetail(int userId, int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["PjpId"] = id;
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getListPCPUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCurrentMTP(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getViewPCPUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCurrentMTPUpcomming(int userId, bool isUpcomming) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["IsUpcoming"] = isUpcomming;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCurrentMTPUpcommingUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getViewMTPDetail(int userId, int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["MTPId"] = id;
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getListMTPUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getHolidays(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getHolidaysUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTodayActivities(int userId, String todayDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["TodayDate"] = todayDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getTodayActivitiesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaNumberList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaNumberUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveDealerVisit(DealerVisitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaveDealerVisitUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveWholesalerVisit(WholesalerVisitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getWholesalerVisitAddUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> addProspectiveDealer(PerspectiveVisitRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getAddProspectiveDealerUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> submitDailySalesReport(int userId, int mtpId, String remarks) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["MTPId"] = mtpId;
    input["Remarks"] = remarks;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSubmitDailySalesReportUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getWholesalerVisitList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getWholesalerVisitListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getWholesalerVisitSecondarySales(int oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["OilTypeId"] = oilTypeId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getWholesalerVisitSecondarySalesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  // ToDo module not clear
  Future<Meta> WholesalerVisitAdd(int userId, ProspectiveDealerAddDto inputDto) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["ProspectiveDealerAddDto"] = inputDto;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getWholesalerVisitAddUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getApprovedMPDList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getApprovedMPDListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPendingMPDList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPendingMPDListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getApprovedMTPByUser(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getApprovedMTPByUserUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getApprovedMTPDetailByUser(int mtpId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["mtpId"] = mtpId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getApprovedMTPDetailByUserUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> MTPDeviationAdd(int userId, DeviationRequest inputDto) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = inputDto.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getMTPDeviationAddUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSecondarySalesFortheDayList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSecondarySalesFortheDayListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSecondarySalesFortheDayDetail(int userId, int wholesellerId, String visitDate) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["WholesellerId"] = wholesellerId;
    input["VisitDate"] = visitDate;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSecondarySalesFortheDayDetailUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getGetShipToPartyListByCustomerId(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["IsToReturnInactiveData"] = false;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getGetShipToPartyListByCustomerIdUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLoadabilityList(int distributorId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = distributorId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLoadabilityListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSkuListForSalesOrder(int dealerId, int userId, String saudaNumber, int plantId, int oilTypeId, double vehicleSize) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    // input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    // input["saudaNumber"] = saudaNumber;
    input["plantId"] = plantId;
    input["VehicleSize"] = vehicleSize;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSkuListForIndentRequest(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getContractList(int dealerId, int salesOrgId, int skuId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    // input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["SalesOrganizationId"] = salesOrgId;
    input["SkuId"] = skuId;
    // input["saudaNumber"] = saudaNumber;
    // input["plantId"] = plantId;
    // input["OilTypeId"] = oilTypeId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getContractListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getFillerSKUList(int userId, int dealerId, double volumePercentage, double weightPercentage, double vehicleSize, int plantId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["DealerId"] = dealerId;
    input["Volumepercentage"] = volumePercentage;
    input["plantId"] = plantId;
    input["Weightpercentage"] = weightPercentage;
    input["VehicleSize"] = vehicleSize;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getFillerSKUListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSalesOrder(SalesOrder request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSalesOrderUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveLimitEnhancement(LimitEnhancementRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveLimitEnhancementUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLimitEnhancementHistory(int userId, int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["Id"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLimitEnhancementHistoryUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSpecialRate(SpecialRateRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSpecialRateUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSpecialRateApproval(SpecialRateManagerRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveSpecialRateApprovalUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCompetitorList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCompetitorListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSkuByOilType(int oilTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["OilTypeId"] = oilTypeId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSkuByOilTypeUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> savePriceDiscovery(PriceDiscoveryRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.savePriceDiscoveryUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getYourSalesPerformance(int userId, String fromDate, String toDate, int roleId, bool isShowDealer) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["RoleId"] = roleId;
    input["IsShowDealer"] = isShowDealer;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getYourSalesPerformanceUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getYourSalesPerformanceRank(int userId, String fromDate, String toDate, int roleId, bool isShowDealer) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["RoleId"] = roleId;
    input["IsShowDealer"] = isShowDealer;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getYourSalesPerformanceRankUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPackGroupList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["IsToReturnInactiveData"] = false;

    // GMLogger.v(jsonEncode(input));
    Meta m = await service.processGetURL(utils.getPackGroupListUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }



  Future<Meta> getPackGroupSales(int userId, String fromDate, String toDate, int packGroupId, {int bdoId = 0, int zhId = 0, bool isFilter = false}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["PackGroupId"] = packGroupId;
    if (bdoId > 0) {
      input["BDOId"] = bdoId;
      input["CurrentFinancialYearId"] = 2;
    }
    if (zhId > 0) {
      input["ZHId"] = zhId;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPackGroupSalesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPackGroupDealerSales(int userId, String fromDate, String toDate, int dealerId, int packGroupId, bool isPendingSauda) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["DealerId"] = dealerId;
    input["PackGroupId"] = packGroupId;
    input["IsPendingSauda"] = isPendingSauda;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPackGroupDealerSalesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPackGroupInvoiceDetail(int userId, int id, bool isBulkPack, bool isPendingSauda) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["Id"] = id;
    input["IsBulkPack"] = isBulkPack;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPackGroupInvoiceDetailUrl(isPendingSauda), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCreditLimitTotal(int userId, String fromDate, String toDate, bool isToReturnInactiveData) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["IsToReturnInactiveData"] = isToReturnInactiveData;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCreditLimitTotalUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOverallChartSalesData(int userId, String fromDate, String toDate, bool isToReturnInactiveData) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    // input["IsToReturnInactiveData"] = isToReturnInactiveData;
    if (Constants.AUTH_ROLEID == Constants.SALE) {
      input["RoleId"] = 7;
      input["IsShowDealer"] = false;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getChartOverallSalesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerSalesData(int userId, String fromDate, String toDate, bool isToReturnInactiveData) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    // input["IsToReturnInactiveData"] = isToReturnInactiveData;
    if (Constants.AUTH_ROLEID == Constants.SALE) {
      input["RoleId"] = 7;
      input["IsShowDealer"] = true;
    } else {
      input["RoleId"] = Constants.AUTH_ROLEID;
      input["IsShowDealer"] = true;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerSalesUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBDOList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getBDOListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" dealer list data:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> loginToFetchExternalAPIRepo(String userName, String password) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["username"] = userName;
    input["password"] = password;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURLWithoutEncrypt(utils.loginToFetchExternalAPIURL(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" dealer list data:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> fetchExternalAPITrackOrdersRepo(String response, String distributorCode, String doNumberIds) async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURLForTrackOrders(

        /// these commented lines for checking purposes.
        // utils.fetchExternalAPITrackOrdersURL("customer_code=2116683&do_numbers=${"8004704168,8004711743,8004711750,8004713923"}&is_includes_all_dos=True"), response);
        // utils.fetchExternalAPITrackOrdersURL("customer_code=$distributorCode&do_numbers=${8003686323}"), response);
        // utils.fetchExternalAPITrackOrdersURL("customer_code=2112139&do_numbers=${"8004594170"}&is_includes_all_dos=True"), response);
        utils.fetchExternalAPITrackOrdersURL("customer_code=$distributorCode&do_numbers=$doNumberIds&is_includes_all_dos=True"),
        response);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> fetchSaleDataListAPITrackOrdersRepo(SaleDataRequest saleDataRequest) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    /*input["liftingId"] = 0;
    input["doNumber"] = null;
    input["isLiftingId"] = false;
    input["LoginUserId"] = userId;
    input["doNumbers"] = [{"doNumber":"8003507745","liftingId":0,"status":"COMPLETED"}];
*/
    input = saleDataRequest.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.fetchSalesDataListTrackOrdersURL(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" dealer list data:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getZonalHeadList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getZonalHeadList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getMaterialList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getMaterialList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getMaterialByOilTypePackageTypeList(int oilTypeIds,int packGroupIds, int packTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    List<int> oilTypeIdList = oilTypeIds.toString().split(',').map((e) => int.parse(e)).toList();
    List<int> packGroupIdsList = packGroupIds.toString().split(',').map((e) => int.parse(e)).toList();
    int packTypeIds = packTypeId;
    input["OilTypeIds"] = oilTypeIdList;
    input["PackGroupIds"] = packGroupIdsList;
    input["PackTypeId"] = packTypeIds;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getMaterialByOilTypePackageTypeList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getGeographyList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getMaterialList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getBDOListForTp(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getBDOListForTpUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSpecialRateApprovalListManager(int userId, String fromDate, String toDate, int bdoId, int statusId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    if (Constants.AUTH_ROLEID == Constants.ZHMANAGER) {
      input["BDOId"] = bdoId;
    } else if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      // input["BDOId"] = 0;
      input["ZhId"] = bdoId;
    }
    input["StatusId"] = statusId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSpecialRateApprovalListManagerUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPendingSaudaChartSlab(int userId) async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getPendingSaudaSlabUrl(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTickerList(int userId) async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getTickerList(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSalesReport(int userId, String fromDate, String toDate, List<int> nationalHeadIds, List<int> dealers, List<int> bdOs, List<int> zHs, List<int> oilTypes, List<int> packTypes,
      List<int> stateIds, int plantId, int oilPackGroupTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};

    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["OilPackGroupTypes"] = oilPackGroupTypeId;
    if (nationalHeadIds.isNotEmpty) {
      input["nationalHeadIds"] = nationalHeadIds;
    }
    if (dealers.isNotEmpty) {
      input["dealers"] = dealers;
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      input["dealers"] = [userId];
    }
    if (bdOs.isNotEmpty) {
      input["bdOs"] = bdOs;
    }
    if (zHs.isNotEmpty) {
      input["zHs"] = zHs;
    }
    if (oilTypes.isNotEmpty) {
      input["oilTypes"] = oilTypes;
    }
    if (packTypes.isNotEmpty) {
      input["packTypes"] = packTypes;
    }
    if (stateIds.isNotEmpty) {
      input["stateIds"] = stateIds;
    }
    if (plantId > 0) {
      input["plantId"] = plantId;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSalesReportUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaReport(int userId, String fromDate, String toDate, List<int> nationalHeadIds, List<int> dealers, List<int> bdOs, List<int> zHs, List<int> oilTypes, List<int> packTypes,
      List<int> stateIds, int plantId, int oilPackGroupTypeId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};

    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["OilPackGroupTypes"] = oilPackGroupTypeId;

    if (nationalHeadIds.isNotEmpty) {
      input["nationalHeadIds"] = nationalHeadIds;
    }
    if (dealers.isNotEmpty) {
      input["dealers"] = dealers;
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      input["dealers"] = [userId];
    }
    if (bdOs.isNotEmpty) {
      input["bdOs"] = bdOs;
    }
    if (zHs.isNotEmpty) {
      input["zHs"] = zHs;
    }
    if (oilTypes.isNotEmpty) {
      input["oilTypes"] = oilTypes;
    }
    if (packTypes.isNotEmpty) {
      input["packTypes"] = packTypes;
    }
    if (stateIds.isNotEmpty) {
      input["stateIds"] = stateIds;
    }
    if (plantId > 0) {
      input["plantId"] = plantId;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaReportUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(" SaudaReportData:");
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getChequePending(
    int userId,
    List<int> bdoIds,
    List<int> dealerIds,
  ) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      input["zonalHeadId"] = userId;
      if (bdoIds.isNotEmpty) {
        input["bdoIds"] = bdoIds;
      }
    } else if (Constants.SALE == Constants.AUTH_ROLEID) {
      input["bdoIds"] = [userId];
    }
    if (Constants.DEALER == Constants.AUTH_ROLEID) {
      input["dealerIds"] = [userId];
    }
    if (dealerIds.isNotEmpty) {
      input["dealerIds"] = dealerIds;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getChequesPendingUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPendingContractFilters(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPendingContractFilterUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getPendingContract(int userId, {int id = 0, List<int> skuIds = const []}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (id > 0) {
      input["Id"] = id;
    }
    if (Constants.AUTH_ROLEID == Constants.DEALER) {
      input["Id"] = userId;
    }
    if (skuIds.isNotEmpty) {
      input["SkuId"] = skuIds;
    } else if (Constants.AUTH_ROLEID == Constants.DEALER) {
      input["OilTypeId"] = 0;
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getPendingContractUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSupportList(int userId, {int queryFrom = 2, int raisedBy = 5, int statusId = 1, String fromDate = "", String toDate = ""}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    // input["queryFrom"] = queryFrom;
    // input["raisedBy"] = raisedBy;
    // input["statusId"] = statusId;
    input["fromDate"] = fromDate;
    input["toDate"] = toDate;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.getSupportListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSupportMaster(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    GMLogger.v(input);
    Meta m = await service.processPostURL(utils.getSupportCategoryListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSupport(SupportRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = request.toJson();
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getAddSupportUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCallToCustomerList(int userId, {List<int> bdoIds = const [], int zhId = 0}) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["IsToReturnInactiveData"] = false;
    input["LoginUserId"] = userId;
    if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      input["ZHId"] = userId;
      input["BdoIds"] = bdoIds;
    } else if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      if (bdoIds.length > 0) {
        input["ZHId"] = bdoIds[0];
      } else {
        input["ZHId"] = 0;
      }
    } else if (Constants.SALE == Constants.AUTH_ROLEID) {
      input["BdoIds"] = [userId];
    } else if (Constants.DEALER == Constants.AUTH_ROLEID) {
      input["DealerIds"] = [userId];
    }
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCallToCustomerListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveCallToCustomer(int bdoId, String dealerMobileNumnber, int dealerId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["bdoId"] = bdoId;
    input["dealerMobileNumber"] = dealerMobileNumnber;
    input["dealerId"] = dealerId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.saveCallToCustomerUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getCustomerLedgerNHData(int userID) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userID;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getCustomerLedgerNHData(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getNotifications(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getNotificationUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getLatestUpdatesList(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = 1;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getLatestUpdateListUrl(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaBookingStatus(int userId) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getSaudaBookingStatus(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQPS(QPSReqModel reqModel, bool isFromAlert) async {
    GMAPIService service = GMAPIService();
    // Map<String, dynamic> input = <String, dynamic>{};
    // input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(reqModel.toJson());
    }
    Meta m = await service.processPostURL(isFromAlert ? utils.getQPSDiscountUrl() : utils.getQPSUrl(), reqModel.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getQPSListOfDiscount(QPSReqModel reqModel) async {
    GMAPIService service = GMAPIService();
    // Map<String, dynamic> input = <String, dynamic>{};
    // input["LoginUserId"] = userId;
    if (kDebugMode) {
      GMLogger.v(reqModel.toJson());
    }
    Meta m = await service.processPostURL(utils.getQPSDiscountUrl(), reqModel.toJson(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getGamificationDashboardDetails(String distributorCode) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["DistributorCode"] = distributorCode;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getGamificationDashboard(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTdsDeclarationQuestions(dynamic formId, int auth_userid) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["FormId"] = formId;
    input["UserId"] = auth_userid.toString();
    Meta m = await service.processPostURL(utils.getTdsQuestionsData(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTdsFormListAPi(int authUserid) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = authUserid.toString();
    Meta m = await service.processPostURL(utils.getTDSFormListApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTanNumberApi(int authUserid, String auth_dealer_code) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = authUserid.toString();
    input["Code"] = auth_dealer_code;
    Meta m = await service.processPostURL(utils.getTanNumber(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getTanNumberUpdate(int authUserid, String tanNumber) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = authUserid.toString();
    input["TANNumber"] = tanNumber;
    Meta m = await service.processPostURL(utils.updateTanNumber(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> submitSurveyQuestionApi(SubmitRequestModel requestModel) async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processPostURLData(utils.submitSurveyQuestionsApi(), requestModel, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAccountStatementDate() async {
    GMAPIService service = GMAPIService();
    Meta m = await service.processGetURL(utils.getAccountStatementDate(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAccountStatementCount() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["CustomerUserId"] = Constants.AUTH_DEALER_CODE;
    Meta m = await service.processPostURL(utils.getAccountStatementCountURL(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAccountStatementStatusUpdate(int requestID) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["CustomerUserId"] = Constants.AUTH_DEALER_CODE;
    input["Requestid"] = requestID;
    Meta m = await service.processPostURL(utils.getAccountStatementStatusUpdateURL(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAccountStatementSubmit(AccountStatementRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["Id"] = request.id;
    input["LoginUserId"] = request.loginUserId;
    input["CompanyName"] = request.companyName;
    input["CustomerName"] = request.customerName;
    input["FromDate"] = request.fromDate;
    input["ToDate"] = request.toDate;
    input["Currency"] = request.currency;
    input["IsWithoutSpecialGL"] = request.isWithoutSpecialGL.toString();
    input["DocumentType"] = request.documentType.toString();
    input["IsActive"] = request.isActive.toString();
    Meta m = await service.processPostURL(utils.getAccountStatementSubmit(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSubmitCustomerStatement(CustomerStatement customerStatement) async {

    GMAPIService service = GMAPIService();
    Meta m = await service.processPostURLWithoutEncryptDirect(utils.getCustomerStatementURL(), customerStatement.toJson(), Constants.AUTH_TOKEN);

    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getGeographyDiscountDetailsApi(GeoDiscountDetailRequest request) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["ParentId"] = request.parentId;
    input["PageNumber"] = 1;
    input["PageSize"] = 10;
    Meta m = await service.processPostURL(utils.getGeographyDiscountDetailsApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaRestrictionList() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] =  Constants.AUTH_USERID;
    Meta m = await service.processPostURL(utils.getRestrictionList(),input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getAddResRolesApi() async {
    GMAPIService service = GMAPIService();
    // GMLogger.v(jsonEncode(input));
    Meta m = await service.processGetURL(utils.getRolesApi(), Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getStateTraderListApi() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    input["isToReturnInactiveData"] = true;
    Meta m = await service.processPostURL(utils.getStateTraderList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getZonalTraderApi() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    input["isToReturnInactiveData"] = true;
    Meta m = await service.processPostURL(utils.getZonalTraderApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributorsList() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    Meta m = await service.processPostURL(utils.getDistributorsList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilTypeApi() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    Meta m = await service.processPostURL(utils.getOilTypeList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveSaudaRestriction(SaveSaudaRestReqmodel reqmodel) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    input["userIdsForDistributor"] = reqmodel.userIdsForDistributor;
    input["userIdsForStateTrader"] = reqmodel.userIdsForStateTrader;
    input["userIdsForZonalTrader"] = reqmodel.userIdsForZonalTrader;
    input["oilTypeIds"] = reqmodel.oilTypeIds;
    input["startDate"] = reqmodel.startDate;
    input["roleId"] = reqmodel.roleId;
    input["isActive"] = reqmodel.isActive;
    Meta m = await service.processPostURL(utils.saveSaudaRestriction(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveandUpdateRestriction(SaveSaudaRestReqmodel reqmodel) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    input["userIdsForDistributor"] = reqmodel.userIdsForDistributor;
    input["userIdsForStateTrader"] = reqmodel.userIdsForStateTrader;
    input["userIdsForZonalTrader"] = reqmodel.userIdsForZonalTrader;
    input["oilTypeIds"] = reqmodel.oilTypeIds;
    input["startDate"] = reqmodel.startDate;
    input["roleId"] = reqmodel.roleId;
    input["isActive"] = reqmodel.isActive;
    input["id"] = reqmodel.id;
    Meta m = await service.processPostURL(
        utils.saveandUpdateRestriction(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributorApi() async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    //input["roleId"] = Constants.AUTH_ROLEID;
    Meta m = await service.processPostURL(utils.getModDistributorAPI(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getContractNumber(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["UserId"] = props[0];
    Meta m = await service.processPostURL(utils.getModContractApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getModOilMaterialAPi(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["saudaNumber"] = props[0];
    Meta m = await service.processPostURL(utils.getModOilMaterialAPi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }
  Future<Meta> getToSkuFromOilApiCall(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["oilTypeId"] = props[0];
    input["skuId"] = props[1];
    Meta m = await service.processPostURL(utils.gettoSkuFromOilAPi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }
  Future<Meta> saveSaudaModificationApi(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    SaudaModificationCreationModel model = props[0] as SaudaModificationCreationModel;
    input = model.toJson();
    Meta m = await service.processPostURL(utils.saveSaudaMod(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }
  Future<Meta> getModificationList(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["FromDate"] = props[0];
    input["ToDate"] = props[1];
    Meta m = await service.processPostURL(utils.SaudaModListApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getOilListApi(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["saudaNumber"] = props[0];
    Meta m = await service.processPostURL(utils.getOilListApi(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getToSkuList(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["oilTypeId"] = props[0];
    input["oilPackGroupTypeId"] = props[1];
    input["saudaNumber"] = props[2];
    input["loginUserId"] = Constants.AUTH_USERID;
    input["dealerId"] = props[3];
    Meta m = await service.processPostURL(utils.getToSkuList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaModDetails(List<Object?> props) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["loginUserId"] = Constants.AUTH_USERID;
    input["id"] =props[0];
    Meta m = await service.processPostURL(utils.getSaudaModDetails(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getSaudaApprovalList(int userId, String fromDate, String toDate, int distributionChannelId, int divisionId, int salesOrganizationId,) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = userId;
    input["FromDate"] = fromDate;
    input["ToDate"] = toDate;
    input["SalesOrganizationId"] = salesOrganizationId;
    input["DistributionChannelId"] = distributionChannelId;
    input["DivisionId"] =divisionId;
    input["StatusId"] ="1";
    input["PageNo"] = "0";
    Meta m = await service.processPostURL(utils.getSaudaApprovalList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveRejectApproval(SaudaModApprovalRequest saudaModApprovalRequest) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input= saudaModApprovalRequest.toJson();
    Meta m = await service.processPostURL(utils.getStatusChangeApiCall(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getStockSkuList(SaudaModApprovalRequest saudaModApprovalRequest) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    Meta m = await service.processPostURL(utils.getStockList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> saveStockItemsApiCall(StockCreationRequest stockItems) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input = stockItems.toJson();
    Meta m = await service.processPostURL(utils.saveStockList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getStockSubmissionList(int pageNo) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["PageNo"] = pageNo;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getStockSubmissionList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getZHItemList(int pageNo) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getStockSubmissionList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDistributorList(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getStockDistributorList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getStateTradersList(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getStateAndZonalList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getZonalheadList(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getStateAndZonalList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

  Future<Meta> getDealerStockReportList(int id) async {
    GMAPIService service = GMAPIService();
    Map<String, dynamic> input = <String, dynamic>{};
    input["LoginUserId"] = Constants.AUTH_USERID;
    input["DealerId"] = id;
    if (kDebugMode) {
      GMLogger.v(input);
    }
    Meta m = await service.processPostURL(utils.getDealerStockReportList(), input, Constants.AUTH_TOKEN);
    if (kDebugMode) {
      GMLogger.v(m.statusMsg);
    }
    return m;
  }

}
