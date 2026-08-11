import 'dart:async';
import 'package:flutter/material.dart';

/// Data untuk satu kartu banner (promo, kupon, dsb).
/// Dipisah jadi model biar gampang nambah banner baru tanpa
/// ubah-ubah widget carousel-nya.
class PromoBannerData {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final VoidCallback? onButtonTap;

  const PromoBannerData({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    this.onButtonTap,
  });
}

/// Carousel banner promo yang auto-slide sendiri (mirip [AutoSlideGallery]
/// yang dipakai di halaman detail), tapi isinya kartu promo/kupon,
/// bukan gambar produk.
class PromoBannerCarousel extends StatefulWidget {
  final List<PromoBannerData> banners;
  final double height;
  final Duration interval;

  const PromoBannerCarousel({
    super.key,
    required this.banners,
    this.height = 150,
    this.interval = const Duration(milliseconds: 3500),
  });

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    // Kalau banner cuma 1 atau kosong, tidak perlu auto-slide.
    if (widget.banners.length <= 1) return;

    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || !_controller.hasClients) return;

      final isLast = _currentIndex == widget.banners.length - 1;
      final nextIndex = isLast ? 0 : _currentIndex + 1;

      _controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // WAJIB: hentikan timer saat widget dibuang
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => _BannerCard(data: banners[index]),
          ),
        ),
        if (banners.length > 1) ...[
          const SizedBox(height: 10),
          // Dot indicator kecil di bawah banner
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(banners.length, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive ? banners[_currentIndex].accentColor : Colors.grey.shade300,
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

class _BannerCard extends StatelessWidget {
  final PromoBannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      // Tidak ada lagi motif dekoratif (lingkaran/ikon) di belakang --
      // kartu polos sesuai permintaan, cukup warna solid + teks + tombol.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            data.subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: data.onButtonTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: data.accentColor,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(data.buttonLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
          ),
        ],
      ),
    );
  }
}