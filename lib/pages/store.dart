import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/cart.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/services/data.dart';
import 'package:flutter_application_2/models/products_items.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<Widget> pages = [const StoreHome(), const Cart(), Profile()];
  int current = 0;

  void _navigatebottombar(int index) {
    setState(() {
      current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[current],
      appBar: AppBar(title: Text('Coffee')),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: current,
        onTap: _navigatebottombar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}

class StoreHome extends StatefulWidget {
  const StoreHome({super.key});

  @override
  State<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  List<Products> productsList = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await fetchProducts();
    setState(() {
      productsList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: productsList.isEmpty
          ? Center(child: Text('loading'))
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: productsList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final product = productsList[index];

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            product.imageUrl != null &&
                                product.imageUrl!.isNotEmpty
                            ? Image.network(
                                product.imageUrl!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(Icons.broken_image, size: 40),
                                    ),
                              )
                            : const Center(child: Icon(Icons.coffee, size: 40)),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product.price} SAR',
                                    style: const TextStyle(color: Colors.brown),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: Colors.brown,
                              ),
                              onPressed: () async {
                                await addToCart(product);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'تمت إضافة ${product.name} إلى السلة!',
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
