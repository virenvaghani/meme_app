import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class MemeCard extends StatefulWidget {
  final String? id;
  final String? name;
  final String? url;
  final int? width;
  final int? height;
  final int? boxCount;
  final int? captions;
  final Function(Color) onColourExtract;

  const MemeCard({
    super.key,
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
    required this.onColourExtract,
  });

  @override
  State<MemeCard> createState() => _MemeCardState();
}

class _MemeCardState extends State<MemeCard> {
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black87;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _extractDominantColor();
  }

  Future<void> _extractDominantColor() async {
    if (widget.url == null || widget.url!.isEmpty) return;

    try {
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.url!),
        maximumColorCount: 10,
      );
      final dominantColor =
          paletteGenerator.dominantColor?.color ?? Colors.white;
      if (mounted) {
        setState(() {
          backgroundColor = dominantColor.withOpacity(0.1);
          textColor =
              dominantColor.computeLuminance() > 0.5
                  ? Colors.black87
                  : Colors.white;
        });
        widget.onColourExtract(dominantColor);
      }
    } catch (e) {
      // Fallback in case of error
      if (mounted) {
        setState(() {
          backgroundColor = Colors.white;
          textColor = Colors.black87;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isHovered ? -8 : 0, 0),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isHovered ? 12 : 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundColor, backgroundColor.withOpacity(0.5)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.url ?? '',
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                      errorWidget:
                          (context, url, error) => const Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.red,
                          ),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name ?? 'Unnamed Meme',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('ID', widget.id ?? 'N/A'),
                  _buildInfoRow(
                    'Dimensions',
                    '${widget.width ?? 0} x ${widget.height ?? 0}',
                  ),
                  _buildInfoRow(
                    'Box Count',
                    widget.boxCount?.toString() ?? '0',
                  ),
                  _buildInfoRow('Captions', widget.captions?.toString() ?? '0'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
