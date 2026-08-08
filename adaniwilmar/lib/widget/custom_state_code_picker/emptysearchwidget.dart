import 'package:flutter/material.dart';

class EmptySearchWidget extends StatefulWidget {
  const EmptySearchWidget({Key? key}) : super(key: key);

  @override
  State<EmptySearchWidget> createState() => _EmptySearchWidgetState();
}

class _EmptySearchWidgetState extends State<EmptySearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("No data found")),
    );
  }
}
