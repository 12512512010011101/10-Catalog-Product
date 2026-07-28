import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
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
      appBar: AppBar(title: const Text('Produk Favorit')),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada produk favorit',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          product: product,
                          onFavoriteToggle: _toggleFavorite,
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  onFavoriteToggle: () => _toggleFavorite(product),
                );
              },
            ),
    );
  }
}