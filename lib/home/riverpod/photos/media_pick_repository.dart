import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_my_files/model/base_file_model.dart';

abstract class MediaPickRepository {
  Future<List<XFile>> pickFiles();

  Future<List<XFile>> pickFilesWindows();
}

class FilePickRepositoryImpl implements MediaPickRepository {
  @override
  Future<List<XFile>> pickFiles() async {
    List<XFile> result =
        await ImagePicker().pickMultiImage() ?? List.empty(growable: true);
    return result;
  }

  @override
  Future<List<XFile>> pickFilesWindows() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      return result.files.map((e) => XFile(e.path!,name: e.name,)).toList();
    } else {
      return List.empty(growable: true);
    }
  }
}

class MediaData extends StateNotifier<List<XFile>> {
  final MediaPickRepository repository;

  MediaData(this.repository) : super(List.empty(growable: true));

  Future<void> pickMedia() async {
    if (state.isNotEmpty) {
      var res = await repository.pickFiles();
      var list = List<XFile>.empty(growable: true);
      list.addAll(state);
      if (res.isNotEmpty) {
        list.addAll(res);
      }
      state = List.from(list, growable: true);
    } else {
      state = await repository.pickFiles();
    }
  }

  Future<void> pickMediaWindows() async {
    if (state.isNotEmpty) {
      var res = await repository.pickFilesWindows();
      var list = List<XFile>.empty(growable: true);
      list.addAll(state);
      if (res.isNotEmpty) {
        list.addAll(res);
      }
      state = List.from(list, growable: true);
    } else {
      state = await repository.pickFilesWindows();
    }
  }

  void removeFile(XFile file) {
    state = List.from(state.where((element) => element != file).toList());
  }
}

extension BaseToPlatform on BaseFile {
  PlatformFile platformFile() {
    return PlatformFile(name: name, size: size);
  }
}
