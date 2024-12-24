import 'package:base_bloc_3/import.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double lat, double long) async {
    try {
      if (Platform.isIOS) {
        if (await canLaunchUrlString('comgooglemaps://')) {
          await launchUrl(
            Uri.parse('comgooglemaps://?saddr=&daddr=$lat,$long'),
            mode: LaunchMode.externalApplication,
          );
        } else {
          await launchUrl(
            Uri.parse(
              'https://www.google.com/maps/search/?api=1&query=$lat,$long',
            ),
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        final String googleUrl =
            'https://www.google.com/maps/search/?api=1&query=$lat,$long';
        if (await canLaunchUrlString(googleUrl)) {
          await launchUrlString(googleUrl);
        } else {
          throw 'Could not open the map.';
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
