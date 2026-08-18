import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    final withDots = str.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp$withDots';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        elevation: 1.5,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Hero(
                    tag: 'product-image-${product.id}',
                    child: Container(
                      width: 56,
                      height: 56,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: ProductImage(
                        path: product.imagePath,
                        fit: BoxFit.contain,
                        placeholderIcon: Icons.shopping_bag_outlined,
                        placeholderIconSize: 26,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${product.category} · Stok ${product.stock}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatPrice(product.price),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: onFavoriteToggle,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(product.isFavorite),
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                          child: Icon(
                            product.isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: product.isFavorite ? AppColors.favorite : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}