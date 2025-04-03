/// this  file is for all controll for navigating between pages
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PageProvider extends ChangeNotifier
{
  int _currentPage=0;
  int get currentPage=>_currentPage;
  final PageController pageController=PageController();
  void changePage(int index)
  {
    _currentPage=index;
    pageController.jumpToPage(index);
    notifyListeners();
  }
}