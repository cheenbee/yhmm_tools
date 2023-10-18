// import 'package:dio/dio.dart';
// import 'package:yhmm/http/dio_utils.dart';

import 'package:http/http.dart' as http;

class MdfService {
  Future<String?> getWebHtmlString(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work

      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });
    // var response = await DioUtils.instance.dio.get<String>(url);

    return response.body.toString();
  }
}
