import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- ORDERS ---

  /// Place a new order
  Future<void> placeOrder(OrderModel order) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .add(order.toMap());
  }

  /// Get user's order history
  Stream<List<OrderModel>> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('placedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // --- REVIEWS ---

  /// Add a review to a product and update its aggregate rating
  Future<void> addReview(String productId, Map<String, dynamic> reviewData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final reviewRef = _db.collection('products').doc(productId).collection('reviews').doc();
    final productRef = _db.collection('products').doc(productId);

    await _db.runTransaction((transaction) async {
      final productSnapshot = await transaction.get(productRef);
      if (!productSnapshot.exists) return;

      final productData = productSnapshot.data()!;
      final double currentRating = (productData['rating'] ?? 0.0).toDouble();
      final int currentReviewCount = productData['reviewCount'] ?? 0;

      final double newRatingValue = reviewData['rating'] ?? 0.0;
      final int newReviewCount = currentReviewCount + 1;
      final double newRating = ((currentRating * currentReviewCount) + newRatingValue) / newReviewCount;

      transaction.set(reviewRef, {
        ...reviewData,
        'userId': user.uid,
        'userName': user.displayName ?? 'Anonymous',
        'createdAt': FieldValue.serverTimestamp(),
      });

      transaction.update(productRef, {
        'rating': newRating,
        'reviewCount': newReviewCount,
      });
    });
  }

  /// Get reviews for a product
  Stream<QuerySnapshot> getReviews(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // --- PRODUCTS ---

  /// Get all products from a specific category
  Stream<List<ProductModel>> getProducts(String category) {
    Query query = _db.collection('products');
    
    if (category != ProductCategory.all) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Get multiple products by their IDs
  Future<List<ProductModel>> getProductsByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final snapshot = await _db
        .collection('products')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  /// Get new arrivals
  Stream<List<ProductModel>> getNewArrivals() {
    return _db
        .collection('products')
        .where('isNew', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // --- USER CART & FAVOURITES ---

  /// Sync cart items to Firebase (call when user is logged in)
  Future<void> syncCart(List<Map<String, dynamic>> cartItems) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'cart': cartItems,
      'lastSync': FieldValue.serverTimestamp(),
    });
  }

  /// Sync wishlist items to Firebase
  Future<void> syncWishlist(List<String> productIds) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'wishlist': productIds,
      'lastSync': FieldValue.serverTimestamp(),
    });
  }

  /// Fetch user's wishlist product IDs
  Future<List<String>> getWishlistIds() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('wishlist')) {
        return List<String>.from(data['wishlist']);
      }
    }
    return [];
  }

  // --- SEEDING (Run once) ---
  
  /// Check if products collection is empty
  Future<bool> isProductsEmpty() async {
    final snapshot = await _db.collection('products').limit(1).get();
    return snapshot.docs.isEmpty;
  }

  /// Upload dummy data to Firestore
  Future<void> seedDatabase() async {
    final productsCount = await _db.collection('products').count().get();
    if (productsCount.count != null && productsCount.count! > 0) {
      debugPrint('Database already has products. Skipping seed.');
      return;
    }

    final products = SampleProducts.all;
    final batch = _db.batch();

    for (var product in products) {
      var docRef = _db.collection('products').doc(); // Auto-generate ID
      batch.set(docRef, product.toMap());
    }

    await batch.commit();
    debugPrint('Database seeded successfully with ${products.length} products.');
  }
}
