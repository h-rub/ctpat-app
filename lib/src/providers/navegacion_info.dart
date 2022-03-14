import 'package:flutter/material.dart';

class NavegacionInfo with ChangeNotifier {
  int _currentPage = 0;
  PageController _pageController = new PageController(initialPage: 0);

  get currentPage {
    return this._currentPage;
  }

  set currentPage(int index) {
    this._currentPage = index;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => this._pageController;
}
