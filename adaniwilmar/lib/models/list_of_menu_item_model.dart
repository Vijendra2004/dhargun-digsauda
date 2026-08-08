import 'package:equatable/equatable.dart';

class ListOFMenuItemModel extends Equatable {
  final String name;
  final bool? round;
  final String imageUrl;
  final String? url;

  const ListOFMenuItemModel(
      {required this.name, this.round, required this.imageUrl, this.url});

  @override
  List<Object?> get props => [name, imageUrl];

  static List<ListOFMenuItemModel> category = [
    const ListOFMenuItemModel(
        url: "", name: 'Customer Ledger', round: false, imageUrl: ""),
    const ListOFMenuItemModel(
        name: 'Call to Customer', round: false, imageUrl: ""),
    const ListOFMenuItemModel(
        name: 'Special Rate Approval', round: true, imageUrl: ""),
    const ListOFMenuItemModel(
        name: 'Quantity Allocation', round: false, imageUrl: ""),
    const ListOFMenuItemModel(
        name: 'Request Quantity', round: false, imageUrl: ""),
    const ListOFMenuItemModel(
        name: 'Track Your Truck', round: false, imageUrl: ""),
  ];
}
