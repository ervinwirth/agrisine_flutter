# agrisix_flutter

Agrisix Farm Management app

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Concepts:
- open-source
- local storage: file or db (sql vs nosql)
- activity files can be download e.g. in Excel CSV per fields (all fields, etc ...)
- projects/workspaces (people can be invited)
- bottleneck: store model locally / sync to cloud

Data model:
- project/workspace
- farm field (id, ..., project_id)
  e.g. a polygon with name id
- activities (id, ... farm_id ...)
  e.g. permezetés 2024.06.20.

Ezt még át kell gondolni, mi történjen, ha nem meglévő mezőhöz szeretne tevékenységet rögzíteni:
'Freestyle' poligonok:
- külön opció a megjelenítésükre
- A tevékenység létrehozásakor nincs olyan földrajzi egység (field), amihez rögzítenénk; ekkor instant létrehozhatunk egyet
- Az átfedések elkerülése végett ezek alapból nem jelennek meg a térképen


Android apps to check:
- fieldmargin: https://play.google.com/store/apps/details?id=com.fieldmargin&hl=hu