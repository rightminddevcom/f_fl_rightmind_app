import 'package:cpanal/modules/choose_domain/choose_domin_screen.dart';
import 'package:cpanal/modules/complain_screen/complain_details_screen.dart';
import 'package:cpanal/modules/complain_screen/complains_screen.dart';
import 'package:cpanal/modules/cpanel/auto_response/auto_response_screen.dart';
import 'package:cpanal/modules/cpanel/dns/dns_screen.dart';
import 'package:cpanal/modules/cpanel/email_account/email_account_screen.dart';
import 'package:cpanal/modules/cpanel/email_filter/email_filter_screen.dart';
import 'package:cpanal/modules/cpanel/email_filter/filter_email_screen.dart';
import 'package:cpanal/modules/cpanel/email_forward/email_forward_screen.dart';
import 'package:cpanal/modules/cpanel/ssl/ssl_controller_screen.dart';
import 'package:cpanal/modules/dashboard/dashboard_screen.dart';
import 'package:cpanal/modules/home/view/home_screen.dart';
import 'package:cpanal/modules/points_screen/points_screen.dart';
import 'package:cpanal/modules/points_screen/widgets/select_contact_screen.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../general_services/app_config.service.dart';
import '../general_services/general_listener.dart';
import '../general_services/internet_check.dart';
import '../modules/authentication/views/login_screen.dart';
import '../modules/authentication/views/update_main_data.dart';
import '../modules/complain_screen/add_complain_screen.dart';
import '../modules/cpanel/ftp/ftp_account_screen.dart';
import '../modules/cpanel/sql/sql_account_screen.dart';
import '../modules/main_screen/views/main_screen.dart';
import '../modules/more/views/more_screen.dart';
import '../modules/more/views/notification/view/notification_details_screen.dart';
import '../modules/more/views/user_devices/user_devices_screen.dart';
import '../modules/offline/views/offline_screen.dart';
import '../modules/pages/default_details.dart';
import '../modules/pages/default_list_page.dart';
import '../modules/pages/default_page.dart';
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
  DominDashboard,
  webViewMainDataScreen,
  notification,
  personalProfile2,
  defaultSinglePage,
  defaultListPage,
  complainDetails,
  defaultPage,
  AutoResponse,
  langSettingScreen,
  blog,
  blogDetails,
  requestDetails,
  notifications,
  more,
  newRequestScreen,
  updatePassword,
  EmailAccount,
  userDevices,
  EmailForward,
  FilterEmail,
  EmailFilter,
  SqlAccounts,
  FTPAccounts,
  SslController,
  DnsScreen,
  personalProfile,
  contactUs,
  faqScreen,
  aboutUsScreen,
  newComplainScreen,
  ComplainScreen,
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

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter(BuildContext context) => GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/${context.locale.languageCode}/splash-screen',
      refreshListenable:         Provider.of<AppConfigService>(context),
      redirect: (context, state) {
        final appConfigServiceProvider =
            Provider.of<AppConfigService>(context, listen: false);
        final isLoggedIn = appConfigServiceProvider.isLogin &&
            appConfigServiceProvider.token.isNotEmpty;
        final lang = state.pathParameters['lang'] ?? 'en';
        context.setLocale(Locale(lang));
            appConfigServiceProvider.token.isNotEmpty;
        final connectionService = Provider.of<ConnectionService>(context, listen: false);


        context.setLocale(Locale(lang));

        // 🌐 Offline redirection
        // if (!isConnected && !(state.fullPath?.contains('offline') ?? false)) {
        //   return '/$lang/offline-screen';
        // }
        if (!connectionService.isConnected &&
            !(state.fullPath?.contains('offline') ?? false)) {
          return '/$lang/offline-screen';
        }
        if (isLoggedIn && state.fullPath?.contains('login') == true) {
          var update = CacheHelper.getString("update_url");
          if (update != null && update.isNotEmpty && update != "") {
            return '/$lang/webviewMainData';
          }
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
                  parentNavigatorKey: rootNavigatorKey,
                  name: AppRoutes.personalProfile2.name,
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
                ),
                GoRoute(
                  path: 'more',
                  parentNavigatorKey: rootNavigatorKey,
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
                      path: 'userDevices-screen',
                      parentNavigatorKey: rootNavigatorKey,
                      name: AppRoutes.userDevices.name,
                      builder: (context, state) => UserDeviceScreen(),
                    ),
                    GoRoute(
                      path: 'personal-profile',
                      parentNavigatorKey: rootNavigatorKey,
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
                    ),
                    GoRoute(
                      path: 'update-password',
                      parentNavigatorKey: rootNavigatorKey,
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
                      parentNavigatorKey: rootNavigatorKey,
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
                      parentNavigatorKey: rootNavigatorKey,
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
                        parentNavigatorKey: rootNavigatorKey,
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
                        path: 'complainScreen',
                        parentNavigatorKey: rootNavigatorKey,
                        name: AppRoutes.ComplainScreen.name,
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
                            child: ComplainScreen(),
                            animation: animationController,
                            begin: begin ?? const Offset(1.0, 0.0),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: 'newComplainScreen',
                            parentNavigatorKey: rootNavigatorKey,
                            name: AppRoutes.newComplainScreen.name,
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
                                child: NewComplainScreen(),
                                animation: animationController,
                                begin: begin ?? const Offset(1.0, 0.0),
                              );
                            },
                          ),
                          GoRoute(
                            path: 'complainDetailsScreen/:id',
                            parentNavigatorKey: rootNavigatorKey,
                            name: AppRoutes.complainDetails.name,
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
                                child: ComplainDetailsScreen(id : id),
                                animation: animationController,
                                begin: begin ?? const Offset(1.0, 0.0),
                              );
                            },
                          ),
                        ]
                    ),
                    GoRoute(
                      path: 'contact-us',
                      parentNavigatorKey: rootNavigatorKey,
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
                    GoRoute(
                      path: 'lang-setting-screen',
                      parentNavigatorKey: rootNavigatorKey,
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
                        path: 'notification-screen',
                        parentNavigatorKey: rootNavigatorKey,
                        name: AppRoutes.notification.name,
                        builder: (context, state) => NotificationScreen(true),
                        routes: [
                          GoRoute(
                            path: 'notification-details-screen/:id',
                            parentNavigatorKey: rootNavigatorKey,
                            name: AppRoutes.notificationDetails.name,
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
                                child: SingleListDetailsScreen(
                                  id: id,
                                ),
                                animation: animationController,
                                begin: begin ?? const Offset(1.0, 0.0),
                              );
                            },
                          ),
                        ]
                    ),
                    GoRoute(
                      path: 'default-page/:type',
                      parentNavigatorKey: rootNavigatorKey,
                      name: AppRoutes.defaultPage.name,
                      pageBuilder: (context, state) {
                        Offset? begin = state.extra as Offset?;
                        final lang = state.uri.queryParameters['lang'];
                        final type = state.pathParameters['type'] ?? '';

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
                          child: DefaultPage(type),
                          animation: animationController,
                          begin: begin ?? const Offset(1.0, 0.0),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'default-list-page/:type',
                      parentNavigatorKey: rootNavigatorKey,
                      name: AppRoutes.defaultListPage.name,
                      pageBuilder: (context, state) {
                        Offset? begin = state.extra as Offset?;
                        final lang = state.uri.queryParameters['lang'];
                        final type = state.pathParameters['type'] ?? '';
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
                          child: DefaultListPage(type: type,),
                          animation: animationController,
                          begin: begin ?? const Offset(1.0, 0.0),
                        );
                      },
                    ),
                    GoRoute(
                      path: 'default-single-page/:type/:id',
                      parentNavigatorKey: rootNavigatorKey,
                      name: AppRoutes.defaultSinglePage.name,
                      pageBuilder: (context, state) {
                        Offset? begin = state.extra as Offset?;
                        final lang = state.uri.queryParameters['lang'];
                        final type = state.pathParameters['type'] ?? '';
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
                          child: DefaultDetails(type: type, id: id,),
                          animation: animationController,
                          begin: begin ?? const Offset(1.0, 0.0),
                        );
                      },
                    ),
                    GoRoute(
                        path: 'blog-screen',
                        parentNavigatorKey: rootNavigatorKey,
                        name: AppRoutes.blog.name,
                        builder: (context, state) => BlogScreen(),
                        routes: [
                          GoRoute(
                            path: 'blog_details/:title',
                            parentNavigatorKey: rootNavigatorKey,
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
                        ]
                    ),
                  ],
                ),
                GoRoute(
                  path: 'chooseDomain',
                  parentNavigatorKey: rootNavigatorKey,
                  name: AppRoutes.chooseDomain.name,
                  builder: (context, state) => ChooseDomainScreen(),
                  routes: [
                    GoRoute(
                      path: 'domain-dashboard/:id/:name',
                      parentNavigatorKey: rootNavigatorKey,
                      name: AppRoutes.DominDashboard.name,
                      pageBuilder: (context, state) {
                        final lang = state.uri.queryParameters['lang'];
                        final name = state.pathParameters['name'] ?? '';
                        final id = state.pathParameters['id'] ?? '';
                        final extra = state.extra as EmailAccountExtra?;
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
                          child: DashboardScreen(
                            dominId: id,
                            name: name,
                            userPermissions: extra?.permissions ?? [],
                          ),
                          animation: animationController,
                          begin: const Offset(1.0, 0.0),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'email-account',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.EmailAccount.name,
                          pageBuilder: (context, state) {
                            final extra = state.extra as EmailAccountExtra?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: EmailAccountScreen(
                                name: name,
                                dominId: id,
                                permissions: extra?.permissions ?? [],
                              ),
                              animation: animationController,
                              begin: extra?.begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'email-forward',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.EmailForward.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: EmailForwardScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'auto-response',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.AutoResponse.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: AutoResponseScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'ftp-accounts',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.FTPAccounts.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: FTPAccountsScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'sql-accounts',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.SqlAccounts.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: SqlAccountsScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'dns-screen',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.DnsScreen.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: DNSScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                          path: 'ssl-screen',
                          parentNavigatorKey: rootNavigatorKey,
                          name: AppRoutes.SslController.name,
                          pageBuilder: (context, state) {
                            Offset? begin = state.extra as Offset?;
                            final id = state.pathParameters['id'] ?? '';
                            final name = state.pathParameters['name'] ?? '';

                            final animationController = AnimationController(vsync: ticker);
                            animationController.addStatusListener((status) {
                              if (status == AnimationStatus.completed ||
                                  status == AnimationStatus.dismissed) {
                                animationController.dispose();
                              }
                            });

                            return AppRouterTransitions.slideTransition(
                              key: state.pageKey,
                              child: SSLControllerScreen(
                                name: name,
                                dominId: id,
                              ),
                              animation: animationController,
                              begin: begin ?? const Offset(1.0, 0.0),
                            );
                          },
                        ),
                        GoRoute(
                            path: 'email-filter',
                            parentNavigatorKey: rootNavigatorKey,
                            name: AppRoutes.EmailFilter.name,
                            pageBuilder: (context, state) {
                              Offset? begin = state.extra as Offset?;
                              final id = state.pathParameters['id'] ?? '';
                              final name = state.pathParameters['name'] ?? '';

                              final animationController = AnimationController(vsync: ticker);
                              animationController.addStatusListener((status) {
                                if (status == AnimationStatus.completed ||
                                    status == AnimationStatus.dismissed) {
                                  animationController.dispose();
                                }
                              });
                              return AppRouterTransitions.slideTransition(
                                key: state.pageKey,
                                child: EmailFilterScreen(
                                  name: name,
                                  dominId: id,
                                ),
                                animation: animationController,
                                begin: begin ?? const Offset(1.0, 0.0),
                              );
                            },
                            routes: [
                              GoRoute(
                                path: 'filter-email/:email',
                                parentNavigatorKey: rootNavigatorKey,
                                name: AppRoutes.FilterEmail.name,
                                pageBuilder: (context, state) {
                                  Offset? begin = state.extra as Offset?;
                                  final id = state.pathParameters['id'] ?? '';
                                  final name = state.pathParameters['name'] ?? '';
                                  final email = state.pathParameters['email'] ?? '';
                                  final animationController = AnimationController(vsync: ticker);
                                  animationController.addStatusListener((status) {
                                    if (status == AnimationStatus.completed ||
                                        status == AnimationStatus.dismissed) {
                                      animationController.dispose();
                                    }
                                  });

                                  return AppRouterTransitions.slideTransition(
                                    key: state.pageKey,
                                    child: FilterEmailScreen(
                                      email: email,
                                      name: name,
                                      dominId: id,
                                    ),
                                    animation: animationController,
                                    begin: begin ?? const Offset(1.0, 0.0),
                                  );
                                },
                              ),
                            ]
                        ),

                      ]
                    ),
                  ]
                ),
                GoRoute(
                  path: 'points-screen',
                  parentNavigatorKey: rootNavigatorKey,
                  name: AppRoutes.pointsScreen.name,
                  builder: (context, state) => PointsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/:lang/offline-screen',
          parentNavigatorKey: rootNavigatorKey,
          name: AppRoutes.offlineScreen.name,
          builder: (context, state) => const OfflineScreen(),
        ),
        GoRoute(
          path: '/:lang/webviewMainData',
          parentNavigatorKey: rootNavigatorKey,
          name: AppRoutes.webViewMainDataScreen.name,
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
              child: WebViewStackMainData(),
              animation: animationController,
              begin: begin ?? const Offset(1.0, 0.0),
            );
          },
        ),
        GoRoute(
          path: '/:lang/splash-screen',
          parentNavigatorKey: rootNavigatorKey,
          name: AppRoutes.splash.name,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/:lang/onboarding-screen',
          parentNavigatorKey: rootNavigatorKey,
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
          parentNavigatorKey: rootNavigatorKey,
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
      ],
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => const NotFoundScreen(),
    );
