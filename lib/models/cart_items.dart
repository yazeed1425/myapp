class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;
  final int productId;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.productId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      productId: json['idProducts'] ?? json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'idProducts': productId,
    };
  }
}
