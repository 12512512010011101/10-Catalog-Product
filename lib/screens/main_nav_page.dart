import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';
import 'explore_page.dart';

/// Halaman pembungkus yang menampilkan Bottom Navigation Bar
/// dan berpindah antar tab: Home, Eksplor.
///
/// Sengaja baru 2 tab dulu -- tab Keranjang & Profil belum
/// dipasang karena belum dibutuhkan. Kalau nanti mau ditambah,
/// tinggal tambahkan lagi ke _pages dan _tabs di bawah (file
/// cart_page.dart & profile_page.dart sudah disiapkan terpisah,
/// tinggal di-import lagi saat dibutuhkan).
///
/// Menggunakan IndexedStack (bukan ganti widget biasa) supaya state
/// tiap tab (misal scroll position atau kategori terpilih di Home) tetap
/// tersimpan walau pindah-pindah tab, bukan rebuild dari nol tiap kali.
class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ExplorePage(),
  ];

  static const List<_NavTabData> _tabs = [
    _NavTabData(icon: Icons.home_rounded, label: 'Home'),
    _NavTabData(icon: Icons.explore_rounded, label: 'Eksplor'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // ---- Floating pill nav bar ----
      // Gantiin NavigationBar bawaan Material yang lama (nempel penuh
      // di bawah). Sekarang berupa kapsul putih yang "melayang" dengan
      // jarak dari tepi layar, dan tab yang aktif melebar jadi pill
      // hitam pekat berisi ikon + label -- meniru gaya referensi.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(31),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_tabs.length, (index) {
                final isSelected = index == _currentIndex;
                final tab = _tabs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _NavTabButton(
                    icon: tab.icon,
                    label: tab.label,
                    isSelected: isSelected,
                    onTap: () => setState(() => _currentIndex = index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabData {
  final IconData icon;
  final String label;
  const _NavTabData({required this.icon, required this.label});
}

/// Satu tombol tab di nav bar. Tab yang aktif otomatis melebar (animasi)
/// jadi kapsul hitam berisi ikon putih + label. Tab yang tidak aktif cuma
/// tampil ikon abu-abu tanpa label, supaya nav bar tetap ringkas.
class _NavTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          height: 42,
          padding: EdgeInsets.symmetric(horizontal: isSelected ? 18 : 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : Colors.grey.shade400,
              ),
              // AnimatedSize supaya label muncul/hilang dengan transisi
              // halus (bukan langsung "loncat"), sinkron sama lebar pill.
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      )
                    : const SizedBox(width: 0, height: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}