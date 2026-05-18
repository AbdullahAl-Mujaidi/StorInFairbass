import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    loadData();
    getProducts();
  }

  List<Product> products = [];
  List<Product> cart = [];
  List<Product> favorites = [];

  saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = cart.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList("cart", data);
  }

  saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = favorites.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList("favorites", data);
  }

  saveproducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = products.map((item) => jsonEncode(item.toJson())).toList();
    prefs.setStringList("products", data);
  }

  loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // تحميل السلة
    List<String> cartData = prefs.getStringList("cart") ?? [];
    cart = cartData.map((item) => Product.fromJson(jsonDecode(item))).toList();

    // تحميل المفضلة
    List<String> favData = prefs.getStringList("favorites") ?? [];
    favorites = favData.map((item) => Product.fromJson(jsonDecode(item))).toList();

    // تحميل المنتجات المخزنة محلياً مؤقتاً
    List<String> prodData = prefs.getStringList("products") ?? [];
    products = prodData.map((item) => Product.fromJson(jsonDecode(item))).toList();

    notifyListeners();
  }

  // Future<void> getProducts() async {
  //   try {
  //     print("🚀 بدأ تحميل المنتجات من Firebase");

  //     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('products').get();

  //     products = snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       return Product.fromJson(data);
  //     }).toList();

  //     print("✅ تم تحميل ${products.length} منتج");
  //     await saveproducts();
  //     notifyListeners();
  //   } catch (e) {
  //     print("⚠️ خطأ في تحميل Firebase: $e");
  //   }
  // }
  Future<void> getProducts() async {
  try {
    print("🚀 بدأ تحميل المنتجات من Firebase");

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('products')
            .get();

    print("عدد المنتجات: ${snapshot.docs.length}");

    for (var doc in snapshot.docs) {
      print(doc.data());
    }

    products = snapshot.docs.map((doc) {
      final data =
          doc.data() as Map<String, dynamic>;

      return Product.fromJson(data);
    }).toList();

    print("✅ تم تحميل ${products.length} منتج");

    await saveproducts();

    notifyListeners();

  } catch (e) {
    print("⚠️ خطأ في تحميل Firebase: $e");
  }
}

  void addToCart(Product product) {
    var existingProduct = cart.where((p) => p.title == product.title);
    if (existingProduct.isNotEmpty) {
      existingProduct.first.quantity++;
    } else {
      product.quantity = 1;
      cart.add(product);
    }
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    product.quantity++;
    notifyListeners();
  }

  void decrementQuantity(Product product) {
    if (product.quantity > 1) {
      product.quantity--;
    } else {
      cart.remove(product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cart.remove(product);
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    bool isExist = favorites.any((p) => p.title == product.title);
    if (isExist) {
      favorites.removeWhere((p) => p.title == product.title);
    } else {
      favorites.add(product);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return favorites.any((p) => p.title == product.title);
  }

  double get totalPrice {
    double total = 0;
    for (var item in cart) {
      total += (item.price * item.quantity);
    }
    return total;
  }

  List<Product> getByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
