// Model data untuk satu produk.
// Dibuat sebagai class biasa (bukan immutable) supaya gampang di-update
// field isFavorite-nya langsung tanpa perlu bikin objek baru.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String imagePath;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imagePath = '',
    this.isFavorite = false,
  });
}