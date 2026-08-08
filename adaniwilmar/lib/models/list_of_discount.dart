import 'package:equatable/equatable.dart';

class ListOFDiscountModel extends Equatable {
  final String name;
  final bool? round;
  final String? url;

  const ListOFDiscountModel(
      {required this.name, this.round,  this.url});

  @override
  List<Object?> get props => [name];

  static List<ListOFDiscountModel> nList = [
    const ListOFDiscountModel(
      name: 'Geography Discount',
      round: false,
    ),
    const ListOFDiscountModel(
      name: 'User Discount',
      round: false,
    ),
  ];

  static List<ListOFDiscountModel> zsList = [
    const ListOFDiscountModel(
      name: 'Geography Discount',
      round: false,
    ),
    const ListOFDiscountModel(
      name: 'Assigned Discount',
      round: true,
    ),
  ];
}
