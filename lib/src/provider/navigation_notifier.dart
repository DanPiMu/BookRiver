
import 'package:flutter/material.dart';

import '../config/enums.dart';
import '../model/book.dart';

class NavigationNotifier extends ChangeNotifier {
  ///Opcion seleccionada
  NavigationOption _selectedOption = NavigationOption.Inici;

  NavigationOption get selectedOption => _selectedOption;


  /// TODO: Definir funció setCurrentTab que permeti canviar l'index de la navegació
  ///       a partir del valor de l'enum corresponent a l'index de la navegació.
  set selectedOption(NavigationOption option) {
    _selectedOption = option;
    notifyListeners();
  }

  /// TODO: Definir funció setCurrentTabIndex que permeti canviar l'index de la
  ///       navegació a partir del index en forma de integer.

// Cart
  List<Book> books = [];

  double get total {
    return books.fold(
        0, (total, product) => total + product.price! * product.units);
  }

  void addToCart(Book product) {
    bool repetido = false;

    for (var i = 0; i < books.length; i++) {
      if (books[i].id == product.id) {
        repetido = true;
        addUnitsToProduct(product, 1);
      } else {
        repetido = false;
      }
    }
    if (repetido == false) {
      books.add(product);
    }
    notifyListeners();
    print(repetido);
  }

  void removeFromCart(Book product) {
    books.remove(product);
    product.units = 1;
    notifyListeners();
  }

  void addUnitsToProduct(Book product, int units) {
    product.units += units;
    notifyListeners();
  }

  void removeUnitsToProduct(Book product, int units) {
    if (product.units == 0) {
      removeFromCart(product);
    } else {
      product.units -= units;
      if (product.units == 0) {
        removeFromCart(product);
      }
    }
    notifyListeners();
  }
  void removeAllUnitsFromCart() {
    books.clear();
    notifyListeners();
  }
}
