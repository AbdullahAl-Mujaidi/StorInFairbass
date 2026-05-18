
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';
import 'Category_Page.dart';
import 'Cart _Page.dart';
import 'Favorites _Page.dart';
import 'Details.dart';

class home extends StatelessWidget {

  List Catgories = [
    {"iconName": Icons.electrical_services, "title": "electronics"},
    {"iconName": Icons.diamond, "title": "jewelery"},
    {"iconName": Icons.checkroom, "title": "men's clothing"},
    {"iconName": Icons.woman, "title": "women's clothing"},
  ];
 
  Widget build(BuildContext context) {
    var provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (_) => FavoritesPage()));
            },
          ),
         
          Stack(
            alignment: Alignment.center,
            children: [
              
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CartPage()));
                },
              ),
                
                
                if(provider.cart.length > 0)
                
                Positioned(
                  
                  top: -1,
                  child: 
                  Container(
                    width: 15,
                    height: 15,
                   
                     decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 187, 219, 3),
                     
                      borderRadius: BorderRadius.circular(20),
                    ),
                
                    child: 
                   
                    Center(
                      child: Text(
                       provider.cart.length.toString(),style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),),
                    ),
                  ),)
                 
              
            ],
          ),
        ],
      ),

      body: ListView(
       
        children: [

          // Categories
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: Catgories.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => CategoryPage(
                        category: Catgories[index]["title"],
                      ),
                    ));
                },
                child:
                 Container(
                  width: 100,
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    
                    children: [
                      Icon(Catgories[index]["iconName"], size: 40),
                      Text(Catgories[index]["title"]),
                    ],
                                   ),
                 ),
              ),
            ),
          ),

          // Products
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250,
            ),
            itemBuilder: (context, index) {

              var product = provider.products[index];

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
                      Image.network(product.image, height: 100, errorBuilder: (context, error, stackTrace) => Icon(Icons.error)),
                      Text(product.title),
                       Text(product.price.toString() + " \$", style: TextStyle(color: Colors.orange)),
  
                      // ❤️ Favorite
                      IconButton(
                        icon: Icon(
                          provider.isFavorite(product)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: provider.isFavorite(product) ? Colors.red : null,
                        ),
                        onPressed: () {
                          provider.toggleFavorite(product);
                          provider.saveFavorites();
                        },
                      ),
  
                      // 🛒 Cart
                      ElevatedButton(
                        child: Text("Add to Cart"),
                        onPressed: () {
                          provider.addToCart(product);
                          provider.saveCart();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}