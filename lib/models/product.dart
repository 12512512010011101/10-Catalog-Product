// Model data untuk satu produk.
// Sekarang mendukung LEBIH DARI SATU gambar (imagePaths), supaya bisa
// ditampilkan sebagai slideshow/carousel otomatis di halaman detail.
// Juga menambahkan field `description` supaya tiap produk bisa punya
// deskripsi singkat yang ditampilkan di halaman detail.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String description;
  final List<String> imagePaths; // <- ganti dari imagePath tunggal jadi list
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.description = '',
    List<String>? imagePaths,
    String imagePath = '', // tetap diterima untuk kompatibilitas kode lama
    this.isFavorite = false,
  }) : imagePaths = imagePaths ?? (imagePath.isNotEmpty ? [imagePath] : []);

  /// Getter bantu: gambar pertama saja (dipakai di list/card kecil
  /// yang cuma butuh satu thumbnail, tidak perlu slideshow).
  String get imagePath => imagePaths.isNotEmpty ? imagePaths.first : '';
}