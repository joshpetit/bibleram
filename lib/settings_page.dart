// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/app_version_info.dart';
import 'package:bibleram/theme_cubit.dart';
import 'package:bibleram/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_storage/shared_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    List<BibleRamSetting> settings = [
      BibleRamSetting(
        title: 'Export Data',
        subtitle:
            'Please occasionally backup the app! This will require you to give Bible Ram file permissions.',
        buttonText: 'Export',
        icon: Icons.upload,
        callback: () async {
          var appCubit = BlocProvider.of<AppCubit>(context);
          Uri? selectedURI;
          String? outputDir;
          if (Platform.isIOS) {
            outputDir = await FilePicker.platform.getDirectoryPath(
              dialogTitle:
                  'Please select an output directory for "bibleram-data.json"',
            );
            if (outputDir == null) {
              return;
            }
          } else {
            await requestPermissions();
            selectedURI = await openDocumentTree();
            if (selectedURI == null) {
              return;
            }
          }
          try {
            await appCubit.exportData(outputDir, selectedURI);
          } catch (e) {
            logger.e("Error exporting data: $e");
            showSnackBar(context, message: "Error exporting data");
            return;
          }
          showSnackBar(context, message: "Data exported ✅");
        },
      ),
      BibleRamSetting(
        title: 'Import Data',
        subtitle:
            'Import a file with your memorization data, this will be merged with any passages you have loaded',
        buttonText: 'Import',
        icon: Icons.download,
        callback: () async {
          var appCubit = BlocProvider.of<AppCubit>(context);
          if (!Platform.isIOS) {
            await requestPermissions();
          }
          try {
            FilePickerResult? results = await FilePicker.platform.pickFiles(
              dialogTitle:
                  'Please select an output directory for "bibleram-data.json"',
              allowMultiple: false,
            );
            if (results == null) {
              return;
            }
            if (results.files.isEmpty) {
              return;
            }
            var file = results.files[0];
            if (file.path == null) {
              throw Exception();
            }
            var realFile = File(file.path!);

            showSnackBar(context, message: "Starting import...");
            await appCubit.importData(realFile);
          } catch (e) {
            logger.e("Error importing data: $e");
            showSnackBar(context, message: "Error importing data");
            return;
          }
          showSnackBar(context, message: "Data imported ✅");
        },
      ),
      BibleRamSetting(
        title: 'Delete Data',
        subtitle:
            'Is the app taking up too much space? Want a fresh start? You can get a slate by clearing your data.',
        buttonText: 'Clear',
        icon: Icons.delete_forever,
        callback: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "Are you sure? Make sure to export your data if you are not.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await BlocProvider.of<AppCubit>(context).clearData();
                        await notificationService.clearNotifications();
                        showSnackBar(context, message: "Data cleared");
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          color: colorScheme.red,
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
        buttonColor: colorScheme.red,
      ),
      BibleRamSetting(
        title: 'About',
        subtitle:
            'View the app licenses, copyright information, and other info',
        buttonText: 'View',
        icon: Icons.notes,
        callback: () {
          showAboutDialog(
            context: context,
            applicationName: "Bible Ram",
            applicationVersion: AppVersionInfo.appVersion,
            children: [
              Text(
                "Bible ram is a 100% free scripture memorization application to help equip users with the most powerful weapon (Hebrews 4:12)\n",
              ),
              Text(
                "All translations used within this app have been used with the consent of the publishers\n\n",
              ),
              Text(
                "Logo created by Elisha!",
              ),
            ],
            applicationIcon: Image(
              width: 50,
              height: 50,
              image: AssetImage("assets/icons/app_icon_v1.png"),
            ),
          );
        },
      ),
      BibleRamSetting(
        title: 'Send Testimony',
        subtitle:
            'Do you think this app is cool??? Click on this button to send me an email about how this app has helped you',
        buttonText: 'View',
        icon: Icons.favorite,
        buttonColor: colorScheme.red,
        callback: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(
                    "I pray daily that this app helps you to grow in your faith. \n\nIf you'd like to send me a testimony (or report a bug) you can reach me at joshua@petit.dev. \n\nIf you want to see what else goes on in my life, give me a follow on instagram @josh.petitma!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await launchUrl(
                            Uri.parse(
                                "https://www.instagram.com/josh.petitma/"),
                            mode: LaunchMode.externalApplication);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Follow on Instagram",
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        sendThankyouEmail();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Send Testimony via Email",
                        style: TextStyle(
                          color: colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
      ),
      BibleRamSetting(
        title: 'Send bug report',
        subtitle:
            'Opens up your email client with information that would help me fix the bug',
        buttonText: 'Send',
        icon: Icons.bug_report,
        callback: () {
          sendErrorReport();
        },
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return Container(
                  color: colorScheme.tertiaryContainer,
                  height: 1,
                );
              },
              itemCount: settings.length,
              itemBuilder: (context, index) {
                var setting = settings[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(16),
                  onTap: setting.callback,
                  title: Text(setting.title),
                  subtitle: Text(
                    setting.subtitle,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
            child: Row(
              children: [
                Text("Theme: "),
                BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, theme) {
                  return DropdownButton(
                    value: theme,
                    onChanged: (newTheme) {
                      BlocProvider.of<ThemeCubit>(context)
                          .setTheme(newTheme ?? ThemeMode.system);
                    },
                    items: ThemeMode.values
                        .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e.title)))
                        .toList(),
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendErrorReport() async {
    var cubit = BlocProvider.of<AppCubit>(context);
    logger.e("App state:\n ${cubit.state.toString()}");
    final Email email = Email(
      recipients: ["joshua@petit.dev"],
      body: "Describe what you were doing and what error you received:\n",
      subject: "Bible Ram - Error report",
      attachmentPaths: [logger.file.path],
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Thanks for your help 🔥';
    } catch (error) {
      print(error);
      platformResponse =
          "Error sending email, make sure your mail client is setup";
      logger.e(error);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  Future<void> sendThankyouEmail() async {
    final Email email = Email(
      recipients: ["joshua@petit.dev"],
      body: "",
      subject: "Bible Ram - Testimony!",
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Thanks for the love';
    } catch (error) {
      print(error);
      platformResponse =
          "Error sending email, make sure yout mail client is setup";
      logger.e(error);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  Future<bool> requestPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    } else {
      return true;
    }
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }

    if (await Permission.storage.isDenied) {
      return false;
    }
    return true;
  }
}

class BibleRamSetting {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final VoidCallback callback;
  final VoidCallback? longPress;
  final Color? buttonColor;

  BibleRamSetting({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.callback,
    this.buttonColor,
    this.longPress,
  });
}

extension ThemeModeExtension on ThemeMode {
  String get title => switch (this) {
        ThemeMode.dark => "Dark",
        ThemeMode.light => "Light",
        ThemeMode.system => "System",
      };
}

ThemeMode themeFromString(String theme) => switch (theme) {
      "Dark" => ThemeMode.dark,
      "Light" => ThemeMode.light,
      "System" => ThemeMode.system,
      _ => ThemeMode.system,
    };
