import 'package:flutter/material.dart';
import 'package:yhmm/http/dio_utils.dart';

import 'routes/routers.dart' as r;

void main() async {
  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  configDio();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: r.Routers.router(),
    );
  }
}
