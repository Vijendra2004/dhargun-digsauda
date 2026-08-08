import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../models/stock_submission_model.dart';
import '../../widget/widget.dart';
import '../screen.dart';
import 'bloc/bloc.dart';

class StockListScreen extends StatelessWidget {
  const StockListScreen({Key? key}) : super(key: key);
  static const String routeName = '/stock_list';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const StockListScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockListBloc()..add(const FetchStockList()),
      child: const StockListView(),
    );
  }
}

class StockListView extends StatefulWidget {
  const StockListView({Key? key}) : super(key: key);

  @override
  State<StockListView> createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  final TextEditingController _searchQueryController = TextEditingController();
  late ScrollController _scrollController;
  final Map<int, bool> _expandedItems = {};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchQueryController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more items
      final state = context.read<StockListBloc>().state;
      if (state is StockListLoaded && state.hasMore) {
        _currentPage++;
        context
            .read<StockListBloc>()
            .add(FetchStockList(pageNo: _currentPage));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "Stock List", backArrow: true),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Constant.pricbuttonColor,
          onPressed: () async {
            final bloc = context.read<StockListBloc>();
            final bool? refresh = await Navigator.pushNamed(
              context,
              StockCreationScreen.routeName,
            ) as bool?;

            if (!context.mounted){
              bloc.add(FetchStockList(pageNo: _currentPage));
            }else {
              if (refresh == true) {
                context.read<StockListBloc>().add(FetchStockList(pageNo: _currentPage));
              }
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Stack(
          children: [
            Positioned(
              child: Container(
                child: Constant.bgImgGlobal,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 60, left: 8, right: 8),
              child: CurveBorderBox(
                boxLRPadding: 0.0,
                boxTOPPadding: 0.0,
                boxofWidget: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<StockListBloc, StockListState>(
                        builder: (context, state) {
                          if (state is StockListLoading &&
                              state is! StockListLoaded) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is StockListLoaded) {
                            if (state.stockEntries.isEmpty) {
                              return const Center(
                                  child: Text(
                                      "No stock data available"));
                            }
                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 8),
                              itemCount: state.stockEntries.length +
                                  (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.stockEntries.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }

                                final StockEntry entry =
                                    state.stockEntries[index];
                                final bool isExpanded =
                                    _expandedItems[entry.entryId] ?? false;

                                return _buildStockItemCard(
                                  entry,
                                  isExpanded,
                                  () {
                                    setState(() {
                                      _expandedItems[entry.entryId] =
                                          !isExpanded;
                                    });
                                  },
                                );
                              },
                            );
                          } else if (state is StockListError) {
                            return Center(child: Text(state.message));
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockItemCard(
      StockEntry entry, bool isExpanded, VoidCallback onTap) {
    return Column(
      children: [
        CurveOuterBox(
          boxLRPadding: 0,
          boxTBPadding: 12,
          boxofWidget: InkWell(
            onTap: onTap,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 3,
                      height: 22,
                      color: Constant.callToCcolor1,
                      margin: const EdgeInsets.only(left: 0),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Stock Entry #${entry.entryId}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${entry.reportedDate}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Cases: ${entry.totalQuantityInCase.toStringAsFixed(0)} | MT: ${_formatDecimal(entry.totalQuantityInMT)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) _buildSkuDetailsSection(entry),
      ],
    );
  }

  Widget _buildSkuDetailsSection(StockEntry entry) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SKU Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12,),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child:
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entry.skuDetails.length,
              itemBuilder: (context, index) {
                final SkuDetail sku = entry.skuDetails[index];
                return _buildSkuDetailItem(sku, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkuDetailItem(SkuDetail sku, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(8),
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
                      sku.skuName,
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
                      'Code: ${sku.skuCode}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (Constant.pricbuttonColor ?? Colors.red).withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SKU #${sku.skuId}',
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
                   sku.quantityInCase.toStringAsFixed(0),
                 ),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: _buildDetailRow(
                   'Quantity (MT)',
                   _formatDecimal(sku.quantityInMT),
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

  String _formatDecimal(double value) {
    // Format to 2 decimal places
    return value.toStringAsFixed(2);
  }
}
