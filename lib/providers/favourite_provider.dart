import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<ProductModel> _favourites = [];

  List<ProductModel> get favourites => List.unmodifiable(_favourites);
  int get count => _favourites.length;

  bool isFavourite(String productId) =>
      _favourites.any((p) => p.id == productId);

  void toggle(ProductModel product) {
    final index = _favourites.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favourites.removeAt(index);
    } else {
      _favourites.add(product);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _favourites.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
