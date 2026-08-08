import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../../src_export.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BoxFit? fit;
  final double? radius;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final String? imageErrorUrl;
  final bool? isImagePreview;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.imageErrorUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.radius,
    this.boxShape = BoxShape.rectangle,
    this.borderRadius,
    this.fit,
    this.isImagePreview = false,
  });
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    CupertinoIcons.multiply_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isImagePreview == true
          ? () {
              showCustomDialog(context);
            }
          : null,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              borderRadius: boxShape == BoxShape.circle
                  ? null
                  : borderRadius ?? BorderRadius.circular(radius ?? 8),
              shape: boxShape,
              color: backgroundColor,
              image: DecorationImage(
                image: imageProvider,
                fit: fit ?? BoxFit.cover,
                colorFilter: colorFilter,
              ),
            ),
            child: child,
          );
        },
        placeholder: (context, url) {
          return SizedBox(
            height: height,
            width: width,
            child: Center(
              child: Padding(
                padding: AppPadding.getPadding8(context),
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                  strokeWidth: 1,
                ),
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              shape: boxShape,
              borderRadius: boxShape == BoxShape.circle
                  ? null
                  : BorderRadius.circular(radius ?? 8),

              color: Colors.grey.withValues(alpha: 0.6),
              image: DecorationImage(
                image: AssetImage(
                  imageErrorUrl ?? 'assets/icons/placeholder.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

// class ListOfImages extends StatelessWidget {
//   final bool isNetworkImage ;
//   final double? size;
//   final bool? isShowCross;
//
//   const ListOfImages({super.key,   this.isNetworkImage =true, this.size, this.isShowCross =true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.sp),
//       child: Obx(() {
//         return images.isEmpty
//             ? SizedBox.shrink()
//             : Wrap(
//           spacing: 8.w,
//           runSpacing: 8.w,
//           children: List.generate(images.length, (index) {
//             final img = images[index];
//             return Stack(
//               children: [
//                 isNetworkImage
//                     ? CustomNetworkImage(
//                   imageUrl: "$img",
//                   height:size?? 90,
//                   width:size?? 90,
//                 )
//                     : Image.file(
//                   File(img),
//                   height:size?? 90,
//                   width:size?? 90,
//                   fit: BoxFit.cover,
//                 ),
//                 isShowCross==true?     Positioned(
//                   top: -10,
//                   right: -10,
//
//                   child: IconButton(
//                     onPressed: () {
//                       // removeImage(uploadImages: images, imagePath: img);img
//                       // if (isNetworkImage) {
//                       //   SellController.to.removeImgList.add(img);
//                       //   logger.d( SellController.to.removeImgList.length);
//                       // }
//                     },
//                     icon: Icon(
//                       CupertinoIcons.multiply_circle_fill,
//                       size: 20,
//                       color: AppColors.kPrimaryFirst,
//                     ),
//                   ),
//                 ):SizedBox.shrink(),
//               ],
//             );
//           }),
//         );
//       }),
//     );
//   }
// }
