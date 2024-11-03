import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display an image
            Image.asset(
              'assets/agrisix_logo.png',
              width: 150, // Adjust width as needed
              height: 150, // Adjust height as needed
            ),
            const SizedBox(height: 20), // Add spacing below the image
            // Add buttons for My Projects and Add New Project
            ElevatedButton(
              onPressed: () {
                // Add functionality for My Projects
              },
              child: const Text('My Projects'),
            ),
            const SizedBox(height: 10), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Add functionality for Add New Project
              },
              child: const Text('Add New Project'),
            ),
          ],
        ),
      ),
    );
  }
}
