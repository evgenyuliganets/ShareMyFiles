import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_my_files/home/riverpod/photos/media_pick_repository.dart';

final fileRepositoryProvider =
    Provider<MediaPickRepository>((ref) => FilePickRepositoryImpl());

final mediaData =
    StateNotifierProvider.autoDispose<MediaData, List<XFile>>((ref) {
  final repoProvider = ref.read(fileRepositoryProvider);
  return MediaData(repoProvider);
});
