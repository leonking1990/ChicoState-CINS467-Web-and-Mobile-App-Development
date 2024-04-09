import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ImagesGrid extends StatelessWidget {
  final List<XFile> pictures;

  const ImagesGrid({Key? key, required this.pictures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: pictures.length,
      itemBuilder: (BuildContext context, int index) {
        return ImageTile(imageFile: pictures[index]);
      },
    );
  }
}

class ImageTile extends StatelessWidget {
  final XFile imageFile;

  const ImageTile({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.file(File(imageFile.path), fit: BoxFit.cover),
    );
  }
}
