import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final String imageUrl, previewUrl;
  final double imageHeight, imageWidth;

  const ImageTile({
    Key? key,
    required this.imageUrl,
    required this.previewUrl,
    required this.imageHeight,
    required this.imageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = imageHeight * .03;
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            height: imageHeight - padding * 2,
            width: imageWidth - padding * 2,
            margin: EdgeInsets.all(
              padding,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.contain,
              ),
            ),
          ),
          progressIndicatorBuilder: (context, url, downloadProgress) => Stack(
            children: [
              Image.network(
                previewUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, object, trace) => const Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ],
    );
  }
}
