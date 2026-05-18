import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getProducts() async {
  final response = await http.get(
    Uri.parse('https://fakestoreapi.com/products'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    print(data);
  }
}