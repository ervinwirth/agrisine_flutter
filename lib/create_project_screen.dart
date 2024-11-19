import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/src/data/app_database.dart';
import 'package:drift/drift.dart' as drift; // Alias for drift
import 'l10n/generated/l10n.dart'; // Import the localization class

class CreateProjectScreen extends StatefulWidget {
  final AppDatabase database;

  const CreateProjectScreen({super.key, required this.database});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final Uuid _uuid = const Uuid();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createProject() async {
    if (_formKey.currentState!.validate()) {
      final id = _uuid.v4(); // Generate a new UUID for the project
      final name = _nameController.text; // Get the name from the controller

      // Use the ProjectsCompanion.insert constructor for insertion
      await widget.database.insertProject(
        ProjectsCompanion.insert(
          id: id, // No need for Value() here
          name: name, // No need for Value() here
          createdAt: drift.Value(DateTime.now()), // Use drift.Value() for DateTime
          updatedAt: drift.Value(DateTime.now()), // Use drift.Value() for DateTime
          isDeleted: drift.Value(false), // Use drift.Value() for booleans
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).projectCreatedSuccess)), // Use translation
      );

      // Close the current screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createProjectTitle), // Use translation
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: S.of(context).projectNameLabel, // Use translation
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).projectNameValidation; // Use translation
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createProject,
                child: Text(S.of(context).createProjectButton), // Use translation
              ),
            ],
          ),
        ),
      ),
    );
  }
}
