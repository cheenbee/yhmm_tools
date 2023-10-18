import 'package:dio/dio.dart';

/// 默认dio配置
int _connectTimeout = 15000;
int _receiveTimeout = 15000;
int _sendTimeout = 10000;
String _baseUrl = '';
List<Interceptor> _interceptors = [];

/// 初始化Dio配置
void configDio({
  int? connectTimeout,
  int? receiveTimeout,
  int? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
}) async {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
}

// typedef NetSuccessCallback<T> = Function(T data);
// typedef NetSuccessListCallback<T> = Function(List<T> data);
// typedef NetErrorCallback = Function(int code, String msg);

class DioUtils {
  factory DioUtils() => _singleton;
  static final DioUtils _singleton = DioUtils._();
  static DioUtils get instance => DioUtils();
  static late Dio _dio;
  Dio get dio => _dio;

  DioUtils._() {
    final BaseOptions options = BaseOptions(
      connectTimeout: Duration(milliseconds: _connectTimeout),
      receiveTimeout: Duration(milliseconds: _receiveTimeout),
      sendTimeout: Duration(milliseconds: _sendTimeout),

      /// dio默认json解析，这里指定返回UTF8字符串，自己处理解析。（可也以自定义Transformer实现）
      responseType: ResponseType.plain,

      baseUrl: _baseUrl,
    );
    _dio = Dio(options);
  }
}
