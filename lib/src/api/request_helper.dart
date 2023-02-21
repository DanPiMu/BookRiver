

import 'package:book_river/src/api/api_exception.dart';

import 'api_client.dart';

class RequestProvider {
  RequestProvider();

  ApiClient _apiClient = ApiClient();

  Future<dynamic> testingRequest() async {

    try{
      return _apiClient.testingRequest();
    }on ApiException catch(ae){
      rethrow;
    }
    }
}
