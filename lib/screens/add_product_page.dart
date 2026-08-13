import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Menyimpan gambar yang dipilih dari galeri (kalau ada). Kalau user
  // memilih gambar dari galeri, ini yang dipakai dan field URL diabaikan.
  Uint8List? _pickedImageBytes;
  String? _pickedImageMimeType;

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // dikompres dikit supaya base64-nya tidak kegedean
    );
    if (pickedFile == null) return; // user membatalkan pemilihan

    final bytes = await pickedFile.readAsBytes();
    setState(() {
      _pickedImageBytes = bytes;
      _pickedImageMimeType = pickedFile.mimeType ?? 'image/jpeg';
      // Kalau sebelumnya sempat isi URL, kosongkan supaya tidak ambigu
      // gambar mana yang mau dipakai.
      _imageUrlController.clear();
    });
  }

  void _clearPickedImage() {
    setState(() {
      _pickedImageBytes = null;
      _pickedImageMimeType = null;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Prioritas: gambar dari galeri (kalau dipilih) > URL manual > kosong.
      String finalImage = '';
      if (_pickedImageBytes != null) {
        final base64Str = base64Encode(_pickedImageBytes!);
        finalImage = 'data:$_pickedImageMimeType;base64,$base64Str';
      } else {
        finalImage = _imageUrlController.text.trim();
      }

      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        category: _categoryController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stock: int.parse(_stockController.text.trim()),
        description: _descriptionController.text.trim(),
        // Kalau ada gambar (dari galeri atau URL), dipakai sebagai satu-
        // satunya gambar produk. Kalau kosong, imagePaths tetap [] -> nanti
        // tampil placeholder ikon.
        imagePaths: finalImage.isNotEmpty ? [finalImage] : [],
      );
      Navigator.pop(context, newProduct);
    }
  }

  // Kotak preview kecil di bawah field URL / tombol galeri. Kalau kosong ->
  // tampil ikon gambar abu-abu (belum ada gambar). Kalau ada gambar dari
  // galeri, itu yang diprioritaskan. Kalau URL rusak/gagal load ->
  // ProductImage otomatis fallback ke ikon placeholder juga.
  Widget _buildImagePreview() {
    final url = _imageUrlController.text.trim();
    final hasPickedImage = _pickedImageBytes != null;
    final hasAnyImage = hasPickedImage || url.isNotEmpty;

    Widget previewContent;
    if (hasPickedImage) {
      previewContent = Image.memory(_pickedImageBytes!, fit: BoxFit.cover);
    } else if (url.isNotEmpty) {
      previewContent = ProductImage(path: url);
    } else {
      previewContent = const Icon(Icons.image_outlined, color: AppColors.textMuted, size: 32);
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 110,
            width: double.infinity,
            color: AppColors.primary.withValues(alpha: 0.06),
            child: previewContent,
          ),
        ),
        if (hasAnyImage)
          Positioned(
            top: 6,
            right: 6,
            child: Material(
              color: Colors.black.withValues(alpha: 0.45),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  setState(() {
                    _clearPickedImage();
                    _imageUrlController.clear();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradientHeader(
            height: 130,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Row(
              children: [
                Material(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tambah Produk',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Produk',
                        prefixIcon: Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama produk wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: Icon(Icons.category_outlined, color: AppColors.primary),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Kategori wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        prefixIcon: Icon(Icons.payments_outlined, color: AppColors.primary),
                        prefixText: 'Rp ',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Harga wajib diisi';
                        }
                        final parsed = double.tryParse(value.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Harga harus berupa angka lebih dari 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Stok wajib diisi';
                        }
                        final parsed = int.tryParse(value.trim());
                        if (parsed == null || parsed < 0) {
                          return 'Stok harus berupa angka bulat, minimal 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi - opsional',
                        hintText: 'Ceritakan bahan, kegunaan, atau keunggulan produk ini...',
                        prefixIcon: Icon(Icons.notes_outlined, color: AppColors.primary),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _imageUrlController,
                      enabled: _pickedImageBytes == null,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        labelText: 'Gambar (URL) - opsional',
                        hintText: _pickedImageBytes == null
                            ? 'https://contoh.com/gambar.jpg'
                            : 'Sedang pakai gambar dari galeri',
                        prefixIcon: const Icon(Icons.image_outlined, color: AppColors.primary),
                      ),
                      // Opsional: boleh kosong. Kalau diisi, wajib link yang
                      // valid (harus diawali http:// atau https://) supaya
                      // ProductImage tahu ini gambar network, bukan asset.
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) return null;
                        final isValidUrl = trimmed.startsWith('http://') || trimmed.startsWith('https://');
                        if (!isValidUrl) {
                          return 'URL harus diawali http:// atau https://';
                        }
                        return null;
                      },
                      // Preview live: tiap kali user ngetik/paste URL baru,
                      // gambar kecil di bawah field ikut ter-update.
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('atau', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ),
                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(_pickedImageBytes == null
                            ? 'Pilih dari Galeri'
                            : 'Ganti Gambar dari Galeri'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildImagePreview(),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Simpan Produk'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}