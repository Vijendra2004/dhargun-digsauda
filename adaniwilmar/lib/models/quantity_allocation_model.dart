import 'package:equatable/equatable.dart';

class BaseModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class QualityAllocationModel extends BaseModel {
  final String name;
  final String? amt;

  QualityAllocationModel({required this.name, this.amt});

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

  static List<QualityAllocationModel> callToCustomer = [
    QualityAllocationModel(
      name: 'Harilal & Sons1',
      amt: '102019',
    ),
    QualityAllocationModel(
      name: 'Radhika Emporium Pvt Ltd2',
      amt: '102651',
    ),
    QualityAllocationModel(
      name: 'Ace Traders3',
      amt: '102147',
    ),
    QualityAllocationModel(
      name: 'Trinath Traders4',
      amt: '102019',
    ),
  ];
}
