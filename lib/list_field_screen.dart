import 'package:flutter/material.dart';
import 'package:agrisine_flutter/src/data/app_database.dart';
import 'l10n/generated/l10n.dart';

class FieldListScreen extends StatefulWidget {
  final AppDatabase database;
  final String projectId;

  const FieldListScreen({
    super.key,
    required this.database,
    required this.projectId,
  });

  @override
  _FieldListScreenState createState() => _FieldListScreenState();
}

class _FieldListScreenState extends State<FieldListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).listMyFields), // Use translation for the title
      ),
      body: FutureBuilder<List<Field>>(
        future: widget.database.getFieldsByProjectId(widget.projectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(S.of(context).errorLoadingFields));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noFieldsFound));
          } else {
            final fields = snapshot.data!;
            return ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return ListTile(
                  title: Text(field.name),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _renameField(field);
                      } else if (value == 'delete') {
                        _deleteField(field);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'rename',
                          child: Text(S.of(context).renameField),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(S.of(context).deleteField),
                        ),
                      ];
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _renameField(Field field) {
    TextEditingController controller = TextEditingController(text: field.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).renameField),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: S.of(context).newFieldName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  await widget.database.updateField(field.copyWith(name: newName));
                  setState(() {});
                }
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).rename),
            ),
          ],
        );
      },
    );
  }

  void _deleteField(Field field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).deleteField),
          content: Text(S.of(context).confirmDeleteField),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                await widget.database.deleteField(field);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).delete),
            ),
          ],
        );
      },
    );
  }
}
