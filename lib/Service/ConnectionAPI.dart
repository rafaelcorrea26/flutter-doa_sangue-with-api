import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

const _Url = "http://192.168.1.120:8000/api/";

class ConnectionAPI {
  Future<String> pegaToken() async {
    var _url = Uri.parse(_Url + 'login');
    var _email = 'rafael@gmail.com';
    var _senha = '1234';

    _url = _url.replace(queryParameters: {'email': _email, 'senha': _senha});
    print(_url);
    var response = await http.post(_url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body)["access_token"];
    } else {
      return "";
    }
  }
}
