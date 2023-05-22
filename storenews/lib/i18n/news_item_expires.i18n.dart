import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {"en_us": "Expires on %s"} +
      {"en_us": "Expired on %s"} +
      {"en_us": "Never expires"};

  String fill(List<Object> params) => localizeFill(this, params);

  String get i18n => localize(this, _t);
}
