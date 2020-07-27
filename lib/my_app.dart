import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:note_book_flutter_app/localization/demo_localization.dart';
import 'package:note_book_flutter_app/screens/note_list.dart';

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext buildContext, Locale locale) {
    _MyAppState state = buildContext.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale local) {
    setState(() {
      this._locale = local;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteBook",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan, brightness: Brightness.dark),
      locale: _locale,
      localizationsDelegates: [
        DemoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('ar', '🇪🇬'), // Hebrew, no country code
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocales.first;
      },
      home: NoteList(),
    );
  }
}
