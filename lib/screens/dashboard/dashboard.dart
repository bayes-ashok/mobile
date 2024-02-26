import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Adhyayan/screens/home/home_screen.dart';
import 'package:Adhyayan/screens/favorite/favorite_screen.dart';
import 'package:Adhyayan/screens/product/my_product_screen.dart'; // Import MyProductScreen
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late ProductViewModel _productViewModel;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  void getInit() {
    try {
      _productViewModel.getProducts();
      _authViewModel.getFavoritesUser();
      _authViewModel.getMyProducts();
    } catch (e) {
      print(e);
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    _authViewModel.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? 'Home'
              : selectedIndex == 1
              ? 'Collection'
              : 'My Blogs',
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      // Use Drawer for navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 8), // Add some space between title and name
                  Text(
                    'Adhyayan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                pageController.jumpToPage(0);
                Navigator.pop(context);
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment), // Use suitable My Notes icon
              title: Text('My Blogs'), // Keep 'My Notes' as it is
              onTap: () {
                pageController.jumpToPage(2); // Jump to 'My Notes' screen
                Navigator.pop(context);
                setState(() {
                  selectedIndex = 2; // Set selectedIndex to 2
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.note), // Use suitable Save icon
              title: Text('Collection'), // Change the label to 'Save'
              onTap: () {
                pageController.jumpToPage(1); // Jump to the relevant screen
                Navigator.pop(context);
                setState(() {
                  selectedIndex = 1; // Set selectedIndex accordingly
                });
              },
            ),
            Divider(), // Add a divider
            ListTile(
              leading: Icon(Icons.logout), // Use a suitable icon for logout
              title: Text('Logout'),
              onTap: () {
                _confirmLogout(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            HomeScreen(),
            FavoriteScreen(),
            MyProductScreen(), // Add MyProductScreen
          ],
        ),
      ),
    );
  }
}
