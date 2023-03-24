import 'dart:convert';
import 'dart:io';

import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/model/book.dart';

import '../model/User.dart';
import '../model/categories.dart';
import '../model/ratings.dart';
import '../model/shelves.dart';
import 'api_client.dart';

class RequestProvider {
  RequestProvider();

  //Recuerda: Cuando usas api_client, ya esta decoded

  ApiClient _apiClient = ApiClient();

  Future getBooksNovetats() async {
    List<Book> _booksNovetatsList = [];

    try {
      dynamic _response = await _apiClient.booksHome();
      if (_response != null) {

        List<dynamic> bookListData = _response['data']['books'];
        _booksNovetatsList =
            bookListData.map((bookData) => Book.fromJson(bookData)).toList();
        return _booksNovetatsList;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      ae.printDetails();
    }
  }Future getBooksCategory() async {
    List<Categories> _categoriesList = [];

    try {
      dynamic _response = await _apiClient.booksHome();
      if (_response != null) {

        List<dynamic> categoryListData = _response['data']['categories'];
        _categoriesList = categoryListData
            .map((categoryData) => Categories.fromJson(categoryData))
            .toList();
        return _categoriesList;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      ae.printDetails();
    }
  }

  Future getBookById(int bookId) async {
    Book _book;
    try {
      dynamic _response = await _apiClient.getBookById(bookId);
      if (_response != null) {
        _book = Book.fromJson(_response);
        return _book;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      ae.printDetails();
    }
  }

  Future getBookListByCategory(int categoryId, int orden) async {
    List<Book> _bookListByCategory = [];
    try {
      dynamic _response =
          await _apiClient.getBooksListByCategory(categoryId, orden);
      if (_response != null) {
        List<dynamic> bookListData = _response;
        _bookListByCategory =
            bookListData.map((listData) => Book.fromJson(listData)).toList();
        return _bookListByCategory;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future getRatingsBookList(int categoryId) async {
    List<Ratings> _booksRatingsList = [];
    try {
      dynamic _response = await _apiClient.getRatingBooksList(categoryId);
      if (_response != null) {
        List<dynamic> bookListData = _response;
        _booksRatingsList =
            bookListData.map((bookData) => Ratings.fromJson(bookData)).toList();
        return _booksRatingsList;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future postRatingBook(int idBook, int star, String review) async {
    try {
      dynamic _response = await _apiClient.postRatingBook(idBook, star, review);
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future getOtheruser(int userID) async {
    User publicUser;
    try {
      dynamic _response = await _apiClient.getInfoOtherUser(userID);
      if (_response != null) {
        publicUser = User.fromJson(_response);
        return publicUser;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }Future getUserRatings(int userID) async {
    List<Ratings> _booksRatingsList = [];
    try {
      dynamic _response = await _apiClient.getInfoOtherUser(userID);
      if (_response != null) {
        List<dynamic> bookListData = _response['ratings'];
        _booksRatingsList =
            bookListData.map((bookData) => Ratings.fromJson(bookData)).toList();
        return _booksRatingsList;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future getShelves() async {
    List<Shelves> _shelvesList = [];
    try {
      dynamic _response = await _apiClient.getShelves();
      if (_response != null) {
        List<dynamic> shelvesListData = _response;
        _shelvesList = shelvesListData
            .map((listData) => Shelves.fromJson(listData))
            .toList();
        return _shelvesList;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future postShelvesBook(int idBook, int idShelves) async {
    try {
      dynamic _response = await _apiClient.postShelvesBook(idBook, idShelves);
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  static Future<bool> addNewShelves(
      Map<String, dynamic> params, File image) async {
    try {
      dynamic _response = await ApiClient().postNewShelves(params, image);
      if (_response != null) {
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  ///Obtenemos estanteria por id
  Future getShelvesById(int shelveID) async {
    Shelves shelvesObject;
    try {
      dynamic _response = await _apiClient.getShelvesById(shelveID);
      if (_response != null) {
        shelvesObject = Shelves.fromJson(_response);
        return shelvesObject;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  static Future<bool> updateShelves(
      Map<String, dynamic> params, int idShelves, File image) async {
    try {
      dynamic _response =
          await ApiClient().postUpdateShelves(params, idShelves, image);
      if (_response != null) {
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  Future getUser() async {
    User myUser;
    try {
      dynamic _response = await _apiClient.getUser();
      if (_response != null) {
        myUser = User.fromJson(_response);
        return myUser;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future logOut() async {
    try {
      dynamic _response = await _apiClient.postLogOut();
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  static Future<bool> editUser(
    Map<String, dynamic> params,
  ) async {
    try {
      dynamic _response = await ApiClient().postEditUser(params);
      if (_response != null) {
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  static Future<bool> editPassword(
    Map<String, dynamic> params,
  ) async {
    try {
      dynamic _response = await ApiClient().postEditPassword(params);
      if (_response != null) {
        return true;
      }
      return false;
    } on ApiException catch (ae) {
      ae.printDetails();
    }
    return false;
  }

  Future getBooksByName(String name) async {
    try {
      dynamic _response = await _apiClient.getBookByName(name);
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }

  Future getUsersByName(String name) async {
    try {
      dynamic _response = await _apiClient.getUserByName(name);
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      rethrow;
      ae.printDetails();
    }
  }
}
