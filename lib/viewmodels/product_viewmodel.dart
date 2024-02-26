import 'package:flutter/cupertino.dart';
import 'package:Adhyayan/models/blog_model.dart';
import 'package:Adhyayan/repositories/note_repositories.dart';

class ProductViewModel with ChangeNotifier {
  ProductRepository _productRepository = ProductRepository();
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  Future<void> getProducts() async {
    _products = [];
    notifyListeners();
    try {
      var response = await _productRepository.getAllProducts();
      for (var element in response) {
        print(element.id);
        _products.add(element.data());
      }
      notifyListeners();
    } catch (e) {
      print(e);
      _products = [];
      notifyListeners();
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      var response = await _productRepository.addProducts(product: product);
    } catch (e) {
      notifyListeners();
    }
  }
}
