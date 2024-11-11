import 'package:flutter/material.dart';
import '/src/data/app_database.dart';
import 'create_project_screen.dart';
import 'project_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrisix App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Agrisix Home'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
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
                // Navigate to Project List screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProjectListScreen(database: database),
                  ),
                );
              },
              child: const Text('My Projects'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateProjectScreen(database: database),
                  ),
                );
              },
              child: const Text('Add New Project'),
            ),
          ],
        ),
      ),
    );
  }
}
