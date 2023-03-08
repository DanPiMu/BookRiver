import 'dart:convert';

import 'package:book_river/src/api/api_exception.dart';
import 'package:book_river/src/model/book.dart';

import 'api_client.dart';

class RequestProvider {
  RequestProvider();

  //Recuerda: Cuando usas api_client, ya esta decoded

  ApiClient _apiClient = ApiClient();

  Future getBooks() async {
    try {
      dynamic _response = await _apiClient.booksHome();
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      ae.printDetails();
    }
  }

  Future getBookById(int bookId) async {
    try {
      dynamic _response = await _apiClient.getBookById(bookId);
      if (_response != null) {
        return _response;
      } else {
        print('algo ha salido mal');
      }
    } on ApiException catch (ae) {
      ae.printDetails();
    }
  }

  Future getBookListByCategory(int categoryId, int orden) async {
    try {
      dynamic _response =
          await _apiClient.getBooksListByCategory(categoryId, orden);
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

  Future getRatingsBookList(int categoryId) async {
    try {
      dynamic _response = await _apiClient.getRatingBooksList(categoryId);
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
    try {
      dynamic _response = await _apiClient.getInfoOtherUser(userID);
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

  Future getShelves() async {
    try {
      dynamic _response = await _apiClient.getShelves();
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
  static Future<bool> addNewShelves(Map<String, dynamic> params) async {
    try{
      dynamic _response = await ApiClient().postNewShelves(params);
      if(_response != null){

        return true;
      }
      return false;

    }on ApiException catch(ae){
      ae.printDetails();
    }
    return false;
  }
  ///Obtenemos estanteria por id
  Future getShelvesById(int shelveID) async {
    try {
      dynamic _response = await _apiClient.getShelvesById(shelveID);
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
