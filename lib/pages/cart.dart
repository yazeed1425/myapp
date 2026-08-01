import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_application_2/services/data.dart';
import 'package:flutter_application_2/models/cart_items.dart';

class Cart extends HookWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = useState<List<CartItem>>([]);

    Future<void> loadCart() async {
      final items = await fetchCartItems();
      cartState.value = items;
    }

    useEffect(() {
      loadCart();
      return null;
    }, []);

    Future<void> updateItemQuantity(CartItem item, int change) async {
      final newQuantity = item.quantity + change;

      if (newQuantity <= 0) {
        await removeFromCart(item.id);
      } else {
        await supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', item.id);
      }
      await loadCart();
    }

    Future<void> deleteItem(int id) async {
      await removeFromCart(id);
      await loadCart();
    }

    final double totalPrice = cartState.value.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('سلة المشتريات'), centerTitle: true),
      body: cartState.value.isEmpty
          ? const Center(
              child: Text('السلة فارغة', style: TextStyle(fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartState.value.length,
                    itemBuilder: (context, index) {
                      final item = cartState.value[index];
                      final double totalItemPrice = item.price * item.quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${item.price} ر.س | الإجمالي: ${totalItemPrice.toStringAsFixed(2)} ر.س',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.brown,
                                ),
                                onPressed: () => updateItemQuantity(item, -1),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.brown,
                                ),
                                onPressed: () => updateItemQuantity(item, 1),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteItem(item.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, -5),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(2)} SAR',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
