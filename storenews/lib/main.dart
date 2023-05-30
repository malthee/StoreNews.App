import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:storenews/store_news_app.dart';
import 'package:storenews/util/service_setup.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StoreNewsApp());
  registerServices(getIt);
}
