import 'package:flutter/material.dart';
import '../widgets/auto_slide_gallery.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientHeader(
              height: 230,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 56),
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
                    'Detail Produk',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -70),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar produk mengambang di atas header, mirip kartu
                    // rumah sakit yang menumpuk di atas gradient pada referensi.
                    AutoSlideGallery(
                      imagePaths: product.imagePaths,
                      height: 220,
                      heroTag: 'product-image-${product.id}',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: AppColors.textDark),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.category,
                            style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Kartu info harga & stok, gaya "e-card" ringkas.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Harga', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const SizedBox(height: 2),
                              Text(
                                _formatPrice(product.price),
                                style: const TextStyle(fontSize: 19, color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(width: 1, height: 34, color: Colors.grey.shade200),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Stok tersedia', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const SizedBox(height: 2),
                              Text(
                                '${product.stock} unit',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => widget.onFavoriteToggle(product));
                        },
                        icon: TweenAnimationBuilder<double>(
                          key: ValueKey(product.isFavorite),
                          tween: Tween(begin: 0.4, end: 1.0),
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.elasticOut,
                          builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                          child: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                        ),
                        label: Text(product.isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: product.isFavorite ? AppColors.favorite : AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}