import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_nav_page.dart';

/// Halaman pembuka (onboarding) yang tampil sebelum pengguna masuk ke
/// MainNavPage (Home + bottom navigation). Terdiri dari tiga slide yang
/// bisa digeser, memakai foto produk asli dari assets supaya terasa
/// nyambung dengan isi katalognya.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const List<_Slide> _slides = [
    _Slide(
      title: 'Semua koleksi\ndalam satu katalog',
      subtitle:
          'Pakaian, sepatu, sampai aksesoris tersusun rapi\ndan gampang dijelajahi.',
      images: [
        'assets/images/kaos_putih.png',
        'assets/images/sepatu_sneakers.png',
        'assets/images/jam_tangan.png',
      ],
    ),
    _Slide(
      title: 'Cari produk\ntanpa ribet',
      subtitle:
          'Filter kategori dan pencarian cepat bantu kamu\nketemu barang yang pas.',
      images: [
        'assets/images/tas_ransel.png',
        'assets/images/kacamata_hitam.png',
        'assets/images/topi_baseball.png',
      ],
    ),
    _Slide(
      title: 'Simpan yang\nkamu suka',
      subtitle:
          'Tandai produk favorit dan tambahkan koleksimu\nsendiri kapan saja.',
      images: [
        'assets/images/jaket_hoodie.png',
        'assets/images/kemeja_flanel.png',
        'assets/images/sandal_gunung.png',
      ],
    ),
  ];

  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _slides.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(fadeSlideRoute(const MainNavPage()));
  }

  void _next() {
    if (_isLast) {
      _goToHome();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
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
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/icon/logo1.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Katalog Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Spacer(),
                  AnimatedOpacity(
                    opacity: _isLast ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: _isLast ? null : _goToHome,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textMuted,
                      ),
                      child: const Text(
                        'Lewati',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) => _SlideView(slide: _slides[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 20 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _next,
                      child: Text(_isLast ? 'Mulai Jelajahi' : 'Lanjut'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Isi satu slide: kolase foto produk di atas, judul & deskripsi di bawah.
class _SlideView extends StatelessWidget {
  final _Slide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Collage(images: slide.images),
                const SizedBox(height: 32),
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  slide.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Tiga foto produk yang saling tumpang tindih dan sedikit miring, biar
/// terasa seperti tumpukan katalog. Ukurannya ikut lebar layar supaya
/// tetap proporsional di HP kecil maupun layar lebar.
class _Collage extends StatelessWidget {
  final List<String> images;

  const _Collage({required this.images});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 460.0);
    final cardWidth = width * 0.42;
    final cardHeight = cardWidth * 1.25;

    return SizedBox(
      height: cardHeight * 1.28,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(-cardWidth * 0.62, cardHeight * 0.10),
            child: Transform.rotate(
              angle: -0.14,
              child: _photo(images[1], cardWidth * 0.82, cardHeight * 0.82),
            ),
          ),
          Transform.translate(
            offset: Offset(cardWidth * 0.62, cardHeight * 0.10),
            child: Transform.rotate(
              angle: 0.14,
              child: _photo(images[2], cardWidth * 0.82, cardHeight * 0.82),
            ),
          ),
          _photo(images[0], cardWidth, cardHeight),
        ],
      ),
    );
  }

  Widget _photo(String path, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset(path, fit: BoxFit.contain),
      ),
    );
  }
}

class _Slide {
  final String title;
  final String subtitle;
  final List<String> images;

  const _Slide({
    required this.title,
    required this.subtitle,
    required this.images,
  });
}
