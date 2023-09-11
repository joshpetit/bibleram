import 'package:bibleram/main.dart';
import 'package:bibleram/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(super.initialState);
  void setTheme(ThemeMode theme) {
    emit(theme);
    sharedPreferences.setString("theme", theme.title);
  }
}
