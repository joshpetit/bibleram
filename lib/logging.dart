import 'dart:io';
import 'package:bibleram/models/app_version_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_lib;

class FileLoggerOutput {
  late final File file;

  Future<void> realInit() async {
    final dir = await path_lib.getApplicationDocumentsDirectory();
    var filePath = join(dir.path, "session_logs");
    file = File(filePath);
    await file.writeAsString("App Version: ${AppVersionInfo.infoAsString()}",
        mode: FileMode.writeOnly);
  }

  Future<void> e(Object event) async {
    var string = event.toString();
    for (var line in string.split("\n")) {
      await file.writeAsString(
        "$line\n",
        mode: FileMode.writeOnlyAppend,
      );
    }
  }
}
