import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:referral_test/src/features/campaigns/presentation/campaigns_screen.dart';
import 'package:referral_test/src/features/membership/presentation/membership_screen.dart';
import 'package:referral_test/src/features/points/presentation/points_screen.dart';
import 'package:referral_test/src/features/referral/presentation/referral_screen.dart';
import 'package:referral_test/src/presentation/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  initialLocation: '/home',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const CampaignsScreen(),
        ),
        GoRoute(
          path: '/membership',
          builder: (context, state) => const MembershipScreen(),
        ),
        GoRoute(
          path: '/refer',
          builder: (context, state) => const ReferralScreen(),
        ),
        GoRoute(
          path: '/points',
          builder: (context, state) => const PointsScreen(),
        ),
      ],
    ),
  ],
);
