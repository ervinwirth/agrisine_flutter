import 'package:flutter/material.dart';
import '/src/data/app_database.dart';
import 'create_project_screen.dart';
import 'project_list_screen.dart';
import 'l10n/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default language is English

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: _locale,
      onGenerateTitle: (BuildContext context) => S.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) => MyHomePage(
          onLanguageChanged: (Locale locale) => setLocale(locale),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const MyHomePage({Key? key, required this.onLanguageChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).homeTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/agrisix_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectListScreen(database: database),
                  ),
                );
              },
              child: Text(S.of(context).myProjects),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateProjectScreen(database: database),
                  ),
                );
              },
              child: Text(S.of(context).addNewProject),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showLanguagePicker(context),
              child: Text(S.of(context).changeLanguage),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).changeLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.of(context).pop();
                  onLanguageChanged(const Locale('en'));
                },
              ),
              ListTile(
                title: const Text('Magyar'),
                onTap: () {
                  Navigator.of(context).pop();
                  onLanguageChanged(const Locale('hu'));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
