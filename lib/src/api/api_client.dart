import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:book_river/src/utils/user_helper_plantilla.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';
import 'api_exception.dart';
import 'api_return_codes.dart';
import 'api_routes.dart';

import 'package:book_river/src/config/globals.dart' as globals;

class ApiClient {
  /// Aquí podeu modificar la URL base de server i els temps dels timeouts, entre
  /// d'altres coses.
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://mbookriver.apiabalit2.com/api/v1",
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
    receiveDataWhenStatusError: true,
  ));

  /// Request SigIn
  signIn(Map<String, dynamic> params) async {

    Map<String, dynamic> params1 = {
      "data":jsonEncode(params)
    };

    var _response = await _requestPOST(
      needsAuth: false,
      path: routes["login"],
      formData: params1,
    );

    // Obtenim ReturnCode
    var _rc = _response["rc"];

    // Gestionem les dades segons ReturnCode obtingut
    switch(_rc) {
      case 0:
        if (_response["data"] != null) {
          return _response["data"];
        }
        return null;
      default:
        print("here default: $_rc");
        throw ApiException(getRCMessage(_rc), _rc);
    }
  }

  //register
  register(Map<String, dynamic> params) async {

    Map<String, dynamic> params1 = {
      "data":jsonEncode(params)
    };

    var _response = await _requestPOST(
      needsAuth: false,
      path: routes["sign_in"],
      formData: params1,
    );

    // Obtenim ReturnCode
    var _rc = _response["rc"];

    // Gestionem les dades segons ReturnCode obtingut
    switch(_rc) {
      case 0:
        if (_response["data"] != null) {


          return _response["data"];
        }

        return null;
      default:
        print("here default: $_rc");
        throw ApiException(getRCMessage(_rc), _rc);
    }
  }





  /// EXEMPLE
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  /// Request d'exemple on es poden pujar múltiples imatges amb multipart.
  Future<dynamic> exampleMultipartRequest(
    Map<String, dynamic> params,
    [List<File>? files]
  ) async {
    /// MOLT IMPORTANT!!!
    /// Encodejar els paràmetres del camp data
    Map<String, dynamic> _params = {
      "data": jsonEncode(params),
    };

    // Comprovem si hi ha imatges per pujar i les afegim a un llistat de MultipartFile
    if (files != null) {
      List<MultipartFile> _files = [];

      for(File image in files) {
        _files.add(await MultipartFile.fromFile(
          image.path,
          filename: "${DateTime.now()}${image.path}.png",
          contentType: MediaType('image', 'png'),
        ));
      }

      /// MOLT IMPORTANT!!!
      /// El nom del paràmetre ha de contenir "[]" per indicar que s'envien múltiples
      /// arxius.
      /// Si pel que sigui en el nostre cas el paràmetre té un altre nom, el canviem.
      _params.putIfAbsent("media[]", () => _files);
    }

    var _response = await _requestPOST(
      path: "${routes["example"]}",
      formData: _params,
    );

    // Obtenim ReturnCode
    var _rc = _response["rc"];

    // Gestionem les dades segons ReturnCode obtingut
    switch(_rc) {
      case 0:
        if (_response["data"] != null) {
          return _response["data"];
        }

        return null;
      default:
        throw ApiException(getRCMessage(_rc), _rc);
    }
  }

  /// Realitza una request GET a server.
  /// [needsAuth] indica si la request necessita autorització amb Accesstoken. Per
  /// defecte a [true].
  ///
  /// [path] Part de la URL de la request.
  ///
  /// [params] Paràmetres de la request GET, si en té.
  Future<dynamic> _requestGET({
    bool needsAuth = true,
    String? path,
    Map<String, dynamic>? params,
  }) async {
    try {
      // Realitzem la request
      Response _response = await _dio.get(
        path ?? "",
        queryParameters: params,
        options: Options(
          headers: needsAuth != null
            ? {
              HttpHeaders.authorizationHeader: "Bearer ${UserHelper.accessToken}",
            }
            : null,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      _printResponseDetails(_response);

      // Comprovem status code de la response
      if (_checkResponseStatusCode(_response.statusCode)) {
        // Comprovem si data no és null
        if (_response.data != null) {
          return _response.data;
        }

        return null;
      } else {
        // Si la request ha fallat, retornem [ApiException] en funció del valor
        // de  [_response.statusCode].
        throw ApiException(getRCMessage(_response.statusCode), _response.statusCode);
      }
    } on DioError catch (e) {
      _printDioError(e);
      throw ApiException(getRCMessage(1), 1);
    } catch(e) {
      throw ApiException(getRCMessage(1), 1);
    }
  }

  /// Realitza una request POST a server.
  /// [needsAuth] indica si la request necessita autorització amb Accesstoken. Per
  /// defecte a [true].
  ///
  /// [path] Part de la URL de la request.
  ///
  /// [formData] Paràmetres de la request POST passats per form data, si en té.
  /// En cas de que s'hagi de passar un fitxer en un dels camps, indiquem el
  /// paràmetre així:
  ///   'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
  /// En cas de que s'hagin de passar múltiples fitxers en un dels camps, hauríem
  /// d'indicar el paràmetre com a:
  ///   'files': [
  ///     MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
  ///     MultipartFile.fromFileSync('./example/upload.txt', filename: 'upload.txt'),
  ///   ]
  /// [getParams] paràmetres que es passarien com a paràmetres d'una request GET.
  /// Per exemple, en el cas de que una paginació s'hagués de fer per POST.
  Future<dynamic> _requestPOST({
    bool needsAuth = true,
    String? path,
    Map<String, dynamic>? formData,
    Map<String, dynamic>? getParams,
  }) async {
    try {
      // Realitzem la request
      Response _response = await _dio.post(
        path ?? "",
        data: formData != null
          ? FormData.fromMap(formData)
          : null,
        queryParameters: getParams ?? null,
        options: Options(
          headers: needsAuth != null
            ? {
              HttpHeaders.authorizationHeader: "Bearer ${UserHelper.accessToken}",
            }
            : null,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      _printResponseDetails(_response);

      // Comprovem status code de la response
      if (_checkResponseStatusCode(_response.statusCode)) {
        // Comprovem si data no és null
        if (_response.data != null) {
          return _response.data;
        }

        return null;
      } else {
        // Si la request ha fallat, retornem [ApiException] en funció del valor
        // de  [_response.statusCode].
        throw ApiException(getRCMessage(_response.statusCode), _response.statusCode);
      }
    } on DioError catch (e) {
      _printDioError(e);
      throw ApiException(getRCMessage(1), 1);
    } on FormatException catch (e) {
      print("::.. on errorino");
    } catch(e) {
      print("::.. on errorinos : ${e}");
      throw ApiException(getRCMessage(1), 1);
    }
  }

  /// Realitza una request PATCH a server.
  Future<dynamic> _requestPATCH({
    bool needsAuth = true,
    String? path,
    Map<String, dynamic>? formData,
    Map<String, dynamic>? getParams,
  }) async {
    try {
      // Realitzem la request
      Response _response = await _dio.patch(
        path ?? "",
        data: formData != null
          ? FormData.fromMap(formData)
          : null,
        queryParameters: getParams ?? null,
        options: Options(
          headers: needsAuth != null
            ? {
              HttpHeaders.authorizationHeader: "Bearer ${UserHelper.accessToken}",
            }
            : null,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      _printResponseDetails(_response);

      // Comprovem status code de la response
      if (_checkResponseStatusCode(_response.statusCode)) {
        // Comprovem si data no és null
        if (_response.data != null) {
          return _response.data;
        }

        return null;
      } else {
        // Si la request ha fallat, retornem [ApiException] en funció del valor
        // de  [_response.statusCode].
        throw ApiException(getRCMessage(_response.statusCode), _response.statusCode);
      }
    } on DioError catch (e) {
      _printDioError(e);
      throw ApiException(getRCMessage(1), 1);
    } on FormatException catch (e) {
      print("::.. on errorino");
    } catch(e) {
      print("::.. on errorinos : ${e}");
      throw ApiException(getRCMessage(1), 1);
    }
  }

  /// Realitza una request DELETE a server.
  Future<dynamic> _requestDELETE({
    bool needsAuth = true,
    String? path,
    Map<String, dynamic>? formData,
    Map<String, dynamic>? getParams,
  }) async {
    try {
      // Realitzem la request
      Response _response = await _dio.delete(
        path ?? "",
        data: formData != null
          ? FormData.fromMap(formData)
          : null,
        queryParameters: getParams ?? null,
        options: Options(
          headers: needsAuth != null
            ? {
              HttpHeaders.authorizationHeader: "Bearer ${UserHelper.accessToken}",
            }
            : null,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );

      _printResponseDetails(_response);

      // Comprovem status code de la response
      if (_checkResponseStatusCode(_response.statusCode)) {
        // Comprovem si data no és null
        if (_response.data != null) {
          return _response.data;
        }

        return null;
      } else {
        // Si la request ha fallat, retornem [ApiException] en funció del valor
        // de  [_response.statusCode].
        throw ApiException(getRCMessage(_response.statusCode), _response.statusCode);
      }
    } on DioError catch (e) {
      _printDioError(e);
      throw ApiException(getRCMessage(1), 1);
    } on FormatException catch (e) {
      print("::.. on errorino");
    } catch(e) {
      print("::.. on errorinos : ${e}");
      throw ApiException(getRCMessage(1), 1);
    }
  }

  /// Debug purposes
  void _printResponseDetails(Response r) {
    print(":.URL: ${r.realUri}");
    if (r.requestOptions.data != null) {
      //print(":.Params: ${r.requestOptions?.data}");
      print(":.Params: ${jsonEncode(
          Map.fromIterable(
              r.requestOptions.data?.fields,
              key: (e) => e.key,
              value: (e) => e.value)
      )}");
    }

    print(jsonEncode(r.data));

  }

  /// Debug purposes
  void _printDioError(DioError e) {
    print(":. DIOErr: ${e.error}");
    print(":. URL: ${e.response?.realUri}");

    // Comprovem si la request té paràmetres, per fer print
    if (e.requestOptions.data != null) {
      //print(":.Params: ${e.requestOptions?.data}");
      print(":.Params: ${jsonEncode(
        Map.fromIterable(
          e.requestOptions.data?.fields,
          key: (e) => e.key,
          value: (e) => e.value
        )
      )}");
    }
    print(jsonEncode(e.response?.data));
  }
  
  /// Comprova el valor del StatusCode rebut en una response.
  /// En cas de [statusCode] entre valors 2xx --> response correcta.
  bool _checkResponseStatusCode(int? statusCode) {
    if (statusCode != null) {
      if (statusCode >= 200 && statusCode <= 299) {
        return true;
      }
    }
    return false;
  }

  /// Retorna el missatge d'error en funció del [RC] (ReturnCode) indicat per
  /// paràmetres.
  String? getRCMessage(int? rc) {
    // Agafem string traduccions
    String? returnMessage = returnCodes[rc!];

    if (returnMessage != null) {
      return returnMessage;
    }else{
      return returnCodes[1];
    }
  }
}
