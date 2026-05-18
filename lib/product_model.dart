class Product {
  String title;
  String subtitle;
  String image;
  double price;
  String category;
  int quantity;

  Product({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.category,
    this.quantity = 1,
  });
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "subtitle": subtitle,
      "image": image,
      "price": price,
      "category": category,
    };
  }
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json["title"]?.toString() ?? "",
      subtitle: (json["description"] ?? json["subtitle"])?.toString() ?? "",
      image: json["image"]?.toString() ?? "",
      price: (json["price"] as num?)?.toDouble() ?? 0.0,
      category: json["category"]?.toString() ?? "",
      quantity: (json["quantity"] as int?) ?? 1,
    );
  }
}