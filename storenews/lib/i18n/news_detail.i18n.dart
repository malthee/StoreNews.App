import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {"en_us": "last changed %s"} +
      {"en_us": "This item has expired and is no longer valid!"} +
      {"en_us": "Details"};

  String fill(List<Object> params) => localizeFill(this, params);

  String get i18n => localize(this, _t);
}
