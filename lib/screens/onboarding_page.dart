import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'main_nav_page.dart';

/// Halaman pembuka (splash/onboarding) yang tampil sekali sebelum
/// pengguna masuk ke MainNavPage (Home + bottom navigation). Mengikuti
/// tema hitam-putih project ini (lihat AppColors di theme/app_theme.dart).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  // Ikon-ikon koleksi produk yang disusun sedikit miring, biar terasa
  // seperti tumpukan katalog, bukan grid kaku.
  static const List<_CollageItem> _collage = [
    _CollageItem(Icons.watch, top: 0.02, left: 0.06, angle: -0.14, dark: true),
    _CollageItem(Icons.headphones, top: 0.00, left: 0.58, angle: 0.10),
    _CollageItem(Icons.backpack_outlined, top: 0.26, left: 0.02, angle: 0.08),
    _CollageItem(Icons.checkroom, top: 0.28, left: 0.62, angle: -0.09),
    _CollageItem(Icons.directions_walk, top: 0.54, left: 0.10, angle: -0.05, dark: true),
    _CollageItem(Icons.dry_cleaning_outlined, top: 0.56, left: 0.58, angle: 0.12),
  ];

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(fadeSlideRoute(const MainNavPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              // Indikator halaman (dots)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 6),
                  _dot(),
                  const SizedBox(width: 6),
                  _dot(),
                ],
              ),
              const SizedBox(height: 36),
              const Text(
                'Premium\nShopping Experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Curated collections, exclusive deals, and\nseamless checkout.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 24),
              // Area kolase ikon
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: _collage.map((item) {
                        return Positioned(
                          top: constraints.maxHeight * item.top,
                          left: constraints.maxWidth * item.left,
                          child: Transform.rotate(
                            angle: item.angle,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: item.dark ? AppColors.primary : AppColors.background,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                item.icon,
                                size: 28,
                                color: item.dark ? Colors.white : AppColors.textDark,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Tombol Skip & Next
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _goToHome(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        backgroundColor: AppColors.background,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _goToHome(context),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _CollageItem {
  final IconData icon;
  final double top;
  final double left;
  final double angle;
  final bool dark;

  const _CollageItem(
    this.icon, {
    required this.top,
    required this.left,
    required this.angle,
    this.dark = false,
  });
}