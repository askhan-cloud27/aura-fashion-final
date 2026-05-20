import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shippingCost => subtotal > 0 ? 115.00 : 0.0;
  double get total => subtotal + shippingCost;

  bool isInCart(String productId) =>
      _items.any((item) => item.product.id == productId);

  void _syncWithFirebase() {
    FirestoreService().syncCart(_items.map((e) => e.toMap()).toList());
  }

  void addItem(ProductModel product, String size, {String color = ''}) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.selectedSize == size,
    );
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
    _syncWithFirebase();
  }

  void removeItem(String productId, String size) {
    _items.removeWhere(
      (item) => item.product.id == productId && item.selectedSize == size,
    );
    notifyListeners();
    _syncWithFirebase();
  }

  void incrementQuantity(String productId, String size) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedSize == size,
    );
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
      _syncWithFirebase();
    }
  }

  void decrementQuantity(String productId, String size) {
    final index = _items.indexWhere(
      (item) => item.product.id == productId && item.selectedSize == size,
    );
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
      _syncWithFirebase();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _syncWithFirebase();
  }
}
