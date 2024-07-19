import 'dart:convert';

import 'package:capstone/utils/constants.dart';
import 'package:http/http.dart' as http;

class WastePracticesService {
  static Future<List<String>> fetchVideoUrls() async {
    final response =
        await http.get(Uri.parse(Constants.wastePracticesEndpoint));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['videos'];
      return data.map((url) => url.toString()).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
