import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_my_files/model/base_file_model.dart';

abstract class FilePickRepository {
  Future<FilePickerResult?> pickFiles();
}

class FilePickRepositoryImpl implements FilePickRepository {
  @override
  Future<FilePickerResult?> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    return result;
  }
}

class FileData extends StateNotifier<FilePickerResult?> {
  final FilePickRepository repository;

  FileData(this.repository) : super(null);

  Future<void> pickFiles() async {
    if (state != null && state!.files.isNotEmpty) {
      var res = await repository.pickFiles();
      var list = List<PlatformFile>.empty(growable: true);
      list.addAll(state!.files);
      if (res != null) list.addAll(res.files);
      state = FilePickerResult(list);
    } else {
      state = await repository.pickFiles();
    }
  }

  Future<void> addFilesFromData(List<BaseFile>? baseFiles) async {
    var files = List<PlatformFile>.empty(growable: true);
    for (var file in baseFiles!) {
      files.add(file.platformFile());
    }
    state = FilePickerResult(files);
  }

  void removeFile(PlatformFile file) {
    state = FilePickerResult(
        state!.files.where((element) => element != file).toList());
  }
}

extension BaseToPlatform on BaseFile {
  PlatformFile platformFile() {
    return PlatformFile(name: name, size: size);
  }
}
