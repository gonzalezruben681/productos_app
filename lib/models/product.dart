// To parse this JSON data, do
//
//     final product = productFromMap(jsonString);

import 'dart:convert';

class Product {
  Product(
      {required this.disponible,
      this.fotoUrl,
      required this.titulo,
      required this.valor,
      this.id});

  bool disponible;
  String? fotoUrl;
  String titulo;
  double valor;
  String? id;

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
        titulo: json["titulo"],
        valor: json["valor"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "disponible": disponible,
        "fotoUrl": fotoUrl,
        "titulo": titulo,
        "valor": valor,
      };

  Product copy() => Product(
      disponible: disponible,
      fotoUrl: fotoUrl,
      titulo: titulo,
      valor: valor,
      id: id);
}
