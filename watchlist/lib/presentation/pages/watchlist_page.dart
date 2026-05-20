import 'package:core/core.dart';
import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/tv_series/series.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const routeName = '/watchlist-page';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieBloc>(context, listen: false)
            .add(const WatchlistEvent()));
    Future.microtask(() =>
        Provider.of<WatchlistSeriesBloc>(context, listen: false)
            .add(const WatchlistEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieBloc>(context, listen: false)
        .add(const WatchlistEvent());
    Provider.of<WatchlistSeriesBloc>(context, listen: false)
        .add(const WatchlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              'Movies',
              style: kHeading6,
            ),
            const Flexible(child: WatchListMovies()),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Series',
              style: kHeading6,
            ),
            const Flexible(child: WatchListSeries())
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

class WatchListMovies extends StatelessWidget {
  const WatchListMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistHasData<Movie>) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.watchlistResult[index];
                return MovieCard(movie);
              },
              itemCount: state.watchlistResult.length,
            );
          } else if (state is WatchlistEmpty) {
            return Center(
              child: Text(state.message, style: kSubtitle),
            );
          } else if (state is WatchlistError) {
            return Center(
              child: Text(state.message, style: kSubtitle),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class WatchListSeries extends StatelessWidget {
  const WatchListSeries({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistSeriesBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistHasData<TvSeries>) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = state.watchlistResult[index];
                return TvSeriesCard(tvSeries);
              },
              itemCount: state.watchlistResult.length,
            );
          } else if (state is WatchlistEmpty) {
            return Center(
              child: Text(state.message, style: kSubtitle),
            );
          } else if (state is WatchlistError) {
            return Center(
              child: Text(state.message, style: kSubtitle),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
