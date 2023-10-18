import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

class Utils {
  static final keyboard = _Keyboard();
  static final toast = _Toast();

  static showToast({String msg = ''}) {
    toast.showToast(msg: msg);
  }

  static back(BuildContext context) {
    context.pop();
  }
}

class _Toast {
  showToast({String msg = ''}) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }
}

class _Keyboard {
  ///隐藏软键盘
  ///[context] 上下文
  hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
