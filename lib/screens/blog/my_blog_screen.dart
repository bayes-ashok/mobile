import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/blog_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({Key? key}) : super(key: key);

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try {
      await _authViewModel.getMyProducts();
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  String _trimDescription(String description) {
    return description.length > 75 ? description.substring(0, 75) + "..." : description;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: getInit,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (_authViewModel.myProduct != null && _authViewModel.myProduct!.isEmpty)
                  Center(child: Text("You can add your products here")),
                if (_authViewModel.myProduct != null)
                  ..._authViewModel.myProduct!.map((e) => ProductWidgetList(context, e as ProductModel))
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget ProductWidgetList(BuildContext context, ProductModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Card(
          elevation: 5,
          child: ListTile(
            title: Container(
              margin: EdgeInsets.only(top: 5, bottom: 10.0),
              child: Text(
                e.productName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Text(
              _trimDescription(e.productDescription.toString()), // Trim the description
            ),
            trailing: Wrap(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/edit-product", arguments: e.id);
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.orange,
                ),
                IconButton(
                  onPressed: () {
                    deleteProduct(e.id.toString());
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deleteProduct(String id) async {
    var response = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete product?'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close')),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteFunction(id);
              },
              child: Text('Delete'),
            )
          ],
        );
      },
    );
  }

  deleteFunction(String id) async {
    _ui.loadState(true);
    try {
      await _authViewModel.deleteMyProduct(id);
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }
}
