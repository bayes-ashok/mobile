import 'package:flutter/material.dart';
import 'package:Adhyayan/models/blog_model.dart';
import 'package:Adhyayan/viewmodels/product_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ProductViewModel _productViewModel;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      refresh();
    });
  }

  Future<void> refresh() async {
    _productViewModel.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthViewModel, ProductViewModel>(
      builder: (context,authVM, productVM, child) {
        _authViewModel = authVM; // Initialize _authViewModel
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              WelcomeText(authVM),
              SizedBox(height: 10),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: productVM.products.map((e) => ProductCard(e)).toList(),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed("/add-product");
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        "Hi ${authVM.loggedInUser != null ? authVM.loggedInUser!.name.toString() : "Guest"},",
        style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget ProductCard(ProductModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top:5,bottom: 10.0), // Adjust the value as needed
              child: Text(
                e.productName.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _trimDescription(e.productDescription.toString()),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _trimDescription(String description) {
    return description.length > 150 ? description.substring(0, 150) + "..." : description;
  }
}
