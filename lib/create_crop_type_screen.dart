import 'package:flutter/material.dart';
import '/src/data/app_database.dart';
import 'l10n/generated/l10n.dart'; // Import localization
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

class CropTypeScreen extends StatefulWidget {
  final AppDatabase database;

  const CropTypeScreen({super.key, required this.database});

  @override
  _CropTypeScreenState createState() => _CropTypeScreenState();
}

class _CropTypeScreenState extends State<CropTypeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).createCropType), // Use translation for the title
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCropTypeDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<List<CropType>>(
        future: widget.database.getAllCropTypes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(S.of(context).errorLoadingCropTypes));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noCropTypesFound));
          } else {
            final cropTypes = snapshot.data!;
            return ListView.builder(
              itemCount: cropTypes.length,
              itemBuilder: (context, index) {
                final cropType = cropTypes[index];
                return ListTile(
                  title: Text(cropType.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCropType(cropType),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showAddCropTypeDialog(BuildContext context) {
    _nameController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).addCropType),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: S.of(context).cropTypeName,
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
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  final newCropType = CropTypesCompanion.insert(
                    id: const Uuid().v4(),
                    name: name,
                    createdAt: drift.Value(DateTime.now()),
                    updatedAt: drift.Value(DateTime.now()),
                  );
                  await widget.database.insertCropType(newCropType);
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
              child: Text(S.of(context).add),
            ),
          ],
        );
      },
    );
  }

  void _deleteCropType(CropType cropType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).deleteCropType),
          content: Text(S.of(context).confirmDeleteCropType),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () async {
                await widget.database.deleteCropType(cropType);
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
