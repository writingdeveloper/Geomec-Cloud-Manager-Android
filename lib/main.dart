import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';
import 'shared/shared.dart';
import 'pages/pages.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ConnectionModel()),
        ChangeNotifierProvider(builder: (context) => HomeModel()),
        ChangeNotifierProvider(builder: (context) => CustomTheme()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  bool _automaticThemeIsLight = false;

  Brightness _getStatusBarIconBrightness(CustomTheme themeModel) {
    themeModel.getThemeValue().then((themeValue) {
      if (themeValue == "automatic") {
        return _automaticThemeIsLight ? Brightness.dark : Brightness.light;
      } else if (themeValue == "light") {
        return Brightness.dark;
      } else {
        return Brightness.light;
      }
    });
    return null;
  }
  // TODO : 기본설정 함수 제거후 강제 Dark 테마 설정으로 불필요. settings.dart와도 연관이 있음
  ThemeData _getLightTheme(CustomTheme themeModel) {
    if (themeModel.themeValue == "dark") {
      return CustomThemes.dark;
    } else if (themeModel.themeValue == "black") {
      return CustomThemes.black;
    } else {
      _automaticThemeIsLight = true;
      return CustomThemes.light;
    }
  }

  ThemeData _getDarkTheme(CustomTheme themeModel) {
    if (themeModel.themeValue == "light") {
      _automaticThemeIsLight = true;
      return CustomThemes.light;
    } else if (themeModel.themeValue == "black") {
      return CustomThemes.black;
    } else {
      return CustomThemes.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeModel = Provider.of<CustomTheme>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: _getStatusBarIconBrightness(themeModel),
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'Geomec Cloud Manager',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
      // theme: _getLightTheme(themeModel),
      theme: _getDarkTheme(themeModel), // 기본 테마 설정 Dark
      darkTheme: _getDarkTheme(themeModel),
    );
  }
}
