import 'package:flutter/material.dart';

/// Centralized icon catalog used across the app.
///
/// Keeping icon selections in a single place makes visual updates easier and
/// avoids scattering raw material icons across unrelated features.
final class AppIcons {
  AppIcons._();

  static const IconData taxi = Icons.local_taxi_rounded;
  static const IconData email = Icons.email_rounded;
  static const IconData lock = Icons.lock_rounded;
  static const IconData eye = Icons.visibility_rounded;
  static const IconData eyeOff = Icons.visibility_off_rounded;
  static const IconData arrowBack = Icons.arrow_back_rounded;
  static const IconData arrowForward = Icons.arrow_forward_ios_rounded;
  static const IconData arrowDown = Icons.keyboard_arrow_down_rounded;
  static const IconData person = Icons.person_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData car = Icons.directions_car_rounded;
  static const IconData helpCenter = Icons.help_outline_rounded;
  static const IconData signOut = Icons.logout_rounded;
  static const IconData note = Icons.sticky_note_2_rounded;
  static const IconData pickup = Icons.near_me_rounded;
  static const IconData dropoff = Icons.location_on_rounded;
  static const IconData camera = Icons.camera_alt_rounded;
  static const IconData gallery = Icons.photo_library_rounded;
  static const IconData changePhoto = Icons.photo_camera_back_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData timer = Icons.timer_outlined;
  static const IconData history = Icons.history_rounded;

  // Update flow icons.
  static const IconData update = Icons.system_update_alt_rounded;
  static const IconData updateRequired = Icons.priority_high_rounded;
  static const IconData verified = Icons.verified_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData download = Icons.download_sharp;

  // Snackbar / status icons.
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
}
