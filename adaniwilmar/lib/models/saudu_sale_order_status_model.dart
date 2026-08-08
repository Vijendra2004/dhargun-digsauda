import 'package:adaniwilmar/models/quantity_allocation_model.dart';

class SaudaSaleOrderStatusModel extends BaseModel {
  final String name;
  final String? amt;

  SaudaSaleOrderStatusModel({required this.name, this.amt});

  @override
  List<Object?> get props => [name, amt];

  Map<String, dynamic> _toMap() {
    return {
      'name': name,
      'amt': amt,
    };
  }

  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }

  static List<SaudaSaleOrderStatusModel> sauduSalesStatus = [
    SaudaSaleOrderStatusModel(
      name: 'Harilal & Sons',
      amt: '20',
    ),
    SaudaSaleOrderStatusModel(
      name: 'Radhika Emporium Pvt Ltd',
      amt: '30',
    ),
    SaudaSaleOrderStatusModel(
      name: 'Ace Traders',
      amt: '40',
    ),
    SaudaSaleOrderStatusModel(
      name: 'Trinath Traders',
      amt: '50',
    ),
  ];
}
