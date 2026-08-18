import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';

/// Galeri gambar produk yang otomatis geser sendiri (auto-slide),
/// dengan jeda MINIMAL 1.5 detik antar gambar, dan bisa juga digeser
/// manual oleh user (nanti timer akan lanjut lagi otomatis).
class AutoSlideGallery extends StatefulWidget {
  final List<String> imagePaths;
  final double height;
  final Duration interval;
  final String heroTag;

  const AutoSlideGallery({
    super.key,
    required this.imagePaths,
    this.height = 260,
    this.interval = const Duration(milliseconds: 2000), // <- 1.5 detik
    required this.heroTag,
  });

  @override
  State<AutoSlideGallery> createState() => _AutoSlideGalleryState();
}

class _AutoSlideGalleryState extends State<AutoSlideGallery> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    // Kalau gambar cuma 1 atau kosong, tidak perlu auto-slide.
    if (widget.imagePaths.length <= 1) return;

    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || !_controller.hasClients) return;

      final isLast = _currentIndex == widget.imagePaths.length - 1;
      final nextIndex = isLast ? 0 : _currentIndex + 1;

      _controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // WAJIB: hentikan timer saat halaman ditutup
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imagePaths;

    if (images.isEmpty) {
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.shopping_bag_outlined, size: 56, color: AppColors.primary),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: Hero(
            tag: widget.heroTag,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  return Container(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    child: ProductImage(
                      path: images[index],
                      fit: BoxFit.contain,
                      placeholderIcon: Icons.image_not_supported,
                      placeholderIconSize: 56,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 10),
          // Dot indicator kecil di bawah gambar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}