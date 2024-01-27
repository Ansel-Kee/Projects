import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashString({required String data}) {
  var bytes1 = utf8.encode(data);
  String digest1 = sha256.convert(bytes1).toString();
  return digest1;
}
