import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Placeholder untuk tab "Eksplor". Nantinya bisa diisi tampilan
/// kategori penuh, tapi untuk sekarang cukup menandai halaman ini
/// sudah bisa dituju lewat Bottom Navigation Bar.
class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'Eksplor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 6),
              Text('Fitur eksplor kategori segera hadir', style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
        ),
      ),
    );
  }
}