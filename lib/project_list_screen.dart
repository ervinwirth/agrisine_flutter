import 'package:flutter/material.dart';
import '/src/data/app_database.dart';
import 'project_detail_screen.dart';
import 'l10n/generated/l10n.dart'; // Import localization class

class ProjectListScreen extends StatelessWidget {
  final AppDatabase database;

  const ProjectListScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myProjects), // Use translation
      ),
      body: FutureBuilder(
        future: database.getAllProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(S.of(context).errorLoadingProjects), // Use translation
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(S.of(context).noProjectsFound), // Use translation
            );
          }

          final projects = snapshot.data!;
          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return ListTile(
                title: Text(project.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailScreen(
                        database: database,
                        projectId: project.id,
                        projectName: project.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
