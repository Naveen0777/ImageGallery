import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'api_service.dart';
import 'full_screen_image.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<dynamic>> _futureImages;

  @override
  void initState() {
    super.initState();
    _futureImages = ApiService.fetchImages('space');
  }

  String _formatCount(int count) {
    if (count >= 1000000000) {
      double formattedCount = count / 1000000000.0;
      return '${formattedCount.toStringAsFixed(1)}B';
    } else if (count >= 1000000) {
      double formattedCount = count / 1000000.0;
      return '${formattedCount.toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      double formattedCount = count / 1000.0;
      return '${formattedCount.toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<dynamic>>(
          future: _futureImages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerGrid();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No images found.'));
            } else {
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, // Adjust this value as needed
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImage(
                            imageUrls: [snapshot.data![index]['largeImageURL']],
                            initialIndex: 0,
                            likes: snapshot.data![index]['likes'],
                            views: snapshot.data![index]['views'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data![index]['webformatURL'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    _buildShimmerImage(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      ' ${_formatCount(snapshot.data![index]['likes'])}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.visibility,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      ' ${_formatCount(snapshot.data![index]['views'])}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // Adjust the device width
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerImage();
      },
      itemCount: 10,
    );
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.deepPurple[200]!,
      highlightColor: Colors.deepPurpleAccent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
