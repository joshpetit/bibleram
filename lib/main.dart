import 'dart:async';
import 'dart:io';

import 'package:bibleram/add_passage_page/add_passage_cubit.dart';
import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/home_page.dart';
import 'package:bibleram/logging.dart';
import 'package:bibleram/models/app_version_info.dart';
import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/models/passage_set.dart';
import 'package:bibleram/models/practice_reminder.dart';
import 'package:bibleram/services/notification_service.dart';
import 'package:bibleram/settings_page.dart';
import 'package:bibleram/theme_cubit.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart' as path_lib;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'models/verse_being_memorized.dart';

late NotificationService notificationService;
late SharedPreferences sharedPreferences;
late Isar isar;
late FileLoggerOutput logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL-LATO.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/OFL-NOTO.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('licenses/nkjv.txt');
    yield LicenseEntryWithLineBreaks(['nkjv'], license);
  });
  logger = FileLoggerOutput();
  // I freaking hate useless abstractions that make it hard to use libraries
  await logger.realInit();
  sharedPreferences = await SharedPreferences.getInstance();
  var previousTranslationVersion =
      sharedPreferences.get("translationsVersions");
  notificationService = NotificationService();
  await notificationService.initialize();
  final dir = await path_lib.getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [
      VerseBeingMemorizedSchema,
      PassageBeingMemorizedSchema,
      PracticeReminderSchema,
      PassageSetSchema,
    ],
    directory: dir.path,
    inspector: kReleaseMode ? false : true,
  );

  try {
    await installBibleDatabases(
        reinstallNKJV: previousTranslationVersion == "0.1");
  } catch (e) {
    logger.e(e);
  }
  cacheAppVersion();
  FlutterError.onError = (error) {
    logger
        .e("error: ${error.exceptionAsString()}\n stacktrace: ${error.stack}");
    print("Error");
    print("----------------------");
    print("Error :  ${error.exception}");
    print("StackTrace :  ${error.stack}");
  };
  runApp(const MyApp()); // starting point of app
}

void cacheAppVersion() {
  sharedPreferences.setString(
      "isarSchemaVersion", AppVersionInfo.isarSchemeVersion);
  sharedPreferences.setString(
      "serializationVersion", AppVersionInfo.serializationVersion);
  sharedPreferences.setString(
      "translationsVersions", AppVersionInfo.translationsVersions);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (_) => AppCubit(sharedPreferences: sharedPreferences),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(
            themeFromString(
              sharedPreferences.getString("theme") ?? "system",
            ),
          ),
        ),
        BlocProvider<AddPassageCubit>(
          create: (_) => AddPassageCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, theme) {
          return MaterialApp(
            navigatorObservers: [ClearFocusOnPop()],
            title: 'Flutter Demo',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              tabBarTheme: TabBarTheme(
                  labelColor: Colors.black, unselectedLabelColor: Colors.grey),
              timePickerTheme: TimePickerThemeData(
                dialTextColor: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
              ),
              colorScheme: ThemeData.light().colorScheme.copyWith(
                    primary: Color(0xFFc2dfff),
                    onPrimary: Colors.black,
                    secondary: Color(0xFFDDFFC2),
                    onSecondary: Colors.black,
                    secondaryContainer: Color(0xFF00AD07),
                    tertiary: Color(0xFFFAA0A0),
                    tertiaryContainer: Color(0xFFCFCFC4),
                    onTertiaryContainer: Colors.black,
                    background: Colors.white,
                    onBackground: Colors.black,
                  ),
              useMaterial3: false,
              textTheme: GoogleFonts.latoTextTheme(),
            ),
            darkTheme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF303030),
                elevation: 0,
              ),
              timePickerTheme: TimePickerThemeData(
                dialTextColor: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
              colorScheme: ThemeData.dark().colorScheme.copyWith(
                    primary: Color(0xFF1C1C1C),
                    onPrimary: Color(0xFFFFFFFF),
                    secondary: Color(0XFF7A7A7A),
                    onSecondary: Colors.white,
                    secondaryContainer: Color(0xFF00AD07),
                    tertiary: Color(0xFFFF6961),
                    tertiaryContainer: Color(0XFFCFCFC4),
                    onTertiaryContainer: Colors.black,
                    background: Color(0xFF303030),
                    onBackground: Colors.white,
                    surface: Color(0xFF424242),
                    onSurface: Colors.white,
                  ),
            ),
            themeMode: theme,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

Future<void> installBibleDatabases({bool reinstallNKJV = false}) async {
  var databasesPath = await getDatabasesPath();
  var nkjvPath = path_lib.join(databasesPath, "nkjv.db");
  var kjvPath = path_lib.join(databasesPath, "kjv.db");
  var webPath = path_lib.join(databasesPath, "web.db");
  var nkjvExists = await databaseExists(nkjvPath);
  var kjvExists = await databaseExists(kjvPath);
  var webExists = await databaseExists(webPath);

  if (!nkjvExists || !kjvExists || !webExists || reinstallNKJV) {
    logger.e("Creating new copy from asset");

    try {
      await Directory(path_lib.dirname(nkjvPath)).create(recursive: true);
    } catch (e) {
      logger.e("Could not create path for bible databases: $e");
    }

    ByteData data;
    List<int> bytes;

    if (!nkjvExists || reinstallNKJV) {
      ByteData data = await rootBundle
          .load(path_lib.join("assets", "translations", "nkjv.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(nkjvPath).writeAsBytes(bytes, flush: true);
      logger.e("Succesfully installed nkjv");
    }

    if (!kjvExists) {
      data = await rootBundle
          .load(path_lib.join("assets", "translations", "kjv.db"));
      bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(kjvPath).writeAsBytes(bytes, flush: true);
      logger.e("Succesfully installed kjv");
    }

    if (!webExists) {
      data = await rootBundle
          .load(path_lib.join("assets", "translations", "web.db"));
      bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(webPath).writeAsBytes(bytes, flush: true);
      logger.e("Succesfully installed web");
    }
  }
}

extension MoreColors on ColorScheme {
  Color get red => Color(0xFFFF6961);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
  BuildContext context, {
  required String message,
  Duration? duration,
  bool useDuration = true,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? const Duration(seconds: 2),
    ),
  );
}

extension GetCubits on State {
  AppCubit get appCubit => BlocProvider.of<AppCubit>(context);
}
