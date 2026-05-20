import 'package:about/about.dart';
import 'package:authentication/presentation/pages/authentication_pages.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie/presentation/bloc/movie_list_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:provider/provider.dart';
import 'package:search/presentation/pages/search_pages.dart';
import 'package:tv_series/presentation/bloc/series_list_bloc.dart';
import 'package:tv_series/presentation/pages/home_series_page.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final List<String> _tabTitle = ['Movies', 'Tv Series'];
  final List<Widget> _page = [HomeMoviePage(), HomeTvSeriesPage()];
  void _onSelectedPage(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NowPlayingMovieListBloc>(context, listen: false)
          .add(MovieListEvent());
      Provider.of<PopularMovieListBloc>(context, listen: false)
          .add(MovieListEvent());
      Provider.of<TopRatedMovieListBloc>(context, listen: false)
          .add(MovieListEvent());
    });
    Future.microtask(() {
      Provider.of<SeriesListBloc>(context, listen: false)
          .add(SeriesListEvent());
      Provider.of<PopularSeriesListBloc>(context, listen: false)
          .add(SeriesListEvent());
      Provider.of<TopRatedSeriesListBloc>(context, listen: false)
          .add(SeriesListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Creative movie',
                  style: kHeading6.copyWith(
                      fontSize: 17, color: kColorScheme.secondary)),
              accountEmail: Text('creative_movie@dicoding.com',
                  style: kSubtitle.copyWith(color: kColorScheme.secondary)),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text(_tabTitle[0], style: kSubtitle),
              onTap: () {
                _onSelectedPage(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text(_tabTitle[1], style: kSubtitle),
              onTap: () {
                _onSelectedPage(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist', style: kSubtitle),
              onTap: () {
                Navigator.pushNamed(context, WatchlistPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.routeName);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About', style: kSubtitle),
            ),
            ElevatedButton(
                onPressed: () async {
                  // if (TargetPlatform.android == defaultTargetPlatform) {
                  //   SystemNavigator.pop();
                  // }
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(
                      context, AuthenticationPage.routeName);
                },
                child: Text('Logout'))
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('${_tabTitle[_index]}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _page[_index],
    );
  }
}
