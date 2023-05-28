import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class NewsNotificationManager extends Disposable {
  static final logger = GetIt.I<Logger>();

  bool appInForeground = true;

  @override
  FutureOr onDispose() {
    // TODO: implement onDispose
    throw UnimplementedError();
  }

}