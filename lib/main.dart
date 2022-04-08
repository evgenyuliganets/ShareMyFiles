import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_my_files/home/riverpod/photos/media_pick_provider.dart';

import 'home/riverpod/files/file_pick_provider.dart';
import 'model/base_file_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMyFiles',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ShareMyFiles'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late BaseFile? currentImage;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEBEBEB),
                            width: 1.0,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              ref.read(fileData.notifier).pickFiles();
                            },
                            splashFactory: NoSplash.splashFactory,
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                children: const [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(Icons.attach_file)),
                                  Flexible(
                                    child: Text(
                                      "Pick files",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            var state = ref.watch(fileData);
                            if (state != null && state.files.isNotEmpty) {
                              var list = state.files;
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    children: list
                                        .asMap()
                                        .map((key, value) => MapEntry(
                                            key,
                                            FileElement(
                                              name: value.name.split('.').first,
                                              extension: value.extension,
                                              action: () {
                                                ref
                                                    .read(fileData.notifier)
                                                    .removeFile(value);
                                              },
                                            )))
                                        .values
                                        .toList(),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFEBEBEB),
                            width: 1.0,
                          )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (Platform.isWindows) {
                                ref.read(mediaData.notifier).pickMediaWindows();
                              } else {
                                ref.read(mediaData.notifier).pickMedia();
                              }
                            },
                            splashFactory: NoSplash.splashFactory,
                            child: SizedBox(
                              height: 100,
                              child: Row(
                                children: const [
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(Icons.photo)),
                                  Flexible(
                                    child: Text(
                                      "Pick images",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Consumer(builder: (context, ref, child) {
                            var state = ref.watch(mediaData);
                            if (state.isNotEmpty) {
                              var list = state;
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 10),
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    alignment: WrapAlignment.start,
                                    children: list
                                        .take(4)
                                        .toList()
                                        .asMap()
                                        .map((key, value) {
                                          if (key <= 2) {
                                            return MapEntry(
                                                key,
                                                MediaElement(
                                                  imagePath: value.path,
                                                  action: () {
                                                    ref
                                                        .read(
                                                            mediaData.notifier)
                                                        .removeFile(value);
                                                  },
                                                ));
                                          } else {
                                            if (list.length >= 5) {
                                              return MapEntry(
                                                  key,
                                                  MoreMedia(
                                                      imagePath: value.path,
                                                      moreFiles: list
                                                          .getRange(
                                                              3, list.length)
                                                          .toList()));
                                            } else {
                                              return MapEntry(
                                                  key,
                                                  MediaElement(
                                                    imagePath: value.path,
                                                    action: () {
                                                      ref
                                                          .read(mediaData
                                                              .notifier)
                                                          .removeFile(value);
                                                    },
                                                  ));
                                            }
                                          }
                                        })
                                        .values
                                        .toList(),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
                        ],
                      )),
                ],
              ),
            )
          ]),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FileElement extends StatelessWidget {
  final String name;
  final String? extension;
  final Function action;

  const FileElement(
      {Key? key,
      required this.name,
      required this.extension,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withAlpha(60),
              width: 1.0,
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  name,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                ),
              ),
            ),
            if (extension != null)
              Text(
                "." + extension!,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    action();
                  },
                  icon: const Icon(Icons.clear)),
            )
          ],
        ),
      ),
    );
  }
}

class MoreMedia extends StatefulWidget {
  final String imagePath;
  final List<XFile> moreFiles;

  const MoreMedia({Key? key, required this.imagePath, required this.moreFiles})
      : super(key: key);

  @override
  State<MoreMedia> createState() => _MoreMediaState();
}

class _MoreMediaState extends State<MoreMedia> {
  void _goToHeroPage(BuildContext context, List<XFile> list) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x8B808080),
      builder: (BuildContext context) => Dialog(
          child: Stack(
        fit: StackFit.passthrough,
        children: [
          Consumer(builder: (context, ref, child) {
            return SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Hero(
                  tag: 'listMore',
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  alignment: WrapAlignment.start,
                                  children: list
                                      .asMap()
                                      .map((key, value) {
                                        return MapEntry(
                                          key,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color:
                                                      const Color(0x37959595),
                                                  height: 150,
                                                  width: 150,
                                                  child: Image.file(
                                                    File(widget.imagePath),
                                                    errorBuilder:
                                                        (context, obj, trace) {
                                                      return const Icon(
                                                          Icons.image);
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 3,
                                                  top: 3,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        const Color(0x8BFFFFFF),
                                                    radius: 20,
                                                    child: Center(
                                                      child: IconButton(
                                                          onPressed: () {
                                                            ref
                                                                .read(mediaData
                                                                    .notifier)
                                                                .removeFile(
                                                                    value);
                                                          },
                                                          iconSize: 25,
                                                          splashRadius: 20,
                                                          splashColor: Colors
                                                              .transparent,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          icon: const Center(
                                                              child: Icon(
                                                            Icons.clear,
                                                            color: Colors.black,
                                                          ))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                      .values
                                      .toList())))
                    ],
                  ),
                ),
              ]),
            );
          }),
          Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(
              backgroundColor: const Color(0x8BFFFFFF),
              radius: 30,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 30,
                    splashRadius: 30,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    icon: const Center(
                        child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ))),
              ),
            ),
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          _goToHeroPage(context, widget.moreFiles);
        },
        child: Stack(
          children: [
            Container(
              foregroundDecoration: const BoxDecoration(color: Color(0x8B808080)),
              height: 150,
              width: 150,
              child: Hero(
                tag: "listMore",
                child: Image.file(
                  File(widget.imagePath),
                  errorBuilder: (context, obj, trace) {
                    return const Icon(Icons.image);
                  },
                ),
              ),
            ),
            Positioned.fill(
                child: Center(
              child: Text(
                "+ ${widget.moreFiles.length} more",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MediaElement extends StatefulWidget {
  final String imagePath;
  final Function action;

  const MediaElement({Key? key, required this.imagePath, required this.action})
      : super(key: key);

  @override
  State<MediaElement> createState() => _MediaElementState();
}

class _MediaElementState extends State<MediaElement> {
  bool allowTransition = true;

  void _goToHeroPage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x8B808080),
      builder: (BuildContext context) => Dialog(
          child: Stack(
        fit: StackFit.passthrough,
        children: [
          SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Hero(
                tag: 'image',
                child: Stack(
                  children: [
                    _imageHero(widget.imagePath),
                  ],
                ),
              ),
            ]),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: CircleAvatar(
              backgroundColor: const Color(0x8BFFFFFF),
              radius: 30,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 30,
                    splashRadius: 30,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    icon: const Center(
                        child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ))),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _imageHero(String imagePath) {
    return Image.file(
      File(widget.imagePath),
      errorBuilder: (context, obj, trace) {
        allowTransition = false;
        return const Icon(Icons.image);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Stack(
        children: [
          Container(
            color: const Color(0x37959595),
            height: 150,
            width: 150,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                if (allowTransition) {
                  _goToHeroPage(context);
                }
              },
              child: Hero(
                tag: "image",
                child: Image.file(
                  File(widget.imagePath),
                  errorBuilder: (context, obj, trace) {
                    allowTransition = false;
                    return const Icon(Icons.image);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            right: 3,
            top: 3,
            child: CircleAvatar(
              backgroundColor: const Color(0x8BFFFFFF),
              radius: 20,
              child: Center(
                child: IconButton(
                    onPressed: () {
                      widget.action();
                    },
                    iconSize: 25,
                    splashRadius: 20,
                    splashColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    icon: const Center(
                        child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ))),
              ),
            ),
          )
        ],
      ),
    );
  }
}
