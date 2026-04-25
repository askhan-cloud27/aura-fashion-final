class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final bool isNew;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    this.sizes = const [],
    this.colors = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.isNew = false,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercent =>
      hasDiscount ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  ProductModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    List<String>? sizes,
    List<String>? colors,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    bool? isNew,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isNew: isNew ?? this.isNew,
    );
  }
}

// Product Categories
class ProductCategory {
  static const String mens = 'mens';
  static const String womens = 'womens';
  static const String shoes = 'shoes';
  static const String all = 'all';
}

// Sample Data
class SampleProducts {
  static final List<ProductModel> mens = [
    const ProductModel(
      id: 'm1',
      name: 'The Boston Tee',
      brand: 'AURA',
      description: 'A cream-colored, drop-shoulder graphic tee featuring "The Boston" in script across the chest and additional block text near the bottom hem. It\'s a classic streetwear staple.',
      price: 250.00,
      imageUrl: 'assets/images/products/mens/image 1.jpg',
      category: ProductCategory.mens,
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.5,
      reviewCount: 128,
    ),
    const ProductModel(
      id: 'm2',
      name: 'Lorenzo Outfit',
      brand: 'AURA',
      description: 'Elegant Lorenzo style outfit.',
      price: 125.00,
      imageUrl: 'assets/images/products/mens/image 2 (2).jpg',
      category: ProductCategory.mens,
      sizes: ['S', 'M', 'L'],
      rating: 4.8,
      reviewCount: 95,
      isNew: true,
    ),
    const ProductModel(
      id: 'm3',
      name: 'Loofy Casual',
      brand: 'AURA',
      description: 'Comfortable loofy casual wear.',
      price: 100.00,
      imageUrl: 'assets/images/products/mens/image 3.jpg',
      category: ProductCategory.mens,
      sizes: ['M', 'L', 'XL'],
      rating: 4.2,
      reviewCount: 89,
    ),
    const ProductModel(
      id: 'm4',
      name: 'Men Printed shirt',
      brand: 'AURA',
      description: 'Bold printed shirt.',
      price: 275.00,
      imageUrl: 'assets/images/products/mens/image 4.jpg',
      category: ProductCategory.mens,
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.7,
      reviewCount: 214,
      isNew: true,
    ),
  ];

  static final List<ProductModel> womens = [
    const ProductModel(
      id: 'w1',
      name: 'Gharara Set',
      brand: 'AURA',
      description: 'Traditional Gharara set.',
      price: 350.00,
      imageUrl: 'assets/images/products/womens/dress 1.jpg',
      category: ProductCategory.womens,
      sizes: ['S', 'M', 'L'],
      rating: 4.9,
      reviewCount: 412,
      isNew: true,
    ),
    const ProductModel(
      id: 'w2',
      name: 'Co-ord Short Set',
      brand: 'AURA',
      description: 'Stylish co-ord short set.',
      price: 200.00,
      imageUrl: 'assets/images/products/womens/dress 2.jpg',
      category: ProductCategory.womens,
      sizes: ['XS', 'S', 'M', 'L'],
      rating: 4.8,
      reviewCount: 302,
    ),
    const ProductModel(
      id: 'w3',
      name: 'Western Fusion',
      brand: 'AURA',
      description: 'This outfit mixes styles by pairing a white off-the-shoulder crop top and denim shorts with a heavily patterned red dupatta draped over one side to mimic a saree\'s flow.',
      price: 420.00,
      imageUrl: 'assets/images/products/womens/dress 3.jpg',
      category: ProductCategory.womens,
      sizes: ['S', 'M', 'L', 'XL'],
      rating: 4.6,
      reviewCount: 175,
      isNew: true,
    ),
    const ProductModel(
      id: 'w4',
      name: 'Trendy Frock',
      brand: 'AURA',
      description: 'Stylish trendy frock.',
      price: 410.00,
      imageUrl: 'assets/images/cart/cart 2.jpg',
      category: ProductCategory.womens,
      sizes: ['S', 'M', 'L'],
      rating: 4.5,
      reviewCount: 156,
    ),
  ];

  static final List<ProductModel> shoes = [
    const ProductModel(
      id: 's1',
      name: 'Drune Hgh keel',
      brand: 'AURA',
      description: 'Elegant high heel shoes for special occasions.',
      price: 200.00,
      imageUrl: 'assets/images/products/shoes/show 1.jpg',
      category: ProductCategory.shoes,
      sizes: ['37', '38', '39', '40'],
      rating: 4.8,
      reviewCount: 210,
    ),
    const ProductModel(
      id: 's2',
      name: 'Man Strap Loafers',
      brand: 'AURA',
      description: 'Premium strap loafers for the discerning gentleman.',
      price: 750.00,
      imageUrl: 'assets/images/products/shoes/shoe 2.jpg',
      category: ProductCategory.shoes,
      sizes: ['39', '40', '41', '42', '43'],
      rating: 4.5,
      reviewCount: 132,
    ),
    const ProductModel(
      id: 's3',
      name: 'Patent Leather Loafer',
      brand: 'AURA',
      description: 'These are black patent leather shoes featuring two side buckles and a prominent gold-thread embroidered crest (lion motif) on the toe box.',
      price: 480.00,
      originalPrice: 600.00,
      imageUrl: 'assets/images/products/shoes/shoe 3.jpg',
      category: ProductCategory.shoes,
      sizes: ['39', '40', '41', '42'],
      rating: 4.4,
      reviewCount: 267,
    ),
    const ProductModel(
      id: 's4',
      name: 'Sparkling Stiletto',
      brand: 'AURA',
      description: 'Blue sparkling stilettos to steal the show.',
      price: 620.00,
      imageUrl: 'assets/images/products/shoes/shoe 4.jpg',
      category: ProductCategory.shoes,
      sizes: ['36', '37', '38', '39'],
      rating: 4.6,
      reviewCount: 94,
    ),
  ];

  static List<ProductModel> get all => [...mens, ...womens, ...shoes];
}
