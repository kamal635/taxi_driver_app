import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens trusted external links outside the app.
final class ExternalUrlLauncher {
  const ExternalUrlLauncher._();

  static Future<bool> open(String url) async {
    final uri = Uri.parse(url);

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch) {
      debugPrint('Could not launch $url');
    }

    return didLaunch;
  }
}
