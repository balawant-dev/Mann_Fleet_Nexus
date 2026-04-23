import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { asset, network, svg }

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final ImageType imageType;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;
  final Color? bgColor;
  final bool applyThemeColor;
  const CustomImageView({
    super.key,
    required this.imagePath,
    this.imageType = ImageType.asset,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.bgColor,
    this.applyThemeColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color themeImageColor =
    isDark ? const Color(0xFFFEFDFF) : Theme.of(context).primaryColor;
    Widget buildImage() {
      if (imagePath == null || imagePath!.isEmpty) {
        return const Center(child: Text("No Image"));
      }
      switch (imageType) {
        case ImageType.asset:
          return Image.asset(
            imagePath!,
            width: width,
            height: height,
            fit: fit,
            color: applyThemeColor ? themeImageColor : null,
            colorBlendMode:
            applyThemeColor ? BlendMode.srcIn : null,
            errorBuilder: (_, __, ___) =>
            const Center(child: Text("No Image Found")),
          );
        case ImageType.network:
          return Image.network(
            imagePath!,
            width: width,
            height: height,
            fit: fit,
            color: applyThemeColor ? themeImageColor : null,
            colorBlendMode:
            applyThemeColor ? BlendMode.srcIn : null,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (_, __, ___) =>
            const Center(child: Text("No Image Found")),
          );

        case ImageType.svg:
          return SvgPicture.asset(
            imagePath!,
            width: width,
            height: height,
            fit: fit,
            color: applyThemeColor ? themeImageColor : null,
            placeholderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
          );
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        color: bgColor ?? Colors.transparent,
        width: width,
        height: height,
        child: buildImage(),
      ),
    );
  }
}
