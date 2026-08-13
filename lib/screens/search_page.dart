import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'detail_page.dart';

/// Halaman pencarian penuh satu layar (bukan dialog kecil di tengah lagi).
/// Ada tombol back di kiri atas, field pencarian di sebelahnya, dan hasil
/// pencarian langsung tampil sebagai list di bawahnya begitu user mengetik.
class SearchPage extends StatefulWidget {
  final List<Product> products;
  final void Function(Product) onFavoriteToggle;

  const SearchPage({
    super.key,
    required this.products,
    required this.onFavoriteToggle,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> get _results {
    if (_query.trim().isEmpty) return [];
    return widget.products
        .where((p) => p.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void _toggleFavorite(Product product) {
    setState(() => widget.onFavoriteToggle(product));
  }

  void _goToDetail(Product product) {
    Navigator.push(
      context,
      fadeSlideRoute(
        DetailPage(product: product, onFavoriteToggle: widget.onFavoriteToggle),
      ),
    ).then((_) => setState(() {}));
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
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
          child: Icon(icon, size: 18, color: AppColors.textDark),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // Belum ngetik apa-apa -> tampilkan hint, bukan hasil kosong.
    if (_query.trim().isEmpty) {
      return _hint(Icons.search, 'Ketik nama produk yang ingin kamu cari');
    }
    final results = _results;
    if (results.isEmpty) {
      return _hint(Icons.search_off, 'Produk "$_query" tidak ditemukan');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return StaggeredFadeIn(
          index: index,
          child: ProductCard(
            product: product,
            onTap: () => _goToDetail(product),
            onFavoriteToggle: () => _toggleFavorite(product),
          ),
        );
      },
    );
  }

  Widget _hint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  _circleIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: 'Ketik nama produk...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() => _query = '');
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }
}