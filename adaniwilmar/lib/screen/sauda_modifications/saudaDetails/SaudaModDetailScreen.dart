import 'package:adaniwilmar/screen/sauda_modifications/saudaDetails/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/constant.dart';
import '../../../models/SaudaDetailModel.dart';
import '../../../widget/curved_border_box.dart';
import '../../../widget/custom_appbar.dart';

class SaudaModDetailScreen extends StatelessWidget {
  final int id;
  const SaudaModDetailScreen({Key? key,required this.id}) : super(key: key);
  static const String routeName = '/';

  Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => SaudaModDetailScreen(id: id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaudaModDetailListBloc()..add(LoadSaudaModDetails(id)),
      child: SaudaModDetail(),
    );
  }
}

class SaudaModDetail extends StatefulWidget {
  const SaudaModDetail({Key? key}) : super(key: key);

  @override
  State<SaudaModDetail> createState() => _SaudaModDetailState();
}

class _SaudaModDetailState extends State<SaudaModDetail>
    with TickerProviderStateMixin {
  final colors = [
    Colors.purple,
    Colors.green,
  ];
  TabController? tabController;
  Color? indicatorColor;

  int pendingCount = 0;
  int approvedCount = 0;
  ModResponseData responseData = ModResponseData();
  List<SaudaLine> detailLineItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double screenWidth = 0.0;
  double screenHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        Constant.appBarHeight;
    screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<SaudaModDetailListBloc, SaudaModDetailState>(
        listener: (context, state) {
          if (state is OnSaudaModDetailSuccess) {
            responseData = state.lineItems;
            detailLineItems = responseData.lines!;
            setState(() {});
          }
        },
        child: Scaffold(
          primary: false,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(
              title: "Sauda Modification Detail", backArrow: true),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              SafeArea(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CurveBorderBox(
                          boxBgColor: const Color(0xFFFFFBF5),
                          boxShadowColor: const Color(0xFFFFFFFF),
                          boxofWidget: Container(
                            margin: const EdgeInsets.all(2.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    _contractHeader(responseData),
                                    const Divider(height: 1),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: detailLineItems.length,
                                      itemBuilder: (context, index) {
                                        final line = detailLineItems[index];
                                        return _oilTypeExpansion(line);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ));
  }

  Widget _contractHeader(ModResponseData responseData) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Sauda No', responseData.saudaNumber),
          _infoRow('Status', responseData.status),
          _infoRow('Created By', responseData.createdByName),
          _infoRow(
            'Created Date',
            responseData.createdDate.toString().split('T').first,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label :',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? '-'),
          ),
        ],
      ),
    );
  }

  Widget _oilTypeExpansion(SaudaLine line) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          line.oilTypeName ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${line.oilPackGroupTypeName} | Total Qty: ${line.totalModifiedQty}',
          style: const TextStyle(fontSize: 12,color: Colors.black),
        ),
        childrenPadding: const EdgeInsets.all(5),
        children: [
          if (line.oldItems!.isNotEmpty) ...[
            _sectionTitle('From Sauda', Colors.black),
            ...line.oldItems!.map((e) => _itemCard(e)),
            const SizedBox(height: 12),
          ],
          if (line.newItems!.isNotEmpty) ...[
            _sectionTitle('To Sauda', Colors.black),
            ...line.newItems!.map((e) => _itemCard(e)),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left:5 ,bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _itemCard(SkuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.skuName ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cases: ${item.quantityInCase}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'MT: ${item.saudaQuantity}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
