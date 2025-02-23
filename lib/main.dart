import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:movies_dbhg/view/screen/movie_screen.dart';
import 'package:movies_dbhg/view_model/movie_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // Setting the name of the database
  await Hive.openBox('MovieService');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MovieApp());
  });
}

class MovieApp extends StatefulWidget {
  const MovieApp({super.key});
  static MovieAppState of(BuildContext context) {
    return context.findAncestorStateOfType<MovieAppState>()!;
  }

  @override
  MovieAppState createState() => MovieAppState();
}

class MovieAppState extends State<MovieApp> {
  late Locale _locale = Locale('en');

  // Method to set the locale
  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  // Method to get current the locale
  String getLocale() {
    return _locale.languageCode;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: MovieViewModel())],
      child: MaterialApp(
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('es'), // Spanish
        ],
        debugShowCheckedModeBanner: false,
        title: AppLocalizations.of(context)?.movies,
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.dark,
        home: MovieScreen(),
      ),
    );
  }
}
