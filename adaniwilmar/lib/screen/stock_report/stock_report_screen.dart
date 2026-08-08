import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../gmcore/network/GMLogger.dart';
import '../../models/DealerStockResponse.dart';
import '../../models/stock_report_model.dart';
import '../../models/stock_submission_model.dart';
import '../../utils/constant.dart';
import '../../widget/widget.dart';
import 'bloc/bloc.dart';

class StockReportScreen extends StatelessWidget {
  const StockReportScreen({Key? key}) : super(key: key);
  static const String routeName = '/stock_report';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const StockReportScreen());
  }

  @override
  Widget build(BuildContext context) {
    if (Constants.NHMANAGER == Constants.AUTH_ROLEID) {
      return BlocProvider(
        create: (context) =>
            StockReportBloc()..add(LoadZH(NHID: Constants.AUTH_USERID)),
        child: const StockReportView(),
      );
    } else if (Constants.ZHMANAGER == Constants.AUTH_ROLEID) {
      return BlocProvider(
        create: (context) =>
            StockReportBloc()..add(LoadST(ZHId: Constants.AUTH_USERID)),
        child: const StockReportView(),
      );
    } else if (Constants.SALE == Constants.AUTH_ROLEID) {
      return BlocProvider(
        create: (context) => StockReportBloc()
          ..add(LoadDistributor(STId: Constants.AUTH_USERID)),
        child: const StockReportView(),
      );
    } else {
      return BlocProvider(
        create: (context) => StockReportBloc()
          ..add(FetchStockReportList(
              zonalTraderId: 0,
              stateTradeId: 0,
              distributorId: Constants.AUTH_USERID)),
        child: const StockReportView(),
      );
    }
  }
}

class StockReportView extends StatefulWidget {
  const StockReportView({Key? key}) : super(key: key);

  @override
  State<StockReportView> createState() => _StockReportViewState();
}

class _StockReportViewState extends State<StockReportView> {
  late ScrollController _scrollController;
  final Map<int, bool> _expandedItems = {};
  int _currentPage = 0;

  // Dropdown selection values
  int? _selectedZonalTraderId;
  int? _selectedStateTradeId;
  int? _selectedDistributorId;

  ZonalTrader? _selectedZonalTrader;
  StateTrader? _selectedStateTrader;
  Distributor? _selectedDistributor;

  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more items
      final state = context.read<StockReportBloc>().state;
      /*if (state.stockEntries.isNotEmpty && state.hasMore) {
        _currentPage++;
        context.read<StockReportBloc>().add(FetchStockReportList(
              zonalTraderId: _selectedZonalTraderId ?? 0,
              stateTradeId: _selectedStateTradeId ?? 0,
              distributorId: _selectedDistributorId ?? 0,
              pageNo: _currentPage,
            ));
      }*/
    }
  }

  bool _validateFilters() {
    switch (Constants.AUTH_ROLEID) {
      case Constants.NHMANAGER:
        return _selectedZonalTraderId != null &&
            _selectedStateTradeId != null &&
            _selectedDistributorId != null;

      case Constants.ZHMANAGER:
        return _selectedStateTradeId != null && _selectedDistributorId != null;

      case Constants.SALE:
        return _selectedDistributorId != null;

      default:
        return false;
    }
  }

  void _submitFilters() {
    if (!_validateFilters()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all dropdown options')),
      );
      return;
    }

    setState(() {
      _hasSubmitted = true;
      _currentPage = 0;
      _expandedItems.clear();
    });

    context.read<StockReportBloc>().add(FetchStockReportList(
          zonalTraderId: _selectedZonalTraderId ?? 0,
          stateTradeId: _selectedStateTradeId ?? 0,
          distributorId: _selectedDistributorId ?? 0,
          pageNo: 0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<ZonalTrader> zonalTraders = [];
    List<StateTrader> stateTraders = [];
    List<Distributor> distributors = [];
    List<StockEntry> stockEntries = [];
    bool hasMore = false;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Stock Report", backArrow: true),
        body: BlocBuilder<StockReportBloc, StockReportState>(
          builder: (context, state) {
            /* if (state is DropdownDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ZhDropDownLoad) {
              zonalTraders = state.zonalTraders;
            } else if (state is StateDropDown) {
              stateTraders = state.stateTraders;
            } else if (state is DistributorDropDown) {
              distributors = state.distributors;
            } else if (state is StockReportLoaded) {
              hasMore = state.hasMore;
            }*/
            /*if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }*/

            return Stack(
              children: [
                Positioned(
                  child: Container(
                    child: Constant.bgImgGlobal,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
                  child: Column(
                    children: [
                      // Filters Card
                      CurveBorderBox(
                          boxLRPadding: 8.0,
                          boxTOPPadding: 12.0,
                          boxofWidget: Column(
                            children: [
                              // Zonal Trader Dropdown (Only NH)
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                    Constants.NHMANAGER,
                                child: _buildDropdownField(
                                  'Zonal Trader',
                                  _selectedZonalTrader?.name ?? 'Select Zonal Trader',
                                  () => _showZonalTraderDropdown(
                                      state.zonalTraders),
                                ),
                              ),
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                    Constants.NHMANAGER,
                                child: const SizedBox(height: 12),
                              ),

                              // State Trader Dropdown (NH & ZH)
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                        Constants.NHMANAGER ||
                                    Constants.AUTH_ROLEID ==
                                        Constants.ZHMANAGER,
                                child: _buildDropdownField(
                                  'State Trader',
                                  _selectedStateTrader?.name ?? 'Select State Trader',
                                  () => _showStateTraderDropdown(
                                      state.stateTraders),
                                ),
                              ),
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                        Constants.NHMANAGER ||
                                    Constants.AUTH_ROLEID ==
                                        Constants.ZHMANAGER,
                                child: const SizedBox(height: 12),
                              ),

                              // Distributor Dropdown (NH, ZH & STATE)
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                        Constants.NHMANAGER ||
                                    Constants.AUTH_ROLEID ==
                                        Constants.ZHMANAGER ||
                                    Constants.AUTH_ROLEID == Constants.SALE,
                                child: _buildDropdownField(
                                  'Distributor',
                                  _selectedDistributor?.employeeName ??
                                      'Select Distributor',
                                  () => _showDistributorDropdown(
                                      state.distributors),
                                ),
                              ),
                              Visibility(
                                visible: Constants.AUTH_ROLEID ==
                                        Constants.NHMANAGER ||
                                    Constants.AUTH_ROLEID ==
                                        Constants.ZHMANAGER ||
                                    Constants.AUTH_ROLEID == Constants.SALE,
                                child: const SizedBox(height: 16),
                              ),

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _submitFilters,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Constant.pricbuttonColor ?? Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 12),
                      // Stock List
                      if (_hasSubmitted)
                        Expanded(
                          child: BlocBuilder<StockReportBloc, StockReportState>(
                            builder: (context, state) {
                              /*if (state.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }*/
                              if (state.error != null &&
                                  state.error!.isNotEmpty) {
                                return Center(
                                  child: Text(
                                    state.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              if (state.stockEntries.isEmpty) {
                                return const Center(
                                    child: Text("No stock data available"));
                              }
                              return CurveBorderBox(
                                  boxLRPadding: 8.0,
                                  boxTOPPadding: 12.0,
                                  boxofWidget: Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 8),
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            "Sku Details",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        itemCount: state.stockEntries.length,
                                        itemBuilder: (context, index) {
                                          if (index ==
                                              state.stockEntries.length) {
                                            return const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            );
                                          }
                                          final StockReportItem entry =
                                              state.stockEntries[index];
                                          return _buildSkuDetailItem(
                                            entry,
                                          );
                                        },
                                      ),
                                    ],
                                  ));
                            },
                          ),
                        )
                      else
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Select filters and submit to view stock report',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (state.loading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.2), // Transparent background
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showZonalTraderDropdown(List<ZonalTrader> traders) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (builderContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(builderContext).size.height * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Zonal Trader',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(builderContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: traders.length,
                itemBuilder: (listContext, index) {
                  final trader = traders[index];
                  return ListTile(
                    title: Text(trader.name),
                    onTap: () {
                      Navigator.pop(builderContext);

                      setState(() {
                        _selectedZonalTrader = trader;
                        _selectedZonalTraderId = trader.id;
                        clearUI(); // Only clears dependent selections
                      });

                      context.read<StockReportBloc>().add(
                        LoadST(ZHId: trader.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStateTraderDropdown(List<StateTrader> traders) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (builderContext) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(builderContext).size.height * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select State Trader',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(builderContext),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: traders.length,
                itemBuilder: (listContext, index) {
                  final trader = traders[index];
                  return ListTile(
                    title: Text(trader.name),
                    onTap: () {
                      clearUI();
                      setState(() {
                        _selectedStateTradeId = trader.id;
                        _selectedStateTrader = trader;
                      });
                      Navigator.pop(listContext);
                      context
                          .read<StockReportBloc>()
                          .add(LoadDistributor(STId: _selectedStateTradeId!));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDistributorDropdown(List<Distributor> distributors) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Distributor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: distributors.length,
                itemBuilder: (context, index) {
                  final distributor = distributors[index];
                  return ListTile(
                    title: Text(distributor.employeeName),
                    onTap: () {
                      setState(() {
                        _selectedDistributorId = distributor.id;
                        _selectedDistributor = distributor;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkuDetailItem(StockReportItem entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.skuName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: ${entry.skuCode}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (Constant.pricbuttonColor ?? Colors.red).withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SKU #${entry.skuId}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Constant.pricbuttonColor ?? Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildDetailRow(
                  'Quantity (Cases)',
                  entry.quantityInCase.toStringAsFixed(0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailRow(
                  'Quantity (MT)',
                  entry.quantityInMT.toStringAsFixed(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void clearUI() {
    if (Constants.AUTH_ROLEID == Constants.NHMANAGER) {
      _selectedDistributorId = null;
      _selectedStateTradeId = null;
      _selectedDistributor = null;
      _selectedStateTrader = null;
    } else if (Constants.AUTH_ROLEID == Constants.ZHMANAGER || Constants.AUTH_ROLEID == Constants.SALE) {
      _selectedDistributor = null;
      _selectedDistributorId = null;
    }
    context.read<StockReportBloc>().add(ClearStockReport());
  }
}
