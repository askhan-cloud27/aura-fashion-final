import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_strings.dart';
import '../../widgets/product/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String category;
  final String title;
  const ProductListScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  List<ProductModel> get _products {
    List<ProductModel> list;
    switch (widget.category) {
      case ProductCategory.mens:
        list = SampleProducts.mens;
        break;
      case ProductCategory.womens:
        list = SampleProducts.womens;
        break;
      case ProductCategory.shoes:
        list = SampleProducts.shoes;
        break;
      default:
        list = SampleProducts.all;
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = _products;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search Product',
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
                prefixIcon: const Icon(Icons.menu, size: 20, color: Colors.black54),
                suffixIcon: const Icon(Icons.search, size: 20, color: Colors.black54),
                filled: true,
                fillColor: const Color(0xFFFAF9F6),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFEEE3C6), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                ),
              ),
            ),
          ),
          // Grid
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55, // Adjusted to prevent overflow across various devices
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, i) =>
                        ProductCard(product: products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
