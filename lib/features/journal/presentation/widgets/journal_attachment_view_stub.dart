import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';

Widget journalAttachmentView(
  String path, {
  double width = 88,
  double height = 88,
  BoxFit fit = BoxFit.cover,
}) {
  return Container(
    width: width,
    height: height,
    color: AppColors.grey100,
    alignment: Alignment.center,
    child: const Icon(Icons.image_outlined, color: AppColors.grey500),
  );
}
