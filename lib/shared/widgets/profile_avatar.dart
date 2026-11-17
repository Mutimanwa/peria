import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peria_app/core/constants/app_assets.dart';

/// Largest size an avatar is ever painted at (55 px radius on a 4x screen).
///
/// Picked avatars are already stored at 512 px (`ImagePicker.maxWidth`), so this
/// decodes them once at their real size instead of keeping a full-resolution
/// bitmap in memory.
const int _decodeSize = 512;

/// Renders the user's profile picture.
///
/// The picture is stored as a small base64 JPEG inside the profile document so
/// an anonymous account can still personalise its avatar without any upload.
ImageProvider profileAvatarImage(String? avatarBase64) {
  final data = avatarBase64;
  if (data == null || data.isEmpty) {
    return const AssetImage(AppAssets.avatar);
  }
  try {
    // Decode at the size the avatar is actually painted: a full-size camera
    // photo would be decoded at its native resolution and then thrown away,
    // and the default avatar must stay crisp on high-density screens.
    return ResizeImage(
      MemoryImage(base64Decode(data)),
      width: _decodeSize,
      height: _decodeSize,
      allowUpscaling: false,
    );
  } catch (_) {
    return const AssetImage(AppAssets.avatar);
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.avatarBase64,
    this.radius = 46,
    this.withBorder = false,
  });

  final String? avatarBase64;
  final double radius;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: withBorder
            ? Border.all(color: Theme.of(context).colorScheme.outlineVariant)
            : null,
        image: DecorationImage(
          image: profileAvatarImage(avatarBase64),
          fit: BoxFit.cover,
          // Default `low` resampling makes a downscaled photo look soft.
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
