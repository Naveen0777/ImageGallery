import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final int likes;
  final int views;

  const FullScreenImage({
    required this.imageUrls,
    required this.initialIndex,
    required this.likes,
    required this.views,
  });

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildImageGallery(),
            _buildInfoOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: widget.imageUrls[index],
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(child: _buildShimmerImage()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        },
      ),
    );
  }

  Widget _buildInfoOverlay() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 5),
                Text(_formatCount(widget.likes),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.visibility,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(' ${_formatCount(widget.views)}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000000) {
      return '${(count / 1000000000).toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.deepPurple[200]!,
      highlightColor: Colors.deepPurpleAccent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        height: 600.0,
      ),
    );
  }
}
