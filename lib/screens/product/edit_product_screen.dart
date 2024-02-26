import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Adhyayan/models/product_model.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
      create: (_) => SingleProductViewModel(),
      child: EditProductBody(),
    );
  }
}

class EditProductBody extends StatefulWidget {
  const EditProductBody({Key? key}) : super(key: key);

  @override
  State<EditProductBody> createState() => _EditProductBodyState();
}

class _EditProductBodyState extends State<EditProductBody> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late SingleProductViewModel _singleProductViewModel;
  String? productId;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _singleProductViewModel = Provider.of<SingleProductViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      getData(args);
    });
    super.initState();
  }

  void editProduct() async {
    _ui.loadState(true);
    try {
      final ProductModel data = ProductModel(
        productDescription: _productDescriptionController.text,
        productName: _productNameController.text,
        userId: _authViewModel.loggedInUser!.userId,
      );
      await _authViewModel.editMyProduct(data, productId!);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
    }
    _ui.loadState(false);
  }

  getData(String args) async {
    _ui.loadState(true);
    try {
      await _singleProductViewModel.getProducts(args);
      ProductModel? product = _singleProductViewModel.product;

      if (product != null) {
        _productNameController.text = product.productName ?? "";
        _productDescriptionController.text = product.productDescription ?? "";
      }
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleProductViewModel>(
      builder: (context, singleProductVM, child) {
        if (_singleProductViewModel.product == null)
          return Text("Error");
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green, // Changed app bar color to green
            title: Text("Edit your blog"),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _productNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        label: Text("Blog Title"),
                        hintText: 'Enter Blog Title',
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _productDescriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 12, // Increased the height of the description box
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        border: InputBorder.none,
                        label: Text("Blog Description"),
                        hintText: 'Write your Blog here....',
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.blue),
                              ),
                            ),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                          ),
                          onPressed: () {
                            editProduct();
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20),
                          )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.orange),
                              ),
                            ),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(fontSize: 20),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
