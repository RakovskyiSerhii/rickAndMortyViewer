import 'package:flutter/material.dart';
import 'package:rick_and_morty_viewer/bloc/LocationBlock.dart';
import 'package:rick_and_morty_viewer/models/Location.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';
import 'package:rick_and_morty_viewer/ui/screens/characters_for_episode/CharacterForSth.dart';
import 'package:rick_and_morty_viewer/util/Const.dart';
import 'package:rick_and_morty_viewer/util/progress_skeleton.dart';
import 'package:sprintf/sprintf.dart';

class LocationsPage extends StatefulWidget {
  static const route = "/locations";

  @override
  _LocationsPageState createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  LocationBlock _block;

  final _scrollController = ScrollController();

  void _getOtherPage() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      _block.getNextPage();
    }
  }

  @override
  void initState() {
    _block = LocationBlock();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_getOtherPage);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.get(context, Strings.TOOLBAR_LOCATION)),
      ),
      body: StreamBuilder(
        stream: _block.locationStream,
        builder: (ctx, snapshot) {
          if (snapshot.data != null) {
            final list = snapshot.data;
            return ListView.builder(
              itemBuilder: (ctx, index) => _itemLocation(list[index]),
              itemCount: list.length,
              controller: _scrollController,
            );
          } else
            return SingleChildScrollView(
              child: SkeletonLoader.location(
                count: 6,
              ),
            );
        },
      ),
    );
  }

  Widget _itemLocation(Location location) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openCharacters(location),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  location.dimension == Strings.get(context, Strings.UNKNOWN_STRING)
                      ? Strings.get(context, Strings.DIMENSION_UNKNOWN)
                      : location.dimension,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  sprintf(Strings.get(context, Strings.TYPE_STRING), [location.type]),
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openCharacters(Location location) {
    Navigator.pushReplacementNamed(context, CharacterForSthPage.route,
        arguments: {
          Const.Location_KEY: location.name,
          Const.URL_KEY: location.url,
        });
  }
}
