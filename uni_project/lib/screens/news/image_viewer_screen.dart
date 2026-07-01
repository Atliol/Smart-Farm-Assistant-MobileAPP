import 'package:flutter/material.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({super.key, required this.images, required this.initialIndex});

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // နှိပ်လိုက်သော ဓာတ်ပုံအညွှန်းကိန်း (Index) အတိုင်း ကွက်တိ ပွင့်လာစေရန် စီမံခြင်း
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ဓာတ်ပုံကြည့်ရန် အနက်ရောင်ပြောင်းခြင်း
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Photos (${widget.images.length})",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical, // 💡 တောင်းဆိုချက်အရ ဒေါင်လိုက် (အထက်အောက်) Scroll ဆွဲရန် ပြောင်းလဲထားပါသည်
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer( // ပုံကို လက်နှစ်ချောင်းဖြင့် Zoom ချဲ့/ချုံ့ ကြည့်နိုင်ရန် ကာကွယ်ပေးခြင်း
              child: Container(
                width: double.infinity,
                color: Colors.grey[900],
                child: const Icon(Icons.image, size: 80, color: Colors.white54), // နောက်ပိုင်း Image.network ဖြင့် အစားထိုးရန်
              ),
            ),
          );
        },
      ),
    );
  }
}