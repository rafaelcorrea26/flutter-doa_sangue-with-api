import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doa_sangue/View/LoginPage.dart';
import 'package:flutter/material.dart';

const supportedLocales = [
  Locale('pt', 'BR'),
  Locale('en', 'US'),
];

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Aplicativo de doação de sangue",
      home: LoginPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt', 'BR'),
        const Locale('en', 'US'),
      ],
    ),
  );
}
