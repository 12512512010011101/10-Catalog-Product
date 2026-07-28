import '../models/product.dart';

List<Product> generateDummyProducts() {
  return [
    Product(id: '1', name: 'Kaos Polos putih', category: 'Pakaian', price: 75000, stock: 20, imagePath: 'assets/images/kaos_putih.png'),
    Product(id: '2', name: 'Celana Jeans Slim', category: 'Pakaian', price: 150000, stock: 10, imagePath: 'assets/images/celana_jeans.png'),
    Product(id: '3', name: 'Sepatu Sneakers Putih', category: 'Sepatu', price: 250000, stock: 5, imagePath: 'assets/images/sepatu_sneakers.png'),
    Product(id: '4', name: 'Sandal Jepit', category: 'Sepatu', price: 25000, stock: 30, imagePath: 'assets/images/sandal_jepit.png'),
    Product(id: '5', name: 'Tas Ransel Laptop', category: 'Aksesoris', price: 180000, stock: 8, imagePath: 'assets/images/tas_ransel.png'),
    Product(id: '6', name: 'Topi Baseball', category: 'Aksesoris', price: 45000, stock: 15, imagePath: 'assets/images/topi_baseball.png'),
    Product(id: '7', name: 'Jaket Hoodie Abu', category: 'Pakaian', price: 165000, stock: 12, imagePath: 'assets/images/jaket_hoodie.png'),
    Product(id: '8', name: 'Kemeja Flanel', category: 'Pakaian', price: 120000, stock: 7, imagePath: 'assets/images/kemeja_flanel.png'),
    Product(id: '10', name: 'Kacamata Hitam', category: 'Aksesoris', price: 60000, stock: 18, imagePath: 'assets/images/kacamata_hitam.png'),
    Product(id: '11', name: 'Sandal Gunung', category: 'Sepatu', price: 210000, stock: 4, imagePath: 'assets/images/sandal_gunung.png'),
  ];
}