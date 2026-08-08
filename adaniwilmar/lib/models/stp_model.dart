import 'package:adaniwilmar/config/constant.dart';
import 'package:equatable/equatable.dart';

import '../utils/constant.dart';

class StpModel extends Equatable {
  final String name;
  final bool? round;
  final String imageUrl;

  const StpModel({required this.name, this.round, required this.imageUrl});

  @override
  List<Object?> get props => [name, imageUrl];

  static List<StpModel> stpData = [
    StpModel(
      name: 'Daily Sales Report',
      round: false,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
    StpModel(
      name: 'Deviation Approval Status',
      round: false,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
    StpModel(
      name: 'Secondary Sales For the Day',
      round: false,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
  ];
}
