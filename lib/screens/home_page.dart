import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_products.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';
import 'detail_page.dart';
import 'add_product_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> _products = generateDummyProducts();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  List<String> get _categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['Semua', ...cats];
  }

  List<Product> get _filteredProducts {
    return _products.where((p) {
      final matchSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory = _selectedCategory == 'Semua' || p.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final favoriteCount = _products.where((p) => p.isFavorite).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header gradient ungu, mirip hero section pada dashboard referensi.
          GradientHeader(
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Katalog Produk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Temukan produk favoritmu',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    Material(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _goToFavorite,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(Icons.favorite, color: Colors.white, size: 22),
                              if (favoriteCount > 0)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: AppColors.favorite,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                    child: Text(
                                      '$favoriteCount',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Search bar mengambang di atas header (overlap), senada dengan
          // kartu saldo yang menumpuk di atas header pada referensi.
          Transform.translate(
            offset: const Offset(0, -28),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 6,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -16),
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade200),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -8),
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      key: ValueKey('$_selectedCategory-$_searchQuery'),
                      padding: const EdgeInsets.only(top: 4, bottom: 90),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return StaggeredFadeIn(
                          index: index,
                          child: ProductCard(
                            product: product,
                            onTap: () => _goToDetail(product),
                            onFavoriteToggle: () => _toggleFavorite(product),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Produk tidak ditemukan',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}