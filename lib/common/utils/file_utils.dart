import 'package:base_bloc_3/import.dart';

class FileUtils {
  static String? getFileExtension(String path) {
    return path.split('.').lastOrNull;
  }

  static bool isValidExtension(
    String? extension,
    List<String> allowedExtensions,
  ) {
    if (allowedExtensions.contains(extension?.toLowerCase())) {
      return true;
    }
    return false;
  }

  // static bool isAllowedVideo(VideoPlayerController videoPlayerController) {
  //   if (videoPlayerController.value.duration.inSeconds < 10 &&
  //       videoPlayerController.value.duration.inSeconds > 60) {
  //     return false;
  //   }
  //   if (videoPlayerController.value.size.width > 1280 ||
  //       videoPlayerController.value.size.height > 1280) {
  //     return false;
  //   }
  //   return true;
  // }

  static bool isVideo(String? extension) {
    return videoAllowedExtensions.contains(extension?.toLowerCase());
  }

  static bool isImage(String? extension) {
    return (imageAllowedExtensions + imageIosExtensions)
        .contains(extension?.toLowerCase());
  }

  static const List<String> imageIosExtensions = [
    "heif",
    "heic",
  ];

  static const List<String> imageAllowedExtensions = [
    "png",
    "jpg",
    "jpeg",
    "webp",
  ];
  static const List<String> videoAllowedExtensions = [
    "h264",
    "264",
    "mp4",
    "mpeg4",
    "wmv",
    "avi",
    "mkv",
    "mov",
  ];

  static List<String> mediaAllowedExtensions =
      imageAllowedExtensions + videoAllowedExtensions;
}
