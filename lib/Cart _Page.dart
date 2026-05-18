import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'product_model.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.cart.length,
              itemBuilder: (_, i) {
                var item = provider.cart[i];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: item.image.startsWith("http")
                        ? Image.network(item.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.error))
                        : Image.asset(item.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.error)),
                  ),
                  title: Text(item.title),
                  subtitle: Text("${item.price} \$   total: ${item.price * item.quantity} \$"),
                  
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          provider.decrementQuantity(item);
                        },
                      ),
                      Text("${item.quantity}"),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          provider.incrementQuantity(item);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.removeFromCart(item);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Total: ${provider.totalPrice} \$",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
