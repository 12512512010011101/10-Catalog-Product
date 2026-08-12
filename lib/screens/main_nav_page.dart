import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_page.dart';
import 'explore_page.dart';

/// Halaman pembungkus yang menampilkan Bottom Navigation Bar
/// dan berpindah antar tab: Home, Eksplor.
///
/// Sengaja baru 2 tab dulu -- tab Keranjang & Profil belum
/// dipasang karena belum dibutuhkan. Kalau nanti mau ditambah,
/// tinggal tambahkan lagi ke _pages dan destinations di bawah
/// (file cart_page.dart & profile_page.dart sudah disiapkan
/// terpisah, tinggal di-import lagi saat dibutuhkan).
///
/// Menggunakan IndexedStack (bukan ganti widget biasa) supaya state
/// tiap tab (misal scroll position atau search query di Home) tetap
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.1),
        elevation: 8,
        height: 64,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: AppColors.textMuted),
            selectedIcon: Icon(Icons.explore, color: AppColors.primary),
            label: 'Eksplor',
          ),
        ],
      ),
    );
  }
}