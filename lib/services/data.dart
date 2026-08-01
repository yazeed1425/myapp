import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_2/models/products_items.dart';
import 'package:flutter_application_2/models/cart_items.dart'; // تصحيح اسم الملف

final supabase = Supabase.instance.client;

Future<List<Products>> fetchProducts() async {
  final List<dynamic> data = await supabase.from('products').select();

  return data
      .map((json) => Products.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<List<CartItem>> fetchCartItems() async {
  final List<dynamic> response = await supabase.from('cart').select();

  return response
      .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
      .toList();
}

Future<void> addToCart(Products product) async {
  final existing = await supabase
      .from('cart')
      .select()
      .eq('idProducts', product.id)
      .maybeSingle();

  if (existing != null) {
    final int currentQuantity = existing['quantity'] ?? 1;
    await supabase
        .from('cart')
        .update({'quantity': currentQuantity + 1})
        .eq('id', existing['id']);
  } else {
    await supabase.from('cart').insert({
      'idProducts': product.id,
      'name': product.name,
      'price': product.price,
      'quantity': 1,
    });
  }
}

Future<void> removeFromCart(int cartId) async {
  await supabase.from('cart').delete().eq('id', cartId);
}
