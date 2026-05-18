import 'package:flutter/material.dart';
import 'app_provider.dart';
import 'product_model.dart';
import 'package:provider/provider.dart';
import 'Details.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  CategoryPage({required this.category});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);
    var items = provider.getByCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: items.isEmpty
          ? Center(child: Text("No products in this category"))
          : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                var product = items[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(item: product),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          child: product.image.startsWith("http")
                              ? Image.network(product.image, errorBuilder: (context, error, stackTrace) => Icon(Icons.error))
                              : Image.asset(product.image, errorBuilder: (context, error, stackTrace) => Icon(Icons.error)),
                        ),
                        Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text("${product.price} \$", style: TextStyle(color: Colors.orange)),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                provider.isFavorite(product)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: provider.isFavorite(product) ? Colors.red : null,
                              ),
                              onPressed: () {
                                provider.toggleFavorite(product);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add_shopping_cart),
                              onPressed: () {
                                provider.addToCart(product);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
