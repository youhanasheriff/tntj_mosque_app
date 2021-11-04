import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatelessWidget {
  static String routeName = "/image_view";

  const ImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var images = ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: PhotoViewGallery.builder(
          itemCount: images.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                images[index],
              ),
            );
          },
          loadingBuilder: (_, __) => const Center(
            child: CircularProgressIndicator(),
          ),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
