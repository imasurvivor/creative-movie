import 'package:authentication/domain/usecases/auth.dart';
import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:core/common/http_ssl_pinning.dart';
import 'package:core/core.dart';
import 'package:core/data/repositories/auth_reposityory_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_bloc.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:tv_series/domain/usecases/get_now_playing_series.dart';
import 'package:tv_series/domain/usecases/get_popular_series.dart';
import 'package:tv_series/domain/usecases/get_series_detail.dart';
import 'package:tv_series/domain/usecases/get_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_top_rated_series.dart';
import 'package:tv_series/presentation/bloc/popular_series_bloc.dart';
import 'package:tv_series/presentation/bloc/series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/series_list_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_series_bloc.dart';
import 'package:watchlist/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecases/movie/get_watchlist_status.dart';

import 'package:watchlist/domain/usecases/movie/remove_watchlist.dart';
import 'package:watchlist/domain/usecases/movie/save_watchlist.dart';
import 'package:watchlist/domain/usecases/tv_series/get_watchlist_series.dart';
import 'package:watchlist/domain/usecases/tv_series/get_watchlist_status_series.dart';
import 'package:watchlist/domain/usecases/tv_series/remove_watchlist_series.dart';
import 'package:watchlist/domain/usecases/tv_series/save_watchlist_series.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';

final locator = GetIt.instance;

void init() {
  // bloc
//Movie
  locator.registerFactory(() => NowPlayingMovieListBloc(locator()));
  locator.registerFactory(() => TopRatedMovieListBloc(locator()));
  locator.registerFactory(() => PopularMovieListBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator()));
  locator.registerFactory(
    () => TopRatedMovieBloc(locator()),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(
      locator(),
    ),
  );

//watchlist
  locator.registerFactory(() => WatchlistSeriesBloc(locator()));
  locator.registerFactory(() => WatchlistMovieBloc(locator()));

  //search
  locator.registerFactory(() => SearchMovieBloc(locator()));
  locator.registerFactory(() => SearchTvSeriesBloc(locator()));

//authentication
  locator.registerFactory(() => AuthBloc(
      loginUseCase: locator(),
      registerUseCase: locator(),
      logoutUseCase: locator(),
      isLoggedInUseCase: locator(),
      getCurrentUserIdUseCase: locator()));

//Tv Series
  locator.registerFactory(
    () => SeriesListBloc(locator()),
  );
  locator.registerFactory(
    () => SeriesDetailBloc(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularSeriesListBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedSeriesListBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedSeriesBloc(
      locator(),
    ),
  );

  // use case

  //Movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));

  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  // locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  //auth
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => SignUpUseCase(locator()));
  locator.registerLazySingleton(() => DeleteUserUseCase(locator()));
  locator.registerLazySingleton(() => LogoutUseCase(locator()));
  locator.registerLazySingleton(() => IsLoggedInUseCase(locator()));
  locator.registerLazySingleton(() => GetCurrentUserIdUseCase(locator()));

  //Tv Series
  locator.registerLazySingleton(() => GetNowPlayingTvSeriess(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeriess(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeriess(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeriess(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  //movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  //series
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  //auth
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: locator()));

  // data sources
  //movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  //auth
  locator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());

  //tvseries
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => HttpSslPinning.client);
}
