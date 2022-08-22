import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class NetwokUtils {
  static Future<dynamic> postRequest(url, payload,
      {isAuth = true, token}) async {
    //print("connection started");
    try {
      var post = await http
          .post(
        Uri.parse(url),
        headers: isAuth
            ? {
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
              }
            : {
                "Accept": "application/json",
                "Content-Type": "application/json",
              },
        body: json.encode(payload),
      )
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Check your internet and try again!');
      });

      var response = json.decode(post.body);
      print(post.statusCode);
      print(response);

      if (post.statusCode != 200 && post.statusCode > 209) {
        if (post.statusCode == 422) {
          var keys = response["error"].keys.toList()[0];
          //print(response["error"][keys][0]);
          throw HttpException(response["error"][keys][0]);

          // var errormesage = response["error"][msg[0]];
          // throw HttpException(errormesage[0]);
        } else {
          throw HttpException(response["message"]);
        }
      } else {
        return response;
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  static Future<dynamic> getRequest(url) async {
    try {
      var post = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      }).timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Check your internet and try again!');
      });

      var response = json.decode(post.body);
      print(post.statusCode);
      print(response);

      if (post.statusCode != 200 && post.statusCode > 209) {
        // if (post.statusCode == 422) {
        //   var keys = response["error"].keys.toList()[0];
        //   print(response["error"][keys][0]);
        //   throw HttpException(response["error"][keys][0]);
        // } else {
        //   throw HttpException(response["message"]);
        // }
        throw HttpException(response["message"]);
      } else {
        return response;
      }
    } on Exception catch (e) {
      throw e;
    }
  }
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message); // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}
