import 'package:dio/dio.dart';
import 'package:webclient/data/network/api/endpoints.dart';
import 'package:webclient/data/network/dio_client.dart';

class AuthenticationApi {
  final DioClient dioClient;

  AuthenticationApi({required this.dioClient});

  Future<Response> signIn(String username, String password) async {
    try {
      final Response response =
          await dioClient.post(Endpoints.user + Endpoints.login, data: {
        'username': username,
        'password': password,
      });

      String csrftoken = response.headers["Set-Cookie"]![0]!.split(";")[0].split("=")[1];
      String sessionid = response.headers["Set-Cookie"]![1]!.split(";")[0].split("=")[1];
      dioClient.updateCookie(csrftoken, sessionid);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> signOut() async {
    try {
      final Response response =
      await dioClient.post(Endpoints.user + Endpoints.logout);
      dioClient.clearCookie();
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
