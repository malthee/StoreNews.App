import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {"en_us": "Permissions required"} +
      {"en_us": "StoreNews needs location permissions always on in order to get the latest news."} +
      {"en_us": "OK"} +
      {"en_us": "Open Settings"};

  String fill(List<Object> params) => localizeFill(this, params);

  String get i18n => localize(this, _t);
}
