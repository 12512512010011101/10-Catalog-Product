import '../models/product.dart';

List<Product> generateDummyProducts() {
  return [
    Product(
      id: '1',
      name: 'Kaos Polos putih',
      category: 'Pakaian',
      price: 75000,
      stock: 20,
      description:
          'Kaos polos berbahan katun combed 24s yang lembut dan adem dipakai '
          'seharian. Cocok untuk dipakai santai maupun dipadukan dengan '
          'outfit kasual lainnya.',
      imagePath: 'assets/images/kaos_putih.png',
    ),
    Product(
      id: '2',
      name: 'Celana Jeans Slim',
      category: 'Pakaian',
      price: 150000,
      stock: 10,
      description:
          'Celana jeans potongan slim fit dengan bahan denim stretch yang '
          'nyaman bergerak. Warna biru klasik, mudah dipadukan dengan '
          'atasan apa saja.',
      imagePath: 'assets/images/celana_jeans.png',
    ),

    Product(
      id: '3',
      name: 'Sepatu Sneakers Putih',
      category: 'Sepatu',
      price: 250000,
      stock: 5,
      description:
          'Sneakers putih bersih dengan desain minimalis, cocok untuk gaya '
          'sehari-hari. Sol karet empuk membuat kaki tetap nyaman meski '
          'dipakai jalan jauh.',
      imagePaths: [
        'assets/images/sepatu_sneakers.png',
        'assets/images/sepatu_sneakers.png',
        'assets/images/sepatu_sneakers.png',
      ],
    ),

    Product(
      id: '4',
      name: 'Sandal Jepit',
      category: 'Sepatu',
      price: 25000,
      stock: 30,
      description:
          'Sandal jepit ringan dan anti-slip, pas untuk aktivitas santai di '
          'rumah maupun jalan-jalan casual. Bahan karet tahan lama dan '
          'mudah dibersihkan.',
      imagePath: 'assets/images/sandal_jepit.png',
    ),

    Product(
      id: '5',
      name: 'Tas Ransel Laptop',
      category: 'Aksesoris',
      price: 180000,
      stock: 8,
      description:
          'Tas ransel dengan kompartemen khusus laptop hingga 15 inch, '
          'bahan tahan air, dan banyak kantong tambahan untuk menyimpan '
          'barang-barang penting.',
      imagePaths: [
        'assets/images/tas_ransel.png',
        'assets/images/topi_baseball.png',
        'assets/images/kacamata_hitam.png',
      ],
    ),

    Product(
      id: '6',
      name: 'Topi Baseball',
      category: 'Aksesoris',
      price: 45000,
      stock: 15,
      description:
          'Topi baseball dengan strap adjustable di belakang, cocok untuk '
          'melindungi dari sinar matahari sekaligus melengkapi gaya kasual '
          'kamu.',
      imagePath: 'assets/images/topi_baseball.png',
    ),

    Product(
      id: '7',
      name: 'Jaket Hoodie Abu',
      category: 'Pakaian',
      price: 165000,
      stock: 12,
      description:
          'Hoodie dengan bahan fleece tebal yang hangat, dilengkapi kantong '
          'depan dan tali topi yang bisa disesuaikan. Pas dipakai saat '
          'cuaca dingin.',
      imagePaths: [
        'assets/images/jaket_hoodie.png',
        'assets/images/kemeja_flanel.png',
        'assets/images/kaos_putih.png',
      ],
    ),

    Product(
      id: '8',
      name: 'Kemeja Flanel',
      category: 'Pakaian',
      price: 120000,
      stock: 7,
      description:
          'Kemeja flanel motif kotak-kotak dengan bahan katun yang lembut, '
          'cocok dipakai langsung atau sebagai outer di atas kaos polos.',
      imagePath: 'assets/images/kemeja_flanel.png',
    ),
    Product(
      id: '10',
      name: 'Kacamata Hitam',
      category: 'Aksesoris',
      price: 60000,
      stock: 18,
      description:
          'Kacamata hitam dengan lensa UV protection dan frame ringan, '
          'menambah gaya sekaligus melindungi mata dari sinar matahari.',
      imagePath: 'assets/images/kacamata_hitam.png',
    ),
    Product(
      id: '11',
      name: 'Sandal Gunung',
      category: 'Sepatu',
      price: 210000,
      stock: 4,
      description:
          'Sandal gunung dengan sol grip anti-selip, kuat untuk medan '
          'berbatu maupun basah. Pilihan pas untuk aktivitas outdoor dan '
          'hiking ringan.',
      imagePath: 'assets/images/sandal_gunung.png',
    ),
  ];
}