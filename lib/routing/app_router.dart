import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/home/view/home_screen.dart';
import 'package:cpanal/modules/points_screen/points_screen.dart';
import 'package:cpanal/modules/points_screen/widgets/select_contact_screen.dart';
import 'package:cpanal/modules/requests_screen/new_request_screen.dart';
import 'package:cpanal/modules/requests_screen/request_details_screen.dart';
import 'package:cpanal/modules/requests_screen/requests_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cpanal/general_services/backend_services/api_service/dio_api_service/shared.dart';
import 'package:cpanal/modules/more/views/aboutus/view/aboutus_screen.dart';
import 'package:cpanal/modules/more/views/blog/view/blog_details_screen.dart';
import 'package:cpanal/modules/more/views/blog/view/blog_screen.dart';
import 'package:cpanal/modules/more/views/contactus/view/contact_screen.dart';
import 'package:cpanal/modules/more/views/faq/view/faq_screen.dart';
import 'package:cpanal/modules/more/views/lang_setting/lang_setting_screen.dart';
import 'package:cpanal/modules/more/views/notification/view/notification_screen.dart';
import 'package:cpanal/modules/more/views/update_password/update_password_screen.dart';
import '../general_services/app_config.service.dart';
import '../modules/authentication/views/login_screen.dart';
import '../modules/main_screen/views/main_screen.dart';
import '../modules/more/views/more_screen.dart';
import '../modules/personal_profile/views/personal_profile_screen.dart';
import '../modules/splash_and_onboarding/views/onboarding_screen.dart';
import '../modules/splash_and_onboarding/views/splash_screen.dart';
import '../routing/app_router_transitions.dart';
import '../routing/not_found/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum AppRoutes {
  home,
  splash,
  onboarding,
  pointsContactScreenView,
  login,
  webViewScreen,
  offlineScreen,
  requests,
  chooseDomain,
  pointsScreen,
  notification,
  langSettingScreen,
  blog,
  blogDetails,
  requestDetails,
  notifications,
  more,
  newRequestScreen,
  updatePassword,
  personalProfile,
  contactUs,
  faqScreen,
  aboutUsScreen,
  notificationDetails
}

const TestVSync ticker = TestVSync();

class TestVSync implements TickerProvider {
  const TestVSync();
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

enum NavbarPages { home, requests, fingerprint, notifications, more }

NavbarPages getNavbarPage({required String currentLocationRoute}) {
  if (currentLocationRoute.contains('requests')) {
    return NavbarPages.requests;
  }
  if (currentLocationRoute.contains('fingerprint')) {
    return NavbarPages.fingerprint;
  }
  if (currentLocationRoute.contains('notifications')) {
    return NavbarPages.notifications;
  }
  if (currentLocationRoute.contains('more')) {
    return NavbarPages.more;
  }
  return NavbarPages.home;
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter(BuildContext context) => GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/${context.locale.languageCode}/splash-screen',
      refreshListenable: Provider.of<AppConfigService>(context),
      redirect: (context, state) {
        final appConfigServiceProvider =
            Provider.of<AppConfigService>(context, listen: false);
        final isLoggedIn = appConfigServiceProvider.isLogin &&
            appConfigServiceProvider.token.isNotEmpty;
        final lang = state.pathParameters['lang'] ?? 'en';
        context.setLocale(Locale(lang));
            appConfigServiceProvider.token.isNotEmpty;
        final isConnected = appConfigServiceProvider.isConnected;

        context.setLocale(Locale(lang));

        // 🌐 Offline redirection
        // if (!isConnected && !(state.fullPath?.contains('offline') ?? false)) {
        //   return '/$lang/offline-screen';
        // }
        if (isLoggedIn && (state.fullPath?.contains('login') ?? false)) {
          return '/$lang';
        }
        // User not logged in and the current screen not (splash - onboarding - offline)
        if (isLoggedIn == false &&
            (state.fullPath?.contains('splash') == false &&
                state.fullPath?.contains('offline') == false &&
                state.fullPath?.contains('onboarding') == false)) {
          return '/$lang/login-screen';
        }

        return null;
      },
      routes: [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MainScreen(
            key: UniqueKey(),
            currentNavPage: state.fullPath == null
                ? NavbarPages.home
                : getNavbarPage(currentLocationRoute: state.fullPath!),
            child: child,
          ),
          routes: [
            GoRoute(
              path: '/:lang',
              parentNavigatorKey: _shellNavigatorKey,
              name: AppRoutes.home.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                // Make sure to dispose the controller after the transition is complete
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: HomeScreen(),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
              routes: [
                GoRoute(
                  path: 'personal-profile',
                  parentNavigatorKey: _rootNavigatorKey,
                  name: AppRoutes.personalProfile.name,
                  pageBuilder: (context, state) {
                    Offset? begin = state.extra as Offset?;
                    final lang = state.uri.queryParameters['lang'];
                    if (lang != null) {
                      final locale = Locale(lang);
                      context.setLocale(locale);
                    }
                    final animationController = AnimationController(
                      vsync: ticker,
                    );
                    // Make sure to dispose the controller after the transition is complete
                    animationController.addStatusListener((status) {
                      if (status == AnimationStatus.completed ||
                          status == AnimationStatus.dismissed) {
                        animationController.dispose();
                      }
                    });
                    return AppRouterTransitions.slideTransition(
                      key: state.pageKey,
                      child: const PersonalProfileScreen(),
                      animation: animationController,
                      begin: begin ?? const Offset(1.0, 0.0),
                    );
                  },
                )
              ],
            ),
            GoRoute(
              path: '/:lang/notifications',
              parentNavigatorKey: _shellNavigatorKey,
              name: AppRoutes.notifications.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final animationController = AnimationController(
                  vsync: ticker,
                );
                // Make sure to dispose the controller after the transition is complete
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                CacheHelper.deleteData(key: "value");
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: NotificationScreen(false),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),

          ],
        ),
        GoRoute(
          path: '/:lang/more',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.more.name,
          pageBuilder: (context, state) {
            Offset? begin = state.extra as Offset?;
            final animationController = AnimationController(
              vsync: ticker,
            );
            // Make sure to dispose the controller after the transition is complete
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animationController.dispose();
              }
            });
            return AppRouterTransitions.slideTransition(
              key: state.pageKey,
              child: const MoreScreen(),
              animation: animationController,
              begin: begin ?? const Offset(1.0, 0.0),
            );
          },
          routes: [
            GoRoute(
              path: 'update-password',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.updatePassword.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: UpdatePasswordScreen(),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),
            GoRoute(
              path: 'about-us-screen',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.aboutUsScreen.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: AboutUsScreen(),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),
            GoRoute(
              path: 'faq-screen',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.faqScreen.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: FaqScreen(),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),
            GoRoute(
                path: 'pointsContactScreenView',
                parentNavigatorKey: _rootNavigatorKey,
                name: AppRoutes.pointsContactScreenView.name,
                pageBuilder: (context, state) {
                  Offset? begin = state.extra as Offset?;
                  final lang = state.uri.queryParameters['lang'];
                  if (lang != null) {
                    final locale = Locale(lang);
                    context.setLocale(locale);
                  }
                  final animationController = AnimationController(
                    vsync: ticker,
                  );
                  // Make sure to dispose the controller after the transition is complete
                  animationController.addStatusListener((status) {
                    if (status == AnimationStatus.completed ||
                        status == AnimationStatus.dismissed) {
                      animationController.dispose();
                    }
                  });
                  return AppRouterTransitions.slideTransition(
                    key: state.pageKey,
                    child: ContactSelectionScreen(),
                    animation: animationController,
                    begin: begin ?? const Offset(1.0, 0.0),
                  );
                },
                routes: [

                ]
            ),
            GoRoute(
              path: 'newRequestScreen/:type/:subject/:details',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.newRequestScreen.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                final type = state.pathParameters['type'] ?? '';
                final details = state.pathParameters['details'] ?? '';
                final subject = state.pathParameters['subject'] ?? '';
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                // Make sure to dispose the controller after the transition is complete
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: NewRequestScreen(type, subject, details),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),
            GoRoute(
              path: 'requestDetailsScreen/:id',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.requestDetails.name,
              pageBuilder: (context, state) {
                Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                final id = state.pathParameters['id'] ?? '';
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                // Make sure to dispose the controller after the transition is complete
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child: RequestDetailsScreen(id : id),
                  animation: animationController,
                  begin: begin ?? const Offset(1.0, 0.0),
                );
              },
            ),
            GoRoute(
              path: 'contact-us',
              parentNavigatorKey: _rootNavigatorKey,
              name: AppRoutes.contactUs.name,
              pageBuilder: (context, state) {
                // Offset? begin = state.extra as Offset?;
                final lang = state.uri.queryParameters['lang'];
                if (lang != null) {
                  final locale = Locale(lang);
                  context.setLocale(locale);
                }
                final animationController = AnimationController(
                  vsync: ticker,
                );
                animationController.addStatusListener((status) {
                  if (status == AnimationStatus.completed ||
                      status == AnimationStatus.dismissed) {
                    animationController.dispose();
                  }
                });
                return AppRouterTransitions.slideTransition(
                  key: state.pageKey,
                  child:  ContactScreen(),
                  animation: animationController,
                  begin: const Offset(1.0, 0.0),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: '/:lang/splash-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.splash.name,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/:lang/lang-setting-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.langSettingScreen.name,
          pageBuilder: (context, state) {
            Offset? begin = state.extra as Offset?;
            final lang = state.uri.queryParameters['lang'];
            if (lang != null) {
              final locale = Locale(lang);
              context.setLocale(locale);
            }
            final animationController = AnimationController(
              vsync: ticker,
            );
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animationController.dispose();
              }
            });
            return AppRouterTransitions.slideTransition(
              key: state.pageKey,
              child: LangSettingScreens(),
              animation: animationController,
              begin: begin ?? const Offset(1.0, 0.0),
            );
          },
        ),
        GoRoute(
          path: '/:lang/notification-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.notification.name,
          builder: (context, state) => NotificationScreen(true),
        ),
        // GoRoute(
        //   path: '/:lang/notification-details-screen/:id',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   name: AppRoutes.notificationDetails.name,
        //   pageBuilder: (context, state) {
        //     Offset? begin = state.extra as Offset?;
        //     final lang = state.uri.queryParameters['lang'];
        //     final id = state.pathParameters['id'] ?? '';
        //
        //     if (lang != null) {
        //       final locale = Locale(lang);
        //       context.setLocale(locale);
        //     }
        //     final animationController = AnimationController(
        //       vsync: ticker,
        //     );
        //     // Make sure to dispose the controller after the transition is complete
        //     animationController.addStatusListener((status) {
        //       if (status == AnimationStatus.completed ||
        //           status == AnimationStatus.dismissed) {
        //         animationController.dispose();
        //       }
        //     });
        //     return AppRouterTransitions.slideTransition(
        //       key: state.pageKey,
        //       child: NotificationDetailsScreen(
        //         id: id,
        //       ),
        //       animation: animationController,
        //       begin: begin ?? const Offset(1.0, 0.0),
        //     );
        //   },
        // ),
        // GoRoute(
        //   path: '/:lang/contactUs-screen',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   name: AppRoutes.contactUs.name,
        //   builder: (context, state) => ContactScreen(),
        // ),
        GoRoute(
          path: '/:lang/requests-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.requests.name,
          builder: (context, state) => RequestsScreen(),
        ),  GoRoute(
          path: '/:lang/blog-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.blog.name,
          builder: (context, state) => BlogScreen(),
        ),
        // GoRoute(
        //   path: '/:lang/more-screen',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   name: AppRoutes.more.name,
        //   builder: (context, state) => MoreScreen(),
        // ),
        GoRoute(
          path: '/:lang/points-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.pointsScreen.name,
          builder: (context, state) => PointsScreen(),
        ), GoRoute(
          path: '/:lang/chooseDomain',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.chooseDomain.name,
          builder: (context, state) => ChooseDomainScreen(),
        ),
        GoRoute(
          path: '/:lang/blog_details/:title',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.blogDetails.name,
          pageBuilder: (context, state) {
            Offset? begin = state.extra as Offset?;
            final lang = state.uri.queryParameters['lang'];
            final title = Uri.decodeComponent(state.pathParameters['title'] ?? '');
            if (lang != null) {
              final locale = Locale(lang);
              context.setLocale(locale);
            }
            final animationController = AnimationController(
              vsync: ticker,
            );
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animationController.dispose();
              }
            });
            return AppRouterTransitions.slideTransition(
              key: state.pageKey,
              child: BlogListDetailsScreen(
                title: title,
              ),
              animation: animationController,
              begin: begin ?? const Offset(1.0, 0.0),
            );
          },
        ),
        GoRoute(
          path: '/:lang/onboarding-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.onboarding.name,
          pageBuilder: (context, state) {
            final animationController = AnimationController(
              vsync: ticker,
            );
            // Make sure to dispose the controller after the transition is complete
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animationController.dispose();
              }
            });
            return AppRouterTransitions.slideTransition(
              key: state.pageKey,
              child: const OnBoardingScreen(),
              animation: animationController,
              begin: const Offset(1.0, 0.0),
            );
          },
        ),
        GoRoute(
          path: '/:lang/login-screen',
          parentNavigatorKey: _rootNavigatorKey,
          name: AppRoutes.login.name,
          pageBuilder: (context, state) {
            final animationController = AnimationController(
              vsync: ticker,
            );
            // Make sure to dispose the controller after the transition is complete
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed ||
                  status == AnimationStatus.dismissed) {
                animationController.dispose();
              }
            });
            return AppRouterTransitions.slideTransition(
              key: state.pageKey,
              child: const LoginScreen(),
              animation: animationController,
              begin: const Offset(1.0, 0.0),
            );
          },
        ),
        // GoRoute(
        //   path: '/:lang/offline-screen',
        //   parentNavigatorKey: _rootNavigatorKey,
        //   name: AppRoutes.offlineScreen.name,
        //   builder: (context, state) => const OfflineScreen(),
        // ),
      ],
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => const NotFoundScreen(),
    );
