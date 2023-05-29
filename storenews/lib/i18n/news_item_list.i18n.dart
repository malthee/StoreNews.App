import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {"en_us": "Unknown"} +
      {"en_us": "Older"} +
      {"en_us": "Hours ago"} +
      {"en_us": "A few minutes ago"} +
      {"en_us": "Just now"} +
      {"en_us": "seen %s"} +
      {"en_us": "No news items available"} +
      {"en_us": "Visit some locations and make sure scanning is enabled."};

  String fill(List<Object> params) => localizeFill(this, params);

  String get i18n => localize(this, _t);
}
