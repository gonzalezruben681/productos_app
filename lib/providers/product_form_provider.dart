import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product product;
  ProductFormProvider(this.product);

  updateAvailability(bool value) {
    product.disponible = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
