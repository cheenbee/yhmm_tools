import 'package:go_router/go_router.dart';
import 'package:yhmm/pages/home_page.dart';

import '../utils/constants.dart';

const String home = '/';

class Routers {
  static GoRouter router() {
    List<RouteBase> _listRouter = [];

    var loginRouter = GoRoute(
      path: home,
      builder: (context, state) {
        return const HomePage();
      },
    );
    _listRouter.add(loginRouter);

    return GoRouter(
      routes: _listRouter,
      navigatorKey: C.navigatorKey,
    );
  }
}
