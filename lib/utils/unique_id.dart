import 'package:flutter_udid/flutter_udid.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class UniqueId {
  // because I don't know how personal is the id which you get from
  // FlutterUdid I decided to also hash it with the app id in order
  // to create a more meaningless string, thus if somebody gets this id
  // it will be 100% useless because is still hard to reverse a hash
  // even if you have over half of the answer
  // better be secure than sorry
  static Future<String> getId() async {
    const String appId = "speed_cube_timer";
    String udid = await FlutterUdid.udid;
    return sha256.convert(utf8.encode(udid + appId)).toString();
  }
}