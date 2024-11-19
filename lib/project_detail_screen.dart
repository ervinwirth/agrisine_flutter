import 'package:flutter/material.dart';
import 'package:agrisix_flutter/src/data/app_database.dart';
import 'l10n/generated/l10n.dart'; // Import localization

class ProjectDetailScreen extends StatelessWidget {
  final AppDatabase database;
  final String projectId;
  final String projectName;

  const ProjectDetailScreen({
    super.key,
    required this.database,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName), // Display only the project name
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Create Crop Type screen
              },
              child: Text(S.of(context).createCropType), // Use translation
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Create Activity Type screen
              },
              child: Text(S.of(context).createActivityType), // Use translation
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the List My Fields screen
              },
              child: Text(S.of(context).listMyFields), // Use translation
            ),
          ],
        ),
      ),
    );
  }
}
