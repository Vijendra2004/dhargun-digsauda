import 'package:adaniwilmar/models/daily_rate_response.dart';
import 'package:adaniwilmar/models/dealer_response.dart';
import 'package:adaniwilmar/models/dealer_sauda_response.dart';
import 'package:adaniwilmar/models/weekly_response.dart';
import 'package:equatable/equatable.dart';

import '../../../models/dealer_pending_sauda_sales.dart';
import '../../../models/pending_sauda_distributor_details_response.dart';

abstract class PendingSaudaDetailState extends Equatable {
  const PendingSaudaDetailState();

  @override
  List<Object> get props => [];
}

class InitialPendingSaudaDetailState extends PendingSaudaDetailState {}

class ShowProgressBar extends PendingSaudaDetailState {}

class HideProgressBar extends PendingSaudaDetailState {}

class OnSuccess extends PendingSaudaDetailState {
  final WeeklyResponse response;

  const OnSuccess({required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

class OnFailure extends PendingSaudaDetailState {
  final String error;

  const OnFailure({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnLoadSuccess extends PendingSaudaDetailState {
  final List<PendingSaudaList> pendingSauda;

  const OnLoadSuccess({required this.pendingSauda});

  @override
  // TODO: implement props
  List<Object> get props => [pendingSauda];
}

class OnLoadSalesSuccess extends PendingSaudaDetailState {
  final DealerPendingSales dealerInvoiceResponse;

  const OnLoadSalesSuccess({required this.dealerInvoiceResponse});

  @override
  // TODO: implement props
  List<Object> get props => [dealerInvoiceResponse];
}

class OnLoadPendingSaudaDetail extends PendingSaudaDetailState {
  final List<DistributorList> distributorList;

  const OnLoadPendingSaudaDetail({required this.distributorList});

  @override
  // TODO: implement props
  List<Object> get props => [distributorList];
}

class OnLoadDealerDetail extends PendingSaudaDetailState {
  final DealerDetail dealerDetail;

  const OnLoadDealerDetail({required this.dealerDetail});

  @override
  // TODO: implement props
  List<Object> get props => [dealerDetail];
}

class OnLoadDealerSaudaList extends PendingSaudaDetailState {
  final List<PendingSaudaList> saudaList;

  const OnLoadDealerSaudaList({required this.saudaList});

  @override
  // TODO: implement props
  List<Object> get props => [saudaList];
}

class OnLoadDealerSalesList extends PendingSaudaDetailState {
  final List<DealerSaudaList> salesList;

  const OnLoadDealerSalesList({required this.salesList});

  @override
  // TODO: implement props
  List<Object> get props => [salesList];
}

class OnLoadSalesOrganization extends PendingSaudaDetailState {
  final List<SalesOrganization> salesOrganization;

  const OnLoadSalesOrganization({required this.salesOrganization});

  @override
  // TODO: implement props
  List<Object> get props => [salesOrganization];
}

class OnLoadDistributionChannel extends PendingSaudaDetailState {
  final List<DistributionChannel> distributionChannel;

  const OnLoadDistributionChannel({required this.distributionChannel});

  @override
  // TODO: implement props
  List<Object> get props => [distributionChannel];
}

class OnLoadVerticalList extends PendingSaudaDetailState {
  final List<Vertical> verticalList;

  const OnLoadVerticalList({required this.verticalList});

  @override
  // TODO: implement props
  List<Object> get props => [verticalList];
}

class OnDelayState extends PendingSaudaDetailState {
  const OnDelayState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
