import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '/src/data/app_database.dart';
import 'create_project_screen.dart';
import 'project_list_screen.dart';
import 'l10n/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

  const MyHomePage({super.key, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();

    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Replace the logo with styled text
            Text(
              'Agrisine',
              style: const TextStyle(
                color: Colors.white, // White color
                fontSize: 32, // Adjust font size as needed
                fontStyle: FontStyle.italic, // Italic style
                fontWeight: FontWeight.bold, // Optional: Bold for emphasis
              ),
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
            const SizedBox(height: 20), // Add some space before the new button
            ElevatedButton(
              onPressed: () async {
                await deleteDatabaseFile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Database'),
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

Future<void> deleteDatabaseFile() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'app.db'));
  if (await file.exists()) {
    await file.delete();
    print('Database file deleted');
  }
}
