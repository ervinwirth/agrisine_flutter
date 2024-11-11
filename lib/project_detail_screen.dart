// project_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:agrisix_flutter/src/data/app_database.dart';


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
        title: Text('$projectName Fields'),
      ),
      body: FutureBuilder<List<Field>>(
        future: database.getFieldsByProjectId(projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading fields.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No fields found.'));
          }

          final fields = snapshot.data!;
          return ListView.builder(
            itemCount: fields.length,
            itemBuilder: (context, index) {
              final field = fields[index];
              return ListTile(
                title: Text(field.name),
                subtitle: Text('Created on: ${field.createdAt}'),
                onTap: () {
                  // You can extend this later to show more details for each field
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for functionality to add new field or later implement a map view.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
