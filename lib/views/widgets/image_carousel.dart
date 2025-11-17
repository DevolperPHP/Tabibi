import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/color_app.dart';

class ImageCarousel extends StatefulWidget {
  final List<String?> images;
  final int initialIndex;

  const ImageCarousel({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late int currentIndex;
  late PageController pageController;
  final Map<int, TransformationController> _transformationControllers = {};

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    _transformationControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  TransformationController _getController(int index) {
    if (!_transformationControllers.containsKey(index)) {
      _transformationControllers[index] = TransformationController();
    }
    return _transformationControllers[index]!;
  }

  @override
  Widget build(BuildContext context) {
    // Filter out null/empty images
    List<String> validImages = widget.images
        .where((img) => img != null && img.isNotEmpty)
        .cast<String>()
        .toList();

    if (validImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد صور',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'الصورة ${currentIndex + 1} من ${validImages.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _getController(currentIndex).value = Matrix4.identity();
            },
            tooltip: 'إعادة تعيين التكبير',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: validImages.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildZoomableImage(validImages[index], index);
              },
            ),
          ),
          // Thumbnail navigation at bottom
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: validImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: currentIndex == index
                            ? ColorApp.primaryColor
                            : Colors.white24,
                        width: currentIndex == index ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: '${ApiConstants.baseUrlImage}${validImages[index]}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorApp.primaryColor,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.broken_image, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Instructions
          Container(
            color: Colors.black.withOpacity(0.8),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SafeArea(
              child: Text(
                'اضغط مرتين للتكبير • اسحب للتحريك • اقرص للتكبير/التصغير',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomableImage(String imageUrl, int index) {
    final controller = _getController(index);
    
    return GestureDetector(
      onDoubleTapDown: (details) {
        // Store tap position for zoom
        final position = details.localPosition;
        if (controller.value != Matrix4.identity()) {
          controller.value = Matrix4.identity();
        } else {
          controller.value = Matrix4.identity()
            ..translate(-position.dx * 0.5, -position.dy * 0.5)
            ..scale(2.0);
        }
      },
      child: InteractiveViewer(
        transformationController: controller,
        minScale: 0.5,
        maxScale: 5.0,
        boundaryMargin: EdgeInsets.all(double.infinity),
        child: Center(
          child: CachedNetworkImage(
            imageUrl: '${ApiConstants.baseUrlImage}${imageUrl}',
            fit: BoxFit.contain,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
                color: ColorApp.primaryColor,
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'فشل تحميل الصورة',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to show carousel
void showImageCarousel(BuildContext context, List<String?> images, {int initialIndex = 0}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageCarousel(
        images: images,
        initialIndex: initialIndex,
      ),
    ),
  );
}
