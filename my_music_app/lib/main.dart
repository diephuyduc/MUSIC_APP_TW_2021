import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_music_app/error_bar.dart';
import 'package:my_music_app/features/show_error/error_bar_cubit.dart';
import 'package:my_music_app/injection_container.dart';
import 'package:my_music_app/page/home.dart';
import 'package:my_music_app/page/login.dart';

import 'package:my_music_app/theme_factory.dart';

import 'package:permission_handler/permission_handler.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  di.init();
}

class MyApp extends StatefulWidget {
  static const _errorBarHeight = 80.0;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> getLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    getCheckNotificationPermStatus();
    super.initState();
    
  }

  getCheckNotificationPermStatus() async {
    
    await Permission.notification.request();
    AudioService.connect();
    AudioService.connect();
    
    
  }

  @override
  Widget build(BuildContext context) {
    final theme = di.serviceLocator<ThemeFactory>().getThemeData();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      darkTheme: theme,
      home: AudioServiceWidget(
        child: Scaffold(
          body: FutureBuilder<bool>(
            future: getLogin(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == false) {
                  return Login();
                } else {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: serviceLocator<ErrorBarCubit>())
                    ],
                    child: BlocListener<ErrorBarCubit, ErrorBarStateAbstract>(
                        listener: (context, state) {
                      if (state is ShowErrorBarState) {
                        Timer(Duration(seconds: 5), () {
                          serviceLocator<ErrorBarCubit>().hide();
                        });
                      }
                    }, child: BlocBuilder<ErrorBarCubit, ErrorBarStateAbstract>(
                            builder: (context, state) {
                      final message =
                          state is ShowErrorBarState ? state.message : '';
                      final position = state is ShowErrorBarState
                          ? 0.0
                          : MyApp._errorBarHeight * -1;
                      return Stack(
                        children: [
                          MyHomePage(),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 500),
                            width: MediaQuery.of(context).size.width,
                            curve: Curves.easeInOutQuart,
                            top: position,
                            child: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 1;
                                if (details.delta.dy < -sensitivity) {
                                  serviceLocator<ErrorBarCubit>().hide();
                                }
                              },
                              child: ErrorBar(MyApp._errorBarHeight, message),
                            ),
                          ),
                        ],
                      );
                    })),
                  );
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
