import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_dbhg/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> languages = [
      AppLocalizations.of(context)!.english,
      AppLocalizations.of(context)!.spanish,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (kDebugMode) {
                print(index);
              }
              if (index == 0) {
                MovieApp.of(
                  context,
                ).setLocale(Locale.fromSubtags(languageCode: 'en'));
              } else {
                MovieApp.of(
                  context,
                ).setLocale(Locale.fromSubtags(languageCode: 'es'));
              }
            },
            child: ListTile(title: Text(languages[index])),
          );
        },
      ),
    );
  }
}
