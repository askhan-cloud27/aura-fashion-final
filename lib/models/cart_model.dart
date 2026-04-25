import 'product_model.dart';

class CartItem {
  final ProductModel product;
  final String selectedSize;
  final String selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.selectedColor = '',
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    ProductModel? product,
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}

class OrderModel {
  final String orderId;
  final List<CartItem> items;
  final String shippingAddress;
  final String paymentMethod;
  final double subtotal;
  final double shippingCost;
  final double total;
  final DateTime placedAt;
  final String status;

  const OrderModel({
    required this.orderId,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.placedAt,
    this.status = 'Confirmed',
  });
}
