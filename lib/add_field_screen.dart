import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:agrisix_flutter/src/data/app_database.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddFieldScreen extends StatefulWidget {
  final AppDatabase database;
  final String projectId;

  const AddFieldScreen({
    super.key,
    required this.database,
    required this.projectId,
  });

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final List<LatLng> _fieldPoints = [];
  LatLng _mapCenter = const LatLng(47.497913, 19.040236); // Default center
  double _mapZoom = 10.0;

  void _addPointAtCenter() {
    setState(() {
      _fieldPoints.add(_mapCenter);
    });
  }

  void _undoPoint() {
    setState(() {
      if (_fieldPoints.isNotEmpty) {
        _fieldPoints.removeLast();
      }
    });
  }

  String _serializeGeometry(List<LatLng> points) {
    return points.map((point) => '${point.latitude},${point.longitude}').join(';');
  }

  Future<void> _saveField() async {
    if (_fieldPoints.isNotEmpty) {
      String geometry = _serializeGeometry(_fieldPoints);

      final newField = FieldsCompanion.insert(
        id: const Uuid().v4(),
        projectId: drift.Value(widget.projectId),
        name: 'New Field',
        createdAt: drift.Value(DateTime.now()),
        updatedAt: drift.Value(DateTime.now()),
        isDeleted: const drift.Value(false),
        geometry: drift.Value(geometry),
      );

      await widget.database.insertField(newField);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field saved successfully!')),
      );

      setState(() {
        _fieldPoints.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['MAPTILER_API_KEY'] ?? 'YOUR_DEFAULT_API_KEY';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Field"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Map section (takes remaining available space)
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    onPositionChanged: (position, hasGesture) {
                      setState(() {
                        _mapCenter = position.center;
                        _mapZoom = position.zoom;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://api.maptiler.com/maps/satellite/{z}/{x}/{y}.jpg?key=$apiKey",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: _fieldPoints.map((point) {
                        return Marker(
                          width: 20,
                          height: 20,
                          point: point,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        );
                      }).toList(),
                    ),
                    PolygonLayer(
                      polygons: [
                        if (_fieldPoints.isNotEmpty)
                          Polygon(
                            points: _fieldPoints,
                            color: Colors.blue.withOpacity(0.2),
                            borderColor: Colors.blue,
                            borderStrokeWidth: 3,
                          ),
                      ],
                    ),
                  ],
                ),
                // Crosshair in the center
                Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2),
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Buttons section (20% height of the screen)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addPointAtCenter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Point'),
                ),
                ElevatedButton(
                  onPressed: _undoPoint,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Undo Point'),
                ),
                ElevatedButton(
                  onPressed: _saveField,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save Field'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
