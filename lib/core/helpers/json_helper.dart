import 'dart:convert';

class JSON {
  static dynamic jsonDecode(String source) {
    return json.decode(source);
  }

  static String jsonEncode(dynamic object) {
    return json.encode(object);
  }
}