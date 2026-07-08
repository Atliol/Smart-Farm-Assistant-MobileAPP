import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double _dragOffset = 0.0; // 💡 အောက်ဆွဲချရင် ပိတ်ဖို့အတွက် Offset

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  Uint8List? _getByteImage(String base64String) {
    if (!base64String.contains(',')) return null;
    try {
      String pureBase64 = base64String.split(',')[1];
      return base64Decode(pureBase64);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity((1.0 - (_dragOffset.abs() / 300)).clamp(0.2, 1.0)),
      extendBodyBehindAppBar: true, // 💡 Facebook ကဲ့သို့ AppBar ကို ပုံပေါ်ထပ်ရန်

      // 💡 Modern Minimalist AppBar Design
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "${_currentIndex + 1} / ${widget.images.length}",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        centerTitle: true,
      ),

      // 💡 Facebook Style Swipe Down to Dismiss ပါဝင်သော Body
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.primaryDelta!;
          });
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset > 100) {
            Navigator.pop(context); // 🚀 အောက်သို့ ၁၀၀ ကျော်ဆွဲချပါက Screen ပိတ်မည်
          } else {
            setState(() {
              _dragOffset = 0.0; // မပြည့်ပါက မူလနေရာပြန်ပို့မည်
            });
          }
        },
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final byteImg = _getByteImage(widget.images[index]);
              if (byteImg == null) {
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                );
              }
              return Center(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.memory(
                    byteImg,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}