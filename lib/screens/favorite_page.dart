import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) onFavoriteToggle;

  const FavoritePage({
    super.key,
    required this.products,
    required this.onFavoriteToggle,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  void _toggleFavorite(Product product) {
    setState(() => widget.onFavoriteToggle(product));
  }

  @override
  Widget build(BuildContext context) {
    final favorites = widget.products.where((p) => p.isFavorite).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHeader(
            height: 130,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Material(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Produk Favorit',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada produk favorit',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return StaggeredFadeIn(
                        index: index,
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              fadeSlideRoute(
                                DetailPage(
                                  product: product,
                                  onFavoriteToggle: _toggleFavorite,
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          onFavoriteToggle: () => _toggleFavorite(product),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}