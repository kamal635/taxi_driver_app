import 'package:flutter/material.dart';

abstract final class AppRouterKeys {
  const AppRouterKeys._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GlobalKey<NavigatorState> homeBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'homeBranch');

  static final GlobalKey<NavigatorState> tripsBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'tripsBranch');

  static final GlobalKey<NavigatorState> profileBranchNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'profileBranch');
}
