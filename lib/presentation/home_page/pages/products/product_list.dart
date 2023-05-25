import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_table/responsive_table.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../state_manager/data_state.dart';
import '../../../../state_manager/init_state.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';

class ProductList extends ConsumerStatefulWidget {
  const ProductList({super.key});

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  final List<int> _perPages = [10, 20, 50, 100];
  int? _currentPerPage = 10;
  int _currentPage = 1;
  List<Map<String, dynamic>> _source = [];
  bool _isLoading = true;
  bool isSearching = false;
  _resetData({start = 0, List<Map<String, dynamic>>? data}) async {
    setState(() => _isLoading = true);
    var expandedLen = data!.length - start < _currentPerPage!
        ? data.length - start
        : _currentPerPage;
    _source.clear();
    _source = data.getRange(start, start + expandedLen).toList();
    setState(() => _isLoading = false);
  }

  _mockPullData() {
    var dataLength = ref.watch(filteredProductsToMapProvider).length;
    setState(() => _isLoading = true);
    _source = dataLength >= _currentPerPage!
        ? ref
            .watch(filteredProductsToMapProvider)
            .getRange(0, _currentPerPage!)
            .toList()
        : ref.watch(filteredProductsToMapProvider).toList();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    //check if widget is build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mockPullData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int total = ref.watch(filteredProductsToMapProvider).length;
    ref.listen(filteredProductsToMapProvider, ((old, current) {
      _resetData(data: current);
    }));
    return ResponsiveDatatable(
      autoHeight: false,
      title: Text(
        "Products",
        style: getCustomTextStyle(context,
            fontWeight: FontWeight.bold, fontSize: 32),
      ),
      onTabRow: (data) {},
      actions: [
        const Spacer(),
        //create search bar if isSearching is true
        if (isSearching || size.width > 900)
          SizedBox(
            width: size.width > 900 ? 700 : 430,
            child: CustomTextFields(
              hintText: "Search user",
              onChanged: (value) {
                ref.read(queryStringProvider.notifier).state = value;
                _resetData(data: ref.watch(filteredUsersToMapProvider));
              },
            ),
          ),
        if (size.width < 900)
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: primaryColor,
              )),
        const SizedBox(
          width: 10,
        ),
        CustomButton(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          onPressed: () => {
            ref
                .read(homePageItemsProvider.notifier)
                .setItem(HomePageItemsList.newProduct)
          },
          icon: Icons.add,
          text: "New Product",
        ),
        const SizedBox(
          width: 10,
        ),
      ],
      headerTextStyle: getCustomTextStyle(context,
          fontSize: 16, fontWeight: FontWeight.w600),
      reponseScreenSizes: const [
        ScreenSize.xs,
        ScreenSize.sm,
        //ScreenSize.md,
        // ScreenSize.lg
      ],
      source: _source,
      isLoading: _isLoading,
      selecteds: const [],
      expanded: const [false],
      footers: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text("Rows per page:"),
        ),
        if (_perPages.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<int>(
              value: _currentPerPage,
              items: _perPages
                  .map((e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text("$e"),
                      ))
                  .toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _currentPerPage = value;
                  _currentPage = 1;
                  _resetData(data: ref.watch(filteredProductsToMapProvider));
                });
              },
              isExpanded: false,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
              "$_currentPage - ${_currentPerPage! + _currentPage - 1} of $total"),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: _currentPage == 1
              ? null
              : () {
                  var nextSet0 = _currentPage - _currentPerPage!;
                  setState(() {
                    _currentPage = nextSet0 > 1 ? nextSet0 : 1;
                    _resetData(
                        start: _currentPage - 1,
                        data: ref.watch(filteredProductsToMapProvider));
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: _currentPage + _currentPerPage! - 1 >= total
              ? null
              : () {
                  var nextSet = _currentPage + _currentPerPage!;

                  setState(() {
                    _currentPage =
                        nextSet < total ? nextSet : total - _currentPerPage!;
                    _resetData(
                        start: nextSet - 1,
                        data: ref.watch(filteredProductsToMapProvider));
                  });
                },
          padding: const EdgeInsets.symmetric(horizontal: 15),
        )
      ],
      headers: [
        DatatableHeader(
          text: "Product Image",
          value: "productImage",
          show: true,
          sortable: false,
          textAlign: TextAlign.center,
          sourceBuilder: (value, row) {
            if (value != null) {
              return Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(File(value)), fit: BoxFit.contain)),
              );
            } else {
              return Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/product.png'),
                        fit: BoxFit.contain)),
              );
            }
          },
        ),
        DatatableHeader(
            text: "Product Code",
            value: "id",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
            text: "Product Name",
            value: "productName",
            show: true,
            sortable: true,
            textAlign: TextAlign.start),
        DatatableHeader(
            text: "SKU",
            value: "sku",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
            text: "In Stock",
            value: "inStock",
            show: true,
            sortable: true,
            textAlign: TextAlign.center),
        DatatableHeader(
          text: "Reorder Point",
          value: "minimumStock",
          show: true,
          sortable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Price per Unit",
          value: "sellingPricePerUnit",
          show: true,
          sortable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
          text: "Total Sales",
          value: "sellingPricePerUnit",
          show: true,
          sortable: true,
          textAlign: TextAlign.center,
        ),
        DatatableHeader(
            text: "Action",
            value: "id",
            show: true,
            sortable: false,
            textAlign: TextAlign.center,
            sourceBuilder: (value, row) {
              return const Row(
                  mainAxisAlignment: MainAxisAlignment.center, children: []);
            }),
      ],
    );
  }
}
