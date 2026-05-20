import 'cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'items': items.map((e) => e.toMap()).toList(),
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'total': total,
      'placedAt': Timestamp.fromDate(placedAt),
      'status': status,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      orderId: id,
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      shippingAddress: map['shippingAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      shippingCost: (map['shippingCost'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      placedAt: (map['placedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: map['status'] ?? 'Confirmed',
    );
  }
}
