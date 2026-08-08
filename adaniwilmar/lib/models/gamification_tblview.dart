import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'gamification_model.dart';


class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<ProductCategory> productCategory}) {
    _productCategory = productCategory
        .map<DataGridRow>((productCategory) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'productName', value: productCategory.productName),
      DataGridCell<String>(columnName: 'line1', value: productCategory.line1),
      DataGridCell<String>(columnName: 'l2', value: productCategory.l2),
      DataGridCell<String>(columnName: 'l3', value: productCategory.l3),
      DataGridCell<String>(columnName: 'l3B', value: productCategory.l3B),
      DataGridCell<String>(columnName: 'foodBP', value: productCategory.foodBP),
      DataGridCell<String>(columnName: 'bakery', value: productCategory.bakery),
    ]))
        .toList();
  }

  List<DataGridRow> _productCategory = [];

  @override
  List<DataGridRow> get rows => _productCategory;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
       padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
        alignment: Alignment.centerLeft,
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[4].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[5].value.toString()),
      ),
      Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[6].value.toString()),
      ),
    ]);
  }
}
