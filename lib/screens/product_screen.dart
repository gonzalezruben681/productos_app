import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productosapp/providers/product_form_provider.dart';
import 'package:productosapp/services/services.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:productosapp/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);
    return ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;

  const _ProductScreenBody({Key? key, required this.productService})
      : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(url: productService.selectedProduct.fotoUrl),
                  Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 40, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 30,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 100);
                        // final XFile? photo = await picker.pickImage(
                        //     source: ImageSource.camera, imageQuality: 100);
                        if (photo == null) {
                          return;
                        }
                        productService.updateSelectedProductImage(photo.path);
                        // try {
                        // } catch (e) {}
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
              _ProductForm(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: productService.isSaving
              ? null
              : () async {
                  if (!productForm.isValidForm()) return;
                  final String? imageUrl = await productService.uploadImage();
                  if (imageUrl != null) productForm.product.fotoUrl = imageUrl;
                  await productService.saveOrCreateProduct(productForm.product);
                },
          child: productService.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(Icons.save_outlined)),
    );
  }
}

class _ProductForm extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: productForm.formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: product.titulo,
                  onChanged: (value) => product.titulo = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    return null;
                  },
                  decoration: InputDecorations.authInputDecoration(
                      hintText: 'Nombre del producto', labelText: 'Nombre'),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  initialValue: '${product.valor}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.valor = 0;
                    } else {
                      product.valor = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                      hintText: '\$150', labelText: 'Precio'),
                ),
                const SizedBox(height: 30),
                SwitchListTile.adaptive(
                  value: product.disponible,
                  title: const Text('Disponible'),
                  activeColor: Colors.indigo,
                  onChanged: (value) => productForm.updateAvailability(value),
                ),
                const SizedBox(height: 30),
              ],
            )),
      ),
    );
  }
}

BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5)
        ]);
