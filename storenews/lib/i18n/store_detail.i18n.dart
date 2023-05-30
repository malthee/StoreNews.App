import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {"en_us": "Latest news from this store"} +
      {"en_us": "Error loading store"} +
      {"en_us": "Error loading news items"};

  String get i18n => localize(this, _t);
}
