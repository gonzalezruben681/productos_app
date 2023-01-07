import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productosapp/models/product.dart';
import 'package:productosapp/screens/screens.dart';
import 'package:productosapp/services/services.dart';
import 'package:productosapp/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
              onPressed: () {
                authService.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: const Icon(Icons.login_outlined))
        ],
      ),
      body: ListView.builder(
        itemCount: productsService.products.length,
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              productsService.selectedProduct =
                  productsService.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(
              product: productsService.products[index],
            )),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            productsService.selectedProduct = Product(
              disponible: false,
              titulo: '',
              valor: 0,
            );
            Navigator.pushNamed(context, 'product');
          }),
    );
  }
}
