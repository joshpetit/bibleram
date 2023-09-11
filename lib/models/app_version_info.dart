import 'package:bibleram/hidden_confs.dart';

class AppVersionInfo {
  static const String appVersion = "1.1.0";
  static const String isarSchemeVersion = "0.1";
  static const String serializationVersion = "0.2";
  static const String translationsVersions = "0.2";

  static String infoAsString() {
    return """
    AppVersionInfo: [
    appVersion: $appVersion,
    isarSchemeVersion: $isarSchemeVersion,
    serializationVersion: $serializationVersion,
    translationsVersions: $translationsVersions
    ]
""";
  }
}

const availableVersions = [
  ...hiddenTranslations,
  "KJV",
  "WEB",
];
