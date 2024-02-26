import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Adhyayan/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../models/favorite_model.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      getInit();
    });
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, child) {
        return Container(
          margin: EdgeInsets.only(top: 16), // Add top margin
          child: RefreshIndicator(
            onRefresh: getInit,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: authVM.favoriteProduct == null
                  ? Column(
                children: [
                  Center(child: Text("Something went wrong")),
                ],
              )
                  : authVM.favoriteProduct!.isEmpty
                  ? Column(
                children: [
                  Center(child: Text("Please add to favorite")),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: authVM.favoriteProduct!.map((e) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/single-product", arguments: e.id!);
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Add margin
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.productName.toString(),
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8),
                            Text(
                              _trimDescription(e.productDescription.toString()),
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  String _trimDescription(String description) {
    return description.length > 150 ? description.substring(0, 150) + "..." : description;
  }
}
