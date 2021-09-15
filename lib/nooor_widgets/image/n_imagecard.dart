import 'dart:convert';

import 'package:flutter/material.dart';
import '../resizer/responsive_util.dart';
import 'package:string_validator/string_validator.dart';
import 'dart:io' as io;

class ImageCard extends StatefulWidget {
  final String? imageUrl;
  ImageCard({Key? key, this.imageUrl}) : super(key: key);

  @override
  _ImageCardState createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtil(
        child: SizedBox(width: 200, height: 200, child: getImage()));
  }

  Widget getImage() {
    return widget.imageUrl!.startsWith('http')
        ? Image.network(widget.imageUrl!)
        : isBase64(widget.imageUrl!)
            ? Image.memory(base64.decode(widget.imageUrl!))
            : Image.file(io.File(widget.imageUrl!));
  }
}
