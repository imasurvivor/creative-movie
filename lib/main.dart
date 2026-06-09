import 'dart:async';

import 'package:about/about.dart';
import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:authentication/presentation/pages/signup_pages.dart';
import 'package:core/common/http_ssl_pinning.dart';

import 'package:core/core.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/home_page.dart';
import 'package:ditonton/on_boarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/pages/search_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_series/presentation/bloc/popular_series_bloc.dart';
import 'package:tv_series/presentation/bloc/series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_series_bloc.dart';
import 'package:tv_series/presentation/pages/home_series_page.dart';
import 'package:tv_series/presentation/pages/popular_series_page.dart';
import 'package:tv_series/presentation/pages/series_detail_page.dart';
import 'package:tv_series/presentation/pages/top_rated_series_page.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';
import 'package:authentication/presentation/pages/authentication_pages.dart';
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await HttpSslPinning.init();
//   await Firebase.initializeApp();
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

//   di.init();
//   runApp(MyApp());
// }

Future<void> main() async {
  const bool isTest = bool.fromEnvironment('FLUTTER_DRIVER');
  if (isTest) {
    enableFlutterDriverExtension();
  }
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await HttpSslPinning.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  di.init();
  runApp(MyApp());
  runZonedGuarded(
    () async {},
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<AuthBloc>()),
        BlocProvider(
          create: (_) => di.locator<NowPlayingMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),

        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),

        //series
        BlocProvider(
          create: (_) => di.locator<PopularSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SeriesDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedSeriesListBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistSeriesBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: AuthenticationPage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case RegisterPage.routeName:
              return MaterialPageRoute(builder: (_) => RegisterPage());
            case AuthenticationPage.routeName:
              return MaterialPageRoute(builder: (_) => AuthenticationPage());
            case HomePage.routeName:
              return MaterialPageRoute(builder: (_) => HomePage());
            case OnBoarding.routeName:
              return MaterialPageRoute(builder: (_) => OnBoarding());
            case HomeMoviePage.routeName:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.routeName:
              return MaterialPageRoute(builder: (_) => TopRatedMoviesPage());
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return MaterialPageRoute(builder: (_) => SearchPage());
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => WatchlistPage());

            //series
            case HomeTvSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case TvSeriesDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case PopularSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => PopularSeriesPage());

            case TopRatedSeriesPage.routeName:
              return MaterialPageRoute(builder: (_) => TopRatedSeriesPage());

            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => AboutPage());

            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
