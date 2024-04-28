import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class YantaApi {
  String baseUrl = "flutter-assessment-backend-rioz.onrender.com";

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
