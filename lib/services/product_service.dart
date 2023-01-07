import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productosapp/models/product.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-c8193-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'productos.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // Es necesario crear
      await createProduct(product);
    } else {
      // actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos/${product.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    // ignore: unused_local_variable
    final resp = await http.put(url, body: product.toJson());
    // actualizar el listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'productos.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: product.toJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  // preview de la imagen
  void updateSelectedProductImage(String path) {
    selectedProduct.fotoUrl = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) {
      return null;
    }
    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dfxgtwfjg/image/upload?upload_preset=wpe9lunw');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);
    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
