import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_state.dart';
import 'home_view.dart';
import 'first_view.dart';
import 'maps.dart';
import 'profile_view.dart';
import 'settings_view.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const Profile();
          },
        ),
        GoRoute(
          path: '/map',
          builder: (BuildContext context, GoRouterState state) {
            return Maps(
              actions: [
                SignedOutAction(
                  (context) {
                    context.pushReplacement('/home');
                  },
                ),
              ],
            );
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const Settings();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (BuildContext context, GoRouterState state) {
        return context.watch<ApplicationState>().loggedIn
            ? AppScaffold(
                child: Maps(
                  actions: [
                    SignedOutAction(
                      (context) {
                        context.pushReplacement('/home');
                      },
                    ),
                  ],
                ),
              )
            : const FirstView();
      },
    ),
    GoRoute(
      path: '/sign-in',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background(2).png"),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarHeight: 200,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Image.asset(
                'assets/logo/dog_paw_logo.png',
                height: 120,
                width: 120,
                color: Colors.white,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            body: SignInScreen(
              actions: [
                ForgotPasswordAction(
                  ((context, email) {
                    final uri = Uri(
                      path: '/sign-in/forgot-password',
                      queryParameters: <String, String?>{
                        'email': email,
                      },
                    );
                    context.push(
                      uri.toString(),
                    );
                  }),
                ),
                AuthStateChangeAction(
                  ((context, state) {
                    if (state is SignedIn || state is UserCreated) {
                      var user = (state is SignedIn)
                          ? state.user
                          : (state as UserCreated).credential.user;
                      if (user == null) {
                        return;
                      }
                      if (state is UserCreated) {
                        user.updateDisplayName(user.email!.split('@')[0]);
                      }
                      if (!user.emailVerified) {
                        user.sendEmailVerification();
                        const snackBar = SnackBar(
                            backgroundColor: Palette.primary,
                            content: Text(
                                'Please check your email to verify your email address!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      context.pushReplacement('/home');
                    }
                  }),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
);

class Palette {
  static const Color primary = Color(0xffFF966A);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dog App',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
        //primaryColor: const Color(0xffFF966A),
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Palette.primary.withOpacity(0.3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Palette.primary,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              color: Palette.primary,
              width: 3.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.red.shade900,
              width: 3.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Colors.red.shade900,
              width: 3.0,
            ),
          ),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme.apply(
                fontSizeFactor: 1.1,
                bodyColor: Colors.white,
                displayColor: Colors.white,
                decorationColor: Colors.white,
              ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}
