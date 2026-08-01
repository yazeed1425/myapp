class Products {
  final int id;
  final String name;
  final double price;
  final String? imageUrl;

  Products({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
    );
  }
}
