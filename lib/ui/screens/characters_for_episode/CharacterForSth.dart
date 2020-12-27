import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_viewer/bloc/CharacterForSthBlock.dart';
import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/models/Location.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';
import 'package:rick_and_morty_viewer/ui/screens/character_list/CharacterItem.dart';
import 'package:rick_and_morty_viewer/ui/screens/episodes/EpisodesPage.dart';
import 'package:rick_and_morty_viewer/ui/screens/locations/LocationsPage.dart';
import 'package:rick_and_morty_viewer/ui/widgets/NetworkError.dart';
import 'package:rick_and_morty_viewer/ui/widgets/ServerError.dart';
import 'package:rick_and_morty_viewer/util/Const.dart';
import 'package:rick_and_morty_viewer/util/progress_skeleton.dart';
import 'package:sprintf/sprintf.dart';

class CharacterForSthPage extends StatefulWidget {
  static const route = "/character/for_episode";

  @override
  _CharacterForSthPageState createState() => _CharacterForSthPageState();
}

class _CharacterForSthPageState extends State<CharacterForSthPage> {
  CharacterForSthBlock _block;
  bool _isByEpisode = true;
  bool _isShowModalSheet = false;

  @override
  void initState() {
    _block = CharacterForSthBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Episode episode;
    Location location;
    if (ModalRoute.of(context).settings.arguments is Episode) {
      episode = ModalRoute.of(context).settings.arguments;
      _block.getCharacterForEpisode(episode);
    } else {
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      location = Location.onlyName(args[Const.Location_KEY]);
      _block.getLocation(args[Const.URL_KEY]);
      _isByEpisode = false;
    }
    _block.errorStream.listen((event) {
      if (event == null) return;
      if (!_isShowModalSheet && !event.isNetworkError()) {
        _isShowModalSheet = true;
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return ServerError(event.message);
            }).then((value) {
          _isShowModalSheet = false;
          Navigator.pop(context);
        });
      }
    });

    final textTitle = _isByEpisode
        ? sprintf(
            Strings.get(context, Strings.CHARACTER_FOR), [episode.episode])
        : sprintf(
            Strings.get(context, Strings.CHARACTER_FROM), [location.name]);
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageContent(episode, location),
            navigationBar: CupertinoNavigationBar(
              brightness: Brightness.dark,
              leading: CupertinoNavigationBarBackButton(
                color: Colors.white,
              ),
              trailing: GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Container(
                  child: Text(
                    Strings.get(context, Strings.HOME_STRING),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              backgroundColor: Theme.of(context).appBarTheme.color,
              border: null,
              middle: Text(
                _isByEpisode ? Strings.get(context, Strings.BY_EPISODE) : Strings.get(context, Strings.BY_LOCATION),
                style: Theme.of(context).appBarTheme.textTheme.headline1,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      Strings.get(context, Strings.HOME_STRING),
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                )
              ],
              title: _pageTitle(textTitle),
            ),
            body: _pageContent(episode, location));
  }

  Text _pageTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).appBarTheme.textTheme.headline1,
    );
  }

  Widget _pageContent(Episode episode, Location location) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Theme.of(context).primaryColor, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.5]),
      ),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: _block.errorStream,
              builder: (ctx, snapshot) {
                Failure failure = snapshot.data;
                if (failure != null && failure.isNetworkError()) {
                  return ErrorStub.fullScreen(() {
                    if (_isByEpisode)
                      _block.getCharacterForEpisode(episode);
                    else
                      _block.getLocation(location.name);
                  });
                } else
                  return _contentList(episode, location);
              },
            ),
          )
        ],
      ),
    );
  }

  void _changeSourceDataScreen() {
    Navigator.pushReplacementNamed(context, _getNamedRoute());
  }

  String _getNamedRoute() =>
      _isByEpisode ? EpisodesPage.route : LocationsPage.route;

  Widget _contentList(Episode episode, Location location) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: _isByEpisode
                ? _episodeContainer(episode)
                : _locationContainer(location),
          ),
          StreamBuilder(
            stream: _block.characterListStream,
            builder: (ctx, snapshot) {
              if (snapshot.data != null) {
                final List<Character> list = snapshot.data;
                return Column(
                  children: [
                    ...list.map((character) => CharacterItem(
                        key: ValueKey(character.id), character: character)),
                  ],
                );
              } else
                return SkeletonLoader.character();
            },
          ),
        ],
      ),
    );
  }

  Widget _episodeContainer(Episode episode) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${episode.name}",
                        style: Theme.of(context).textTheme.bodyText2),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.ondemand_video,
                          ),
                          Text(" ${episode.air_date}",
                              style: Theme.of(context).textTheme.bodyText2)
                        ])
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topRight,
            child: Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _changeSourceDataScreen(),
                child:
                    Container(height: 30, width: 30, child: Icon(Icons.edit)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationContainer(Location location) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                StreamBuilder<Location>(
                    stream: _block.locationStream,
                    builder: (context, snapshot) {
                      if (snapshot.data == null)
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${location.name}\n",
                                style: Theme.of(context).textTheme.bodyText2),
                            Text(
                                Strings.get(
                                    context, Strings.TYPE_LOADING_STRING),
                                style: Theme.of(context).textTheme.bodyText2)
                          ],
                        );
                      else {
                        Location remoteLocation = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${remoteLocation.name}\n${remoteLocation.dimension}",
                                style: Theme.of(context).textTheme.bodyText2),
                            Text(
                                sprintf(
                                    Strings.get(context, Strings.TYPE_STRING),
                                    [remoteLocation.type]),
                                style: Theme.of(context).textTheme.bodyText2)
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.topRight,
            child: Material(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _changeSourceDataScreen(),
                child:
                    Container(height: 30, width: 30, child: Icon(Icons.edit)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
