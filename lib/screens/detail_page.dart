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

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap, Color? iconColor}) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
          child: Icon(icon, size: 18, color: iconColor ?? AppColors.textDark),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      // Sama seperti home_page: latar putih polos, tanpa header gradient hitam.
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- Baris atas: tombol back + judul ----
              // Sebelumnya ada 2 tombol favorit di halaman ini (ikon kecil
              // di sini + tombol besar "Tambah ke Favorit" di bawah), jadi
              // membingungkan mana yang harus dipakai. Sekarang cuma SATU:
              // tombol besar di bawah dekat harga & stok.
              Row(
                children: [
                  _circleIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detail Produk',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---- Galeri gambar produk ----
              AutoSlideGallery(
                imagePaths: product.imagePaths,
                height: 260,
                heroTag: 'product-image-${product.id}',
              ),
              const SizedBox(height: 20),

              // ---- Nama + kategori ----
              // Badge kategori dibuat abu-abu muda, senada dengan tab
              // kategori di HomePage — bukan hitam seperti sebelumnya.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(color: AppColors.textDark, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ---- Kartu harga & stok ----
              // Sebelumnya pakai boxShadow (efek melayang). Diganti border
              // tipis abu-abu supaya konsisten dengan gaya flat di HomePage.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(18),
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
                          style: const TextStyle(fontSize: 19, color: AppColors.textDark, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 34, color: Colors.grey.shade300),
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
              const SizedBox(height: 20),

              // ---- Deskripsi produk ----
              // Cuma ditampilkan kalau memang diisi, supaya produk lama
              // yang belum punya deskripsi tidak tampil bagian kosong.
              if (product.description.isNotEmpty) ...[
                const Text(
                  'Deskripsi',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted, height: 1.5),
                ),
                const SizedBox(height: 20),
              ],

              // ---- Tombol favorit ----
              // Dulu: full-width, background hitam pekat ("card hitam" yang
              // dikomplain). Sekarang: outline tipis + teks hitam, tombol
              // solid hitam cuma dipakai kalau produk LAGI difavoritkan
              // (state aktif) supaya nggak dominan terus-terusan.
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => widget.onFavoriteToggle(product)),
                  icon: TweenAnimationBuilder<double>(
                    key: ValueKey(product.isFavorite),
                    tween: Tween(begin: 0.4, end: 1.0),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
                    child: Icon(
                      product.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: product.isFavorite ? AppColors.favorite : AppColors.textDark,
                    ),
                  ),
                  label: Text(
                    product.isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                    style: TextStyle(color: product.isFavorite ? AppColors.favorite : AppColors.textDark),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: product.isFavorite ? AppColors.favorite : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}