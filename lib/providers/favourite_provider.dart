import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<ProductModel> _favourites = [];
  bool _isLoading = false;

  List<ProductModel> get favourites => List.unmodifiable(_favourites);
  int get count => _favourites.length;
  bool get isLoading => _isLoading;

  bool isFavourite(String productId) =>
      _favourites.any((p) => p.id == productId);

  void _syncWithFirebase() {
    final ids = _favourites.map((p) => p.id).toList();
    FirestoreService().syncWishlist(ids);
  }

  /// Initial load of favourites from Firestore
  Future<void> loadFavourites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final ids = await FirestoreService().getWishlistIds();
      if (ids.isNotEmpty) {
        final products = await FirestoreService().getProductsByIds(ids);
        _favourites.clear();
        _favourites.addAll(products);
      }
    } catch (e) {
      debugPrint('Error loading favourites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggle(ProductModel product) {
    final index = _favourites.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favourites.removeAt(index);
    } else {
      _favourites.add(product);
    }
    notifyListeners();
    _syncWithFirebase();
  }

  void remove(String productId) {
    _favourites.removeWhere((p) => p.id == productId);
    notifyListeners();
    _syncWithFirebase();
  }

  void clear() {
    _favourites.clear();
    notifyListeners();
    _syncWithFirebase();
  }
}
