import 'package:flutter/material.dart';
import '../models/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final void Function(Product) onFavoriteToggle;

  const DetailPage({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: product.imagePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(product.category, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            const SizedBox(height: 12),
            Text(
              _formatPrice(product.price),
              style: const TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Stok tersedia: ${product.stock}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() => widget.onFavoriteToggle(product));
                },
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(product.isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.isFavorite ? Colors.red : Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}