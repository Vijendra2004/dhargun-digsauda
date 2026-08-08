import 'package:equatable/equatable.dart';

class ListOFUpdateModel extends Equatable {
  final String name;
  final bool? round;
  final String imageUrl;
  final String? url;

  const ListOFUpdateModel(
      {required this.name, this.round, required this.imageUrl, this.url});

  @override
  List<Object?> get props => [name, imageUrl];

  static List<ListOFUpdateModel> category = [
    const ListOFUpdateModel(
      url: "",
      name: 'Feedback Request',
      round: false,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
    const ListOFUpdateModel(
      name: 'Survey',
      round: false,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
    const ListOFUpdateModel(
      name: 'Special Information / Notice',
      round: true,
      imageUrl:
          'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    ),
  ];
}
