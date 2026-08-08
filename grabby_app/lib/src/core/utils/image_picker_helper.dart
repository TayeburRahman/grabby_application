import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../src_export.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Generic method to pick an image showing a selection popup (Camera/Gallery)
  static Future<File?> pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.kPrimaryColor,
                ),
                title: const Text('Pick From Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppColors.kPrimaryColor,
                ),
                title: const Text('Take a Photo'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Optional: adjust quality
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    }
    return null;
  }
}
