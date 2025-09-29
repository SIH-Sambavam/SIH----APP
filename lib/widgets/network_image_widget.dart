import 'package:flutter/material.dart';

class NetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      headers: {
        'User-Agent': 'BlueGuard Mobile App 1.0',
        'Accept': 'image/*,*/*;q=0.8',
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('Network image error: $error');
        debugPrint('Failed URL: ${widget.imageUrl}');
        debugPrint('Stack trace: $stackTrace');

        return widget.errorWidget ??
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: widget.borderRadius,
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Image unavailable',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return widget.placeholder ??
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: widget.borderRadius,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: widget.borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
