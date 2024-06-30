import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserSubtitlePlaceholder extends StatelessWidget {
  const UserSubtitlePlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 100,
        height: 16,
        color: Colors.grey[300],
      ),
    );
  }
}
