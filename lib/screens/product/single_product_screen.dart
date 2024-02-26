import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Adhyayan/models/favorite_model.dart';
import 'package:Adhyayan/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
      create: (_) => SingleProductViewModel(),
      child: SingleProductBody(),
    );
  }
}

class SingleProductBody extends StatefulWidget {
  const SingleProductBody({Key? key}) : super(key: key);

  @override
  State<SingleProductBody> createState() => _SingleProductBodyState();
}

class _SingleProductBodyState extends State<SingleProductBody> {
  late SingleProductViewModel _singleProductViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _singleProductViewModel = Provider.of<SingleProductViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  Future<void> getData(String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
      await _singleProductViewModel.getProducts(productId);
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> favoritePressed(FavoriteModel? isFavorite, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SingleProductViewModel, AuthViewModel>(
      builder: (context, singleProductVM, authVm, child) {
        FavoriteModel? isFavorite;
        try {
          isFavorite = authVm.favorites.firstWhere((element) => element.productId == singleProductVM.product!.id);
        } catch (e) {}

        return singleProductVM.product == null
            ? Scaffold(
          body: Container(
            child: Text("Error"),
          ),
        )
            : singleProductVM.product!.id == null
            ? Scaffold(
          body: Center(
            child: Container(
              child: Text("Please wait..."),
            ),
          ),
        )
            : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Product Details"),
          ),
          backgroundColor: Color(0xFFf5f5f4),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    singleProductVM.product!.productName.toString(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    singleProductVM.product!.productDescription.toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FutureBuilder<String?>(
                    future: singleProductVM.product!.userId != null
                        ? _authViewModel.getUsername(singleProductVM.product!.userId!)
                        : Future.value(null),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Author: Loading...");
                      } else if (snapshot.hasError) {
                        return Text("Author: Error");
                      } else {
                        return Text("Author: ${snapshot.data ?? 'Unknown'}");
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        favoritePressed(isFavorite, singleProductVM.product!.id!);
                      },
                      child: Text(
                        isFavorite != null ? "Remove from Collection" : "Save to Collection",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
