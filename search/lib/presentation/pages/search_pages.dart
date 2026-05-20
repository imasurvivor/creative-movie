import 'dart:developer';

import 'package:core/core.dart';

import 'package:core/domain/entities/movie/movie.dart';
import 'package:core/domain/entities/tv_series/series.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMovieBloc>().add(OnQueryChanged(query));
                context.read<SearchTvSeriesBloc>().add(OnQueryChanged(query));
                // FirebaseCrashlytics.instance.crash();
              },
              decoration: InputDecoration(
                  hintText: 'Search Title',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24)),
                  contentPadding: const EdgeInsets.all(12)),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Movies',
              style: kHeading6,
            ),
            const SizedBox(
              height: 16,
            ),
            const Flexible(child: _SearchMovies()),
            const SizedBox(height: 16),
            Text(
              'Series',
              style: kHeading6,
            ),
            const SizedBox(height: 16),
            const Flexible(fit: FlexFit.loose, child: _SearchSeries())
          ],
        ),
      ),
    );
  }
}

class _SearchMovies extends StatelessWidget {
  const _SearchMovies();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchMovieBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchHasData<Movie>) {
          final result = state.searchResult;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final movie = result[index];
              return MovieCard(movie);
            },
            itemCount: result.length,
          );
        } else if (state is SearchEmpty) {
          return Center(
            child: Text('No Result Found :(', style: kSubtitle),
          );
        } else if (state is SearchError) {
          return Center(
            child: Text(state.message, style: kSubtitle),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class _SearchSeries extends StatelessWidget {
  const _SearchSeries();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchTvSeriesBloc, SearchState>(
      builder: (context, state) {
        log(state.runtimeType.toString());
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchHasData<TvSeries>) {
          final result = state.searchResult;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final tvSeries = result[index];
              return TvSeriesCard(tvSeries);
            },
            itemCount: result.length,
          );
        } else if (state is SearchEmpty) {
          log(state.message);
          return Center(
            child: Text('No Result Found :(', style: kSubtitle),
          );
        } else if (state is SearchError) {
          return Center(
            child: Text(state.message, style: kSubtitle),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
