// app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('CropType')
class CropTypes extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text().unique()(); // Crop name must be unique
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Project')
class Projects extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Field')
class Fields extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get projectId => text().nullable().customConstraint('REFERENCES projects(id)')();
  TextColumn get name => text()();
  TextColumn get geometry => text().nullable()(); // Store GeoJSON or serialized data
  RealColumn get area => real().withDefault(const Constant(0.0))(); // Area in hectares
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Projects, Fields, CropTypes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CropType methods
  Future<List<CropType>> getAllCropTypes() => select(cropTypes).get();
  Future<void> insertCropType(CropTypesCompanion entry) => into(cropTypes).insert(entry);
  Future<void> deleteCropType(CropType cropType) => delete(cropTypes).delete(cropType);

  // Project methods
  Future<List<Project>> getAllProjects() => select(projects).get();
  Future<void> insertProject(ProjectsCompanion entry) => into(projects).insert(entry);
  Future<void> updateProject(Project project) => update(projects).replace(project);

  // Field methods
  Future<List<Field>> getFieldsByProjectId(String projectId) {
    return (select(fields)..where((field) => field.projectId.equals(projectId))).get();
  }

  Future<void> insertField(FieldsCompanion entry) => into(fields).insert(entry);
  Future<void> updateField(Field field) => update(fields).replace(field);

  Future<void> deleteField(Field field) => delete(fields).delete(field);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
