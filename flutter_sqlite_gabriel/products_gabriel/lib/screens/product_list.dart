
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    List<Map<String, dynamic>> data =
        await DatabaseHelper.getProducts();

    setState(() {
      products = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.blue,
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('No products have been added yet.'),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Text(
                      'Price: \$${product['price']} '
                      '\nQuantity: ${product['quantity']}',
                    ),
                    leading: const Icon(
                      Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
