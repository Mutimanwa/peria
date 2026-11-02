import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';

Widget journalAttachmentView(
  String path, {
  double width = 88,
  double height = 88,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.file(
    File(path),
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (_, __, ___) => Container(
      width: width,
      height: height,
      color: AppColors.grey100,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_outlined, color: AppColors.grey500),
    ),
  );
}
