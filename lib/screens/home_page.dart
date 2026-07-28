import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/dummy_products.dart';
import '../widgets/product_card.dart';
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
      MaterialPageRoute(builder: (_) => const AddProductPage()),
    );
    if (newProduct != null) {
      setState(() => _products.add(newProduct));
    }
  }

  void _goToFavorite() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritePage(
          products: _products,
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _goToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(
          product: product,
          onFavoriteToggle: _toggleFavorite,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Produk'),
        actions: [
          IconButton(
            onPressed: _goToFavorite,
            icon: const Icon(Icons.favorite),
            tooltip: 'Produk Favorit',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                isDense: true,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _goToDetail(product),
                        onFavoriteToggle: () => _toggleFavorite(product),
                      );
                    },
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
