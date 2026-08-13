import 'dart:convert';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget gambar produk yang otomatis mendeteksi sumber gambarnya:
/// - Kalau path diawali "http://" atau "https://" -> dianggap gambar dari
///   URL internet, dirender pakai Image.network.
/// - Kalau path diawali "data:image" -> dianggap gambar lokal yang dipilih
///   dari galeri (disimpan sebagai base64), dirender pakai Image.memory.
///   Ini dipakai supaya foto dari galeri tetap tampil normal di semua
///   platform (termasuk Flutter Web, yang tidak bisa akses File System biasa
///   dan juga tidak kena masalah CORS seperti gambar dari URL luar).
/// - Selain itu -> dianggap asset lokal (bawaan aplikasi), pakai Image.asset.
///
/// Dibuat sebagai satu widget terpisah supaya logic deteksi network vs
/// lokal vs asset cuma perlu ditulis sekali, lalu dipakai ulang di
/// ProductCard, grid Home, dan galeri di DetailPage.
class ProductImage extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final IconData placeholderIcon;
  final double placeholderIconSize;

  const ProductImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.image_not_supported_outlined,
    this.placeholderIconSize = 28,
  });

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');
  bool get _isLocalDataUri => path.startsWith('data:image');

  Widget _placeholder() {
    return Icon(placeholderIcon, color: AppColors.primary, size: placeholderIconSize);
  }

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return _placeholder();

    if (_isLocalDataUri) {
      try {
        // Format: "data:image/jpeg;base64,xxxxx" -> ambil bagian setelah koma.
        final base64Str = path.substring(path.indexOf(',') + 1);
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      } catch (_) {
        return _placeholder();
      }
    }

    if (_isNetwork) {
      return Image.network(
        path,
        fit: fit,
        // Loading indicator kecil selagi gambar dari internet masih diunduh.
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        // Kalau URL salah/rusak/tidak bisa diakses, tampilkan placeholder,
        // bukan crash atau layar merah.
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }
}