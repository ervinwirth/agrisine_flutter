// app_database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

@DataClassName('Project')
class Projects extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Field')
class Fields extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get projectId => text().nullable().customConstraint('REFERENCES projects(id)')();
  TextColumn get name => text()();
  RealColumn get area => real().withDefault(Constant(0.0))(); // Area in hectares
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Projects, Fields])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
