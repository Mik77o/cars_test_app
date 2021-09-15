import 'package:cars_app/pages/cars_list_page.dart';
import 'package:cars_app/translations/codegen_loader.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      assetLoader: CodegenLoader(),
      supportedLocales: [Locale('en'), Locale('pl')],
      path: 'assets/translations',
      fallbackLocale: Locale('pl'),
      child: ProviderScope(child: MyApp())));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff1c313a),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: SpinKitSquareCircle(
        color: Color(0xff1c313a),
      ),
      child: MaterialApp(
        title: 'Cars App',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff455a64, primarySwatchColor),
          textTheme: GoogleFonts.exo2TextTheme(),
          brightness: Brightness.light,
          buttonColor: Color(0xff455a64),
          accentColor: Color(0xff455a64),
          primaryColor: Color(0xff455a64),
          primaryColorDark: Color(0xff1c313a),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            textTheme: TextTheme(
              headline6: GoogleFonts.exo2(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        home: CarsListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  final Map<int, Color> primarySwatchColor = {
    50: Color.fromRGBO(69, 90, 100, .1),
    100: Color.fromRGBO(69, 90, 100, .2),
    200: Color.fromRGBO(69, 90, 100, .3),
    300: Color.fromRGBO(69, 90, 100, .4),
    400: Color.fromRGBO(69, 90, 100, .5),
    500: Color.fromRGBO(69, 90, 100, .6),
    600: Color.fromRGBO(69, 90, 100, .7),
    700: Color.fromRGBO(69, 90, 100, .8),
    800: Color.fromRGBO(69, 90, 100, .9),
    900: Color.fromRGBO(69, 90, 100, 1),
  };
}
