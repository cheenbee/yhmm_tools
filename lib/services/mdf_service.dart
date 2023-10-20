import 'package:yhmm/http/dio_utils.dart';

class MdfService {
  Future<String?> getWebHtmlString(String url) async {
    var response = await DioUtils.instance.dio.get<String>(url);

    return response.data.toString();
  }
}
