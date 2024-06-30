import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ErrorUserImage extends StatelessWidget {
  const ErrorUserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        imageUrl: 'https://source.unsplash.com/random/50x50',
        placeholder: (context, url) => Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
