

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
      if (_response != null){

        return _response;
      }else{
        print('algo ha salido mal');
      }
    }on ApiException catch(ae){
      ae.printDetails();
    }
  }



  Future<dynamic> testingRequest() async {

    try{
      return true;
    }on ApiException catch(ae){
      rethrow;
    }
    }
}
