import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageRenderResult {
  final Widget imageWidget;
  final double width;
  final double height;

  ImageRenderResult({
    required this.imageWidget,
    required this.width,
    required this.height,
  });
}

Future<ImageRenderResult> loadImageWithSize(String url) async {
  final ImageProvider provider = NetworkImage(url);
  final Completer<ui.Image> completer = Completer();

  final ImageStream stream = provider.resolve(const ImageConfiguration());
  final listener = ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info.image);
  });

  stream.addListener(listener);
  final ui.Image image = await completer.future;
  stream.removeListener(listener);

  final double width = image.width.toDouble();
  final double height = image.height.toDouble();

  return ImageRenderResult(
    imageWidget: ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.broken_image,
          color: Colors.red,
        ),
      ),
    ),
    width: width,
    height: height,
  );
}