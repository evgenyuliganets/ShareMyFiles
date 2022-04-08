class BaseFile {
  final int? id;
  final String name;
  final String path;
  final int size;

  BaseFile({
    this.id,
    required this.name,
    required this.size,
    required this.path,
  });
}