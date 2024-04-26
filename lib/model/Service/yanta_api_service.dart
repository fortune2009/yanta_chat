import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class YantaApi {
  // String endpoint = "api.thecatapi.com";
  String baseUrl = "flutter-assessment-backend-rioz.onrender.com";
  // Future<Either<Exception, String>> getRandomCatPhoto() async {
  //   try {
  //     final queryParameters = {
  //       "api_key": "b2946522-3425-4baa-a206-2444df3af659",
  //     };
  //     final uri = Uri.https(endpoint, "/v1/images/search", queryParameters);
  //     final response = await http.get(uri);
  //     return Right(response.body);
  //   } catch (e) {
  //     return (Left(e));
  //   }
  // }

  Future<Either<Exception, String>> getApi(String path) async {
    try {
      final uri = Uri.https(baseUrl, path);
      final response = await http.get(uri);
      return Right(response.body);
    } on Exception catch (e) {
      return (Left(e));
    }
  }
}
