import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_sample_app/features/auth/presentation/ui/login_screen.dart';
import 'package:youtube_sample_app/features/cart/presentation/ui/cart_screen.dart';
import 'package:youtube_sample_app/features/dashboard/presentation/ui/dashboard_screen.dart';
import 'package:youtube_sample_app/features/home/presentation/ui/home_screen.dart';
import 'package:youtube_sample_app/features/product/presentation/ui/product_detail_screen.dart';
import 'package:youtube_sample_app/features/setting/presentation/ui/setting_screen.dart';
import 'package:youtube_sample_app/route/go_router_notifier.dart';
import 'package:youtube_sample_app/route/named_route.dart';
import 'package:youtube_sample_app/screen/error/route_error_screen.dart';

final GlobalKey<NavigatorState> _rootNavigator = GlobalKey(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigator =
    GlobalKey(debugLabel: 'shell');

final goRouterProvider = Provider<GoRouter>((ref) {
  bool isDuplicate = false;
  final notifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable:
        GoRouterRefreshListenable(FirebaseAuth.instance.authStateChanges()),

    navigatorKey: _rootNavigator,
    initialLocation: '/login',
    // refreshListenable: notifier,

    routes: [
      // IMPORTANTE - FUNCIONA A PESARDE ESTAR COMENTADA ESTA ZONA
      // GoRoute(
      //   path: '/home',
      //   name: root,
      //   builder: (context, state) => DashboardScreen(
      //     key: state.pageKey,
      //     child: HomeScreen(key: state.pageKey),
      //   ),
      // ),
      GoRoute(
        path: '/login',
        name: login,
        builder: (context, state) => LoginScreen(key: state.pageKey),
      ),
      ShellRoute(
          navigatorKey: _shellNavigator,
          builder: (context, state, child) =>
              DashboardScreen(key: state.pageKey, child: child),
          routes: [
            GoRoute(
                path: '/',
                name: home,
                pageBuilder: (context, state) {
                  return NoTransitionPage(
                      child: HomeScreen(
                    key: state.pageKey,
                  ));
                },
                routes: [
                  GoRoute(
                      parentNavigatorKey: _shellNavigator,
                      path: 'productDetail/:id',
                      name: productDetail,
                      pageBuilder: (context, state) {
                        final id = state.params['id'].toString();
                        return NoTransitionPage(
                            child: ProductDetailScreen(
                          id: int.parse(id),
                          key: state.pageKey,
                        ));
                      })
                ]),
            GoRoute(
              path: '/cart',
              name: cart,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: CartScreen(
                  key: state.pageKey,
                ));
              },
            ),
            GoRoute(
              path: '/setting',
              name: setting,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                    child: SettingScreen(
                  key: state.pageKey,
                ));
              },
            )
          ])
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
      errorMsg: state.error.toString(),
      key: state.pageKey,
    ),
    redirect: (context, state) {
      // final userRepo = injector.get<UserRepository>();

      final user = FirebaseAuth.instance;
      const authPaths = [
        '/login',
      ];
      bool isAuthPage = authPaths.contains(state.subloc);
      // print('=====in provider=====');
      // print(user.currentUser != null);
      // print(isAuthPage);
      // print(state.subloc);
      // print('=====out provider=====');

      if (user.currentUser != null) {
        if (isAuthPage) {
          // FirebaseAuth.instance.signOut();
          print('Home');
          return '/';
        }
      }
      // return '/login';
      if (user.currentUser == null) {
        if (!isAuthPage) {
          print('Login');
          return '/login';
        }
      }
      return null;

      // final isLoggedIn = notifier.isLoggedIn;
      // final isGoingToLogin = state.subloc == '/login';
      // if (!isLoggedIn && !isGoingToLogin && !isDuplicate) {
      //   isDuplicate = true;
      //   return '/login';
      // }
      // if (isGoingToLogin && isGoingToLogin && !isDuplicate) {
      //   isDuplicate = true;
      //   return '/';
      // }
      // if (isDuplicate) {
      //   isDuplicate = false;
      // }

      // return null;
    },
  );
});

class GoRouterRefreshListenable extends ChangeNotifier {
  GoRouterRefreshListenable(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
