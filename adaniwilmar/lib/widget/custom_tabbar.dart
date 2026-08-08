import 'package:flutter/material.dart';

class CustomTabbar extends StatefulWidget {
  const CustomTabbar({Key? key}) : super(key: key);

  @override
  State<CustomTabbar> createState() => _CustomTabbarState();
}

class _CustomTabbarState extends State<CustomTabbar>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    late TabController _tabController;
    _tabController = TabController(vsync: this, length: 2);
    return SizedBox(
      height: 300,
      child: Column(children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "Saudu"), Tab(text: "Sale")]),
        ),
        TabBarView(
            controller: _tabController, children: const [Text("1"), Text("2")]),
      ]),
    );
  }
}
