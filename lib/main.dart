import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_viewer/application.dart';
import 'package:rick_and_morty_viewer/bloc/CharacterBlock.dart';
import 'package:rick_and_morty_viewer/resources/style.dart';
import 'package:rick_and_morty_viewer/ui/screens/character/CharacterPage.dart';
import 'package:rick_and_morty_viewer/ui/screens/character_list/CharacterListPage.dart';
import 'package:rick_and_morty_viewer/ui/screens/characters_for_episode/CharacterForSth.dart';
import 'package:rick_and_morty_viewer/ui/screens/episodes/EpisodesPage.dart';
import 'package:rick_and_morty_viewer/ui/screens/locations/LocationsPage.dart';

import 'util/localization/app_translations_delegate.dart';

void main() {
  _runApp();
}

Future <void> _runApp() async {
  Intl.defaultLocale = 'en';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<CharacterBlock>(
      create: (ctx) => CharacterBlock(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeStyle().theme,
        home: CharacterListPage(),
        routes: {
          CharacterPage.route: (ctx) => CharacterPage(),
          EpisodesPage.route: (ctx) => EpisodesPage(),
          LocationsPage.route: (ctx) => LocationsPage(),
          CharacterForSthPage.route: (ctx) => CharacterForSthPage()
        },
          localizationsDelegates: [
            const AppTranslationsDelegate(),
            //provides localised strings
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            //provides RTL support
            GlobalWidgetsLocalizations.delegate,
          ],
        supportedLocales: application.supportedLocales(),
      ),
    );
  }
}
