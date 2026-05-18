import 'package:flutter/material.dart';
import 'app_provider.dart';
import 'product_model.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: provider.favorites.isEmpty
          ? Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (_, i) {
                var item = provider.favorites[i];
                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: item.image.startsWith("http")
                        ? Image.network(item.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.error))
                        : Image.asset(item.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.error)),
                  ),
                  title: Text(item.title),
                  subtitle: Text("${item.price} \$"),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: Colors.red),
                    onPressed: () {
                      provider.toggleFavorite(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}
