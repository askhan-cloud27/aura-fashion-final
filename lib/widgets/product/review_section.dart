import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product_model.dart';
import '../../models/review_model.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants/app_colors.dart';

class ReviewSection extends StatefulWidget {
  final ProductModel product;

  const ReviewSection({super.key, required this.product});

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  void _showAddReviewDialog() {
    double rating = 5.0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Write a Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Rating', style: TextStyle(fontSize: 14)),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setModalState(() => rating = index + 1.0);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts about this product...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        if (commentController.text.trim().isEmpty) return;
                        
                        await FirestoreService().addReview(
                          widget.product.id,
                          {
                            'rating': rating,
                            'comment': commentController.text.trim(),
                            'productId': widget.product.id,
                          },
                        );
                        
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Review submitted successfully!')),
                          );
                        }
                      },
                      child: const Text('SUBMIT REVIEW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildRatingSummary(List<ReviewModel> reviews) {
    final avg = reviews.isEmpty
        ? widget.product.rating
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
    final total = reviews.isEmpty ? widget.product.reviewCount : reviews.length;

    // Count per star
    final counts = List<int>.filled(5, 0);
    for (final r in reviews) {
      final idx = (r.rating.round() - 1).clamp(0, 4);
      counts[idx]++;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5D5B5)),
      ),
      child: Row(
        children: [
          // Big average number
          Column(
            children: [
              Text(
                avg.toStringAsFixed(1),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < avg.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text('$total reviews', style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
          const SizedBox(width: 20),
          // Star breakdown bars
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final starIndex = 4 - i;
                final count = counts[starIndex];
                final fraction = total > 0 ? count / total : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('${starIndex + 1}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, size: 11, color: Colors.amber),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 6,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('$count', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextButton.icon(
              onPressed: _showAddReviewDialog,
              icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
              label: const Text('Write a Review', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getReviews(widget.product.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ));
            }

            final reviews = snapshot.hasData
                ? snapshot.data!.docs
                    .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                    .toList()
                : <ReviewModel>[];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating summary card
                _buildRatingSummary(reviews),
                const SizedBox(height: 16),

                if (reviews.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No reviews yet. Be the first to review!',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primary,
                                      child: Text(
                                        review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'A',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  ],
                                ),
                                // Star rating chips
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withAlpha(30),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 13, color: Colors.amber),
                                      const SizedBox(width: 3),
                                      Text(review.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(review.comment, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
                            const SizedBox(height: 4),
                            Text(
                              '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                              style: const TextStyle(fontSize: 11, color: Colors.black38),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
