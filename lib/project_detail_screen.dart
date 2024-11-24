import 'package:flutter/material.dart';
import '/src/data/app_database.dart';
import 'l10n/generated/l10n.dart'; // Import localization
import 'add_field_screen.dart'; // Import AddFieldScreen
import 'list_field_screen.dart'; // Import FieldListScreen
import 'create_crop_type_screen.dart'; // Import CropTypeScreen

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropTypeScreen(database: database),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FieldListScreen(
                      database: database,
                      projectId: projectId,
                    ),
                  ),
                );
              },
              child: Text(S.of(context).listMyFields), // Use translation
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFieldScreen(
                      database: database,
                      projectId: projectId,
                    ),
                  ),
                );
              },
              child: Text(S.of(context).addField), // Use translation
            ),
          ],
        ),
      ),
    );
  }
}
