import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_products.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';
import 'add_product_page.dart';
import 'favorite_page.dart';

enum _SortOption { defaultOrder, priceLowHigh, priceHighLow, stockHighLow, nameAZ }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> _products = generateDummyProducts();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  _SortOption _sortOption = _SortOption.defaultOrder;

  final String _userName = 'Riyad';

  // Warna aksen hijau khusus untuk tombol promo, terinspirasi dari
  // referensi "Shop Now". Dipisah dari AppColors karena cuma dipakai
  // di satu tempat (kartu promo), bukan warna tema utama app.
  static const Color _promoAccent = Color(0xFF35D07F);

  List<String> get _categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['Semua', ...cats];
  }

  int _countFor(String category) {
    if (category == 'Semua') return _products.length;
    return _products.where((p) => p.category == category).length;
  }

  // Filter dulu berdasarkan pencarian & kategori, baru diurutkan
  // sesuai _sortOption yang dipilih lewat ikon filter.
  List<Product> get _filteredProducts {
    final result = _products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory = _selectedCategory == 'Semua' || p.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    switch (_sortOption) {
      case _SortOption.priceLowHigh:
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortOption.priceHighLow:
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortOption.stockHighLow:
        result.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case _SortOption.nameAZ:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case _SortOption.defaultOrder:
        break;
    }
    return result;
  }

  void _toggleFavorite(Product product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });
  }

  Future<void> _goToAddProduct() async {
    final newProduct = await Navigator.push<Product>(
      context,
      fadeSlideRoute(const AddProductPage()),
    );
    if (newProduct != null) {
      setState(() => _products.add(newProduct));
    }
  }

  void _goToFavorite() {
    Navigator.push(
      context,
      fadeSlideRoute(
        FavoritePage(
          products: _products,
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _goToDetail(Product product) {
    Navigator.push(
      context,
      fadeSlideRoute(
        DetailPage(
          product: product,
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  String _formatPrice(double price) {
    final str = price.toStringAsFixed(0);
    final withDots = str.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp$withDots';
  }

  // Dulu ikon ini cuma mindahin fokus ke bar pencarian di bawah.
  // Sekarang bar itu dihapus, jadi pencarian dipindah ke dialog kecil
  // yang muncul saat ikon kaca pembesar ditekan — hasil ketikan tetap
  // langsung memfilter grid produk lewat _searchQuery seperti biasa.
  void _openSearchDialog() {
    final controller = TextEditingController(text: _searchQuery);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Cari produk'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Ketik nama produk...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
            onSubmitted: (_) => Navigator.pop(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.clear();
                setState(() => _searchQuery = '');
              },
              child: const Text('Hapus'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  // Bottom sheet berisi pilihan urutan: harga, stok, nama.
  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Text('Urutkan berdasarkan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                _sortTile('Default', _SortOption.defaultOrder, Icons.sort),
                _sortTile('Harga: rendah ke tinggi', _SortOption.priceLowHigh, Icons.arrow_upward),
                _sortTile('Harga: tinggi ke rendah', _SortOption.priceHighLow, Icons.arrow_downward),
                _sortTile('Stok terbanyak', _SortOption.stockHighLow, Icons.inventory_2_outlined),
                _sortTile('Nama A-Z', _SortOption.nameAZ, Icons.sort_by_alpha),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sortTile(String label, _SortOption option, IconData icon) {
    final isSelected = _sortOption == option;
    return ListTile(
      leading: Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textMuted),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.textDark : AppColors.textMuted,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary, size: 18) : null,
      onTap: () {
        setState(() => _sortOption = option);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final favoriteCount = _products.where((p) => p.isFavorite).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Header: avatar + sapaan + tombol aksi ----
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            _userName.isNotEmpty ? _userName[0] : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey $_userName 👋',
                                style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                              ),
                              const Text(
                                'Welcome back!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _circleIconButton(
                          icon: Icons.favorite_border,
                          onTap: _goToFavorite,
                          badgeCount: favoriteCount,
                        ),
                        const SizedBox(width: 8),
                        _circleIconButton(
                          icon: Icons.add_shopping_cart_outlined,
                          onTap: _goToAddProduct,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ---- Kartu promo ----
                    // Ditambahkan sesuai referensi (kartu gelap "Super Sale").
                    // Murni dekoratif/informatif dulu -- tombol "Belanja
                    // Sekarang" belum diarahkan ke fitur checkout karena
                    // project ini belum punya halaman itu.
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Stack(
                        children: [
                          // Lingkaran-lingkaran tipis di kanan, meniru motif
                          // radiating circles pada referensi.
                          Positioned(
                            right: -30,
                            top: -30,
                            child: _decorativeRing(140),
                          ),
                          Positioned(
                            right: -10,
                            bottom: -40,
                            child: _decorativeRing(90),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Promo Spesial',
                                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Diskon hingga 50%',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _openSortSheet,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _promoAccent,
                                  foregroundColor: AppColors.primaryDark,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                                child: const Text('Belanja Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---- Baris: ikon cari, ikon filter, lalu tab kategori ----
                    Row(
                      children: [
                        _circleIconButton(icon: Icons.search, onTap: _openSearchDialog, size: 34, filled: true),
                        const SizedBox(width: 8),
                        _circleIconButton(icon: Icons.tune, onTap: _openSortSheet, size: 34, filled: true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected = cat == _selectedCategory;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedCategory = cat),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: cat,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: isSelected ? AppColors.textDark : Colors.grey.shade400,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              ),
                                            ),
                                            WidgetSpan(
                                              alignment: PlaceholderAlignment.top,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 2),
                                                child: Text(
                                                  '${_countFor(cat)}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: isSelected ? AppColors.textDark : Colors.grey.shade400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      if (isSelected)
                                        Container(width: 18, height: 2, color: AppColors.textDark),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // ---- Grid produk, 2 kolom ----
                    filtered.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            padding: const EdgeInsets.only(bottom: 100),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.72,
                            ),
                            itemBuilder: (context, index) {
                              final product = filtered[index];
                              return _ProductGridItem(
                                product: product,
                                priceLabel: _formatPrice(product.price),
                                onTap: () => _goToDetail(product),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // filled: true -> lingkaran hitam pekat + ikon putih (kontras tinggi,
  // dipakai untuk ikon cari & filter). filled: false (default) -> gaya
  // lama, lingkaran putih + border tipis (dipakai untuk heart & cart).
  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    int badgeCount = 0,
    double size = 40,
    bool filled = false,
  }) {
    return Material(
      color: filled ? AppColors.primary : Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: filled ? null : Border.all(color: Colors.grey.shade200),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(icon, size: size <= 34 ? 16 : 18, color: filled ? Colors.white : AppColors.textDark),
              if (badgeCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: AppColors.favorite, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                    child: Text(
                      '$badgeCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Satu lingkaran outline tipis, dipakai berlapis-lapis sebagai hiasan
  // di kartu promo (meniru motif "radiating circles" pada referensi).
  Widget _decorativeRing(double diameter) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 10),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Produk tidak ditemukan', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// Satu kartu produk pada grid 2 kolom, mengikuti gaya foto besar + nama +
// harga seperti pada referensi ("Sherpa Jacket / $23").
class _ProductGridItem extends StatelessWidget {
  final Product product;
  final String priceLabel;
  final VoidCallback onTap;

  const _ProductGridItem({
    required this.product,
    required this.priceLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Hero(
                tag: 'product-image-${product.id}',
                child: Container(
                  width: double.infinity,
                  color: AppColors.primary.withValues(alpha: 0.06),
                  child: product.imagePath.isNotEmpty
                      ? Image.asset(
                          product.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.checkroom, color: AppColors.textMuted, size: 34),
                        )
                      : const Icon(Icons.checkroom, color: AppColors.textMuted, size: 34),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.category,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                priceLabel,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}