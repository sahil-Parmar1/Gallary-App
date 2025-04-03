import "package:flutter/material.dart";
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallary_app/providerdirectory/Pageprovider.dart';
import 'package:provider/provider.dart';





class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider=context.watch<PageProvider>();

    return Scaffold(
      body: PageView(
        controller: pageProvider.pageController,
        children: [
          Container(color: Colors.blue),
          Container(color: Colors.red),
          Container(color: Colors.greenAccent.shade700),
          Container(color: Colors.orange),
        ],
        onPageChanged: (index) => pageProvider.changePage(index) ,
      ),
      bottomNavigationBar: Consumer<PageProvider>(
        builder: (context,provider,child) {
          return BottomBar(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.all(20.0),
            selectedIndex: provider.currentPage,
            onTap:(index) => provider.changePage(index),
              items: <BottomBarItem>[
              BottomBarItem(
                icon: Icon(Icons.photo),
                title: Text('Pictures'),
                activeColor: Colors.blue,
                activeTitleColor: Colors.blue.shade600,
              ),
              BottomBarItem(
                icon: Icon(CupertinoIcons.photo_on_rectangle),
                title: Text('Album'),
                activeColor: Colors.red,
              ),
              BottomBarItem(
                icon: Icon(Icons.person),
                title: Text('Videos'),
                backgroundColorOpacity: 0.1,
                activeColor: Colors.greenAccent.shade700,
              ),
              BottomBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.orange,
                activeIconColor: Colors.orange.shade600,
                activeTitleColor: Colors.orange.shade700,
              ),
            ],
          );
        }
      ),
    );
  }
}
