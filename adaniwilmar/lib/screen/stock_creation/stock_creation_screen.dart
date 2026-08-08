import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/constant.dart';
import '../../models/stock_sku_model.dart';
import '../../models/stock_item.dart';
import '../../widget/widget.dart';
import 'bloc/bloc.dart';

class StockCreationScreen extends StatelessWidget {
  const StockCreationScreen({Key? key}) : super(key: key);
  static const String routeName = '/stock_creation';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const StockCreationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StockCreationBloc()..add(LoadProducts()),
      child: const StockCreationScreenView(),
    );
  }
}

class StockCreationScreenView extends StatefulWidget {
  const StockCreationScreenView({Key? key}) : super(key: key);

  @override
  State<StockCreationScreenView> createState() =>
      _StockCreationScreenViewState();
}

class _StockCreationScreenViewState extends State<StockCreationScreenView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<StockCreationBloc, StockCreationState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    state.successMessage ?? "Stock submitted successfully")),
          );
          Navigator.pop(context, true);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: const CustomAppBar(title: "Stock Creation", backArrow: true),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Constant.pricbuttonColor,
            onPressed: () => _showAddStockDialog(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Stack(
            children: [
              Positioned(
                child: Container(
                  child: Constant.bgImgGlobal,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 60, left: 8, right: 8, bottom: 80),
                child: CurveBorderBox(
                  boxLRPadding: 0.0,
                  boxTOPPadding: 0.0,
                  boxofWidget: Column(
                    children: [
                      Expanded(
                        child:
                            BlocBuilder<StockCreationBloc, StockCreationState>(
                          builder: (context, state) {
                            if (state.isLoading && state.stockItems.isEmpty) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (state.stockItems.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No stock items added yet.\nTap + to add items.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
                              itemCount: state.stockItems.length,
                              itemBuilder: (context, index) {
                                final item = state.stockItems[index];
                                return CurveOuterBox(
                                  boxLRPadding: 0,
                                  boxTBPadding: 16,
                                  boxofWidget: InkWell(
                                    onTap: () => _showAddStockDialog(context,
                                        item: item, index: index),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 3,
                                          height: 22,
                                          color: Constant.callToCcolor1,
                                          margin:
                                              const EdgeInsets.only(left: 0),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.product.name ??
                                                    "Unknown Product",
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Quantity: ${item.quantity}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red, size: 20),
                                          onPressed: () {
                                            context
                                                .read<StockCreationBloc>()
                                                .add(RemoveStockItem(index));
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 86, // Leave space for FAB
                child: BlocBuilder<StockCreationBloc, StockCreationState>(
                  builder: (context, state) {
                    if (state.stockItems.isEmpty) return const SizedBox();
                    return CommonButton(
                      buttonName: "Submit Stock",
                      buttonFunction: () {
                        context
                            .read<StockCreationBloc>()
                            .add(SubmitStockList());
                      },
                      buttonColor: Constant.pricbuttonColor,
                      buttonNameColor: Colors.white,
                      buttonHeight: Constant.pricbuttonHeight,
                      buttonRadiusTL: Constant.pricbuttonRadiusTL,
                      buttonRadiusBL: Constant.pricbutRadiusBL,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddStockDialog(BuildContext context,
      {StockItem? item, int? index}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: BlocProvider.of<StockCreationBloc>(context),
          child: AddStockDialog(item: item, index: index),
        );
      },
    );
  }
}

class AddStockDialog extends StatefulWidget {
  final StockItem? item;
  final int? index;

  const AddStockDialog({Key? key, this.item, this.index}) : super(key: key);

  @override
  State<AddStockDialog> createState() => _AddStockDialogState();
}

class _AddStockDialogState extends State<AddStockDialog> {
  final _formKey = GlobalKey<FormState>();
  StockSku? _selectedProduct;
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _selectedProduct = widget.item!.product;
      _quantityController.text = widget.item!.quantity.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(25.0),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: Constant.colorOrange,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(5.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.item == null ? "Add Stock Item" : "Edit Stock Item",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              BlocBuilder<StockCreationBloc, StockCreationState>(
                builder: (context, state) {
                  return Autocomplete<StockSku>(
                    displayStringForOption: (StockSku option) =>
                        option.name ?? "",
                    initialValue: TextEditingValue(
                      text: _selectedProduct?.name ?? "",
                    ),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return state.products;
                      }

                      return state.products.where((item) => (item.name ?? "")
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (StockSku selection) {
                      setState(() {
                        _selectedProduct = selection;
                      });
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController controller,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: "Select Product",
                          hintText: "Search Product",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      );
                    },
                    optionsViewBuilder: (
                      BuildContext context,
                      AutocompleteOnSelected<StockSku> onSelected,
                      Iterable<StockSku> options,
                    ) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            constraints: const BoxConstraints(maxHeight: 250),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                final item = options.elementAt(index);

                                return ListTile(
                                  title: Text(
                                    item.name ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => onSelected(item),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );

                  /* return SearchAnchor(
                    builder: (BuildContext context, SearchController controller) {
                      return SearchBar(
                        controller: controller,
                        hintText: 'Select Product',
                        trailing: const [Icon(Icons.arrow_drop_down)],
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                      );
                    },
                    suggestionsBuilder: (context, controller) {
                      final filtered = state.products.where((product) {
                        return (product.name ?? "")
                            .toLowerCase()
                            .contains(controller.text.toLowerCase());
                      });

                      return filtered.map((product) {
                        return ListTile(
                          title: Text(product.name ?? ""),
                          onTap: () {
                            setState(() {
                              _selectedProduct = product;
                            });

                            controller.closeView(product.name ?? "");
                          },
                        );
                      }).toList();
                    },
                  );*/

                  /* return CommonDropdownButtonFormField<StockSku>(
                    label: "Select Product",
                    value: _selectedProduct,
                    onChanged: (StockSku? newValue) {
                      setState(() {
                        _selectedProduct = newValue;
                      });
                    },
                    items: state.products.map<DropdownMenuItem<StockSku>>((value) {
                      return DropdownMenuItem<StockSku>(
                        value: value,
                        child: Text(value.name ?? "", overflow: TextOverflow.visible),
                      );
                    }).toList(),
                  );*/
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter quantity";
                  }
                  final qty = double.tryParse(value);
                  if (qty == null || qty <= 0) {
                    return "Quantity must be greater than zero";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: CommonButton(
                buttonName: "Cancel",
                buttonFunction: () => Navigator.pop(context),
                buttonColor: Colors.white,
                buttonNameColor: Colors.grey,
                buttonBorder: Colors.grey,
                buttonHeight: Constant.pricbuttonHeight,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: CommonButton(
                buttonName: widget.item == null ? "Add" : "Update",
                buttonFunction: () {
                  final formState = _formKey.currentState;
                  if (formState != null &&
                      formState.validate() &&
                      _selectedProduct != null) {
                    final item = StockItem(
                      product: _selectedProduct!,
                      quantity:
                          double.tryParse(_quantityController.text) ?? 0.0,
                    );
                    if (widget.item == null) {
                      context.read<StockCreationBloc>().add(AddStockItem(item));
                    } else if (widget.index != null) {
                      context
                          .read<StockCreationBloc>()
                          .add(UpdateStockItem(widget.index!, item));
                    }
                    Navigator.pop(context);
                  } else if (_selectedProduct == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a product")),
                    );
                  }
                },
                buttonColor: Constant.pricbuttonColor,
                buttonNameColor: Colors.white,
                buttonHeight: Constant.pricbuttonHeight,
                buttonRadiusTL: Constant.pricbuttonRadiusTL,
                buttonRadiusBL: Constant.pricbutRadiusBL,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
