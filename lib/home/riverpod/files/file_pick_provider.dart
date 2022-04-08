import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_my_files/home/riverpod/files/file_pick_repository.dart';

final fileRepositoryProvider =
    Provider<FilePickRepository>((ref) => FilePickRepositoryImpl());

final fileData =
    StateNotifierProvider.autoDispose<FileData, FilePickerResult?>((ref) {
  final repoProvider = ref.read(fileRepositoryProvider);
  return FileData(repoProvider);
});
