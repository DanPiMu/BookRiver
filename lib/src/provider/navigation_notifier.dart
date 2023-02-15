import 'package:flutter/material.dart';

import '../config/enums.dart';

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

}
