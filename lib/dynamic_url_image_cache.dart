library dynamic_url_image_cache;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Stores your in cache after the first download.
/// 
/// The value of [imageId] and [imageUrl] cannot be null.
class DynamicUrlImageCache extends StatefulWidget {

  ///The id used to store the image file, is used in the path.
  final String imageId;

  ///The url used to download the first time.
  final String imageUrl;

  ///The [Widget] that will be rendered while the file is loading.
  ///By default is a [CircularProgressIndicator].
  final Widget loadingPlaceholder;

  ///The [Widget] that will be rendered when the file loading throws an error.
  ///By default is an error [Icon].
  final Widget errorPlaceholder;

  ///Callback function that will be executed when the file loading throws an error.
  final Function(dynamic) onError;

  ///Image [Widget] height, the default value is 300.
  final double height;

  ///Image [Widget] width, the default value is 300.
  final double width;

  /// How a box should be inscribed into another box.
  final BoxFit fit;

  DynamicUrlImageCache({
    Key key,
    @required this.imageId,
    @required this.imageUrl,
    this.loadingPlaceholder = const CircularProgressIndicator(),
    this.errorPlaceholder = const Icon(Icons.error),
    this.onError,
    this.height = 300,
    this.width = 300,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  _DynamicUrlImageCacheState createState() => _DynamicUrlImageCacheState();
}

class _DynamicUrlImageCacheState extends State<DynamicUrlImageCache> {

  bool isLoading = true;
  bool hasError = false;
  File image;

  Future<File> getImage() async {
    try {
      File file = await this.findImage(this.widget.imageId);
      if(file == null) {
        final dir = (await getTemporaryDirectory()).path;
        final request = await HttpClient().getUrl(Uri.parse(this.widget.imageUrl));
        final response = await request.close();
        final bytes = await consolidateHttpClientResponseBytes(response);
        File newFile = File("$dir/${this.widget.imageId}")
          ..writeAsBytesSync(bytes);
        return newFile;
      } else {
        return file;
      }
    } catch(e) {
      if(this.widget.onError != null) {
        this.widget.onError(e);
      }
      return null;
    }
  }

  Future<File> findImage(String imgKey) async {
    try {
      final dir = (await getTemporaryDirectory()).path;
      bool hasFile = await File("$dir/$imgKey").exists();
      if(hasFile) {
        return File("$dir/$imgKey");
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> loadImage() async {
    File image = await this.getImage();
    if(image != null) {
      setState(() {
        this.isLoading = false;
        this.image = image;
      });
    } else {
      setState(() {
        this.isLoading = false;
        this.hasError = true;
      });
    }
  }

  @override
  void initState() {
    this.loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.widget.height,
      width: this.widget.width,
      child: this.isLoading
        ? this.widget.loadingPlaceholder
        : this.hasError 
          ? this.widget.errorPlaceholder
          : Image.file(this.image, fit: this.widget.fit),
    );
  }
}