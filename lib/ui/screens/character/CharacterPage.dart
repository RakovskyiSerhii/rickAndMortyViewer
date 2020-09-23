import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rick_and_morty_viewer/bloc/EpisodeBlock.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/ui/screens/characters_for_episode/CharacterForSth.dart';
import 'package:rick_and_morty_viewer/ui/widgets/EpisodeItemWidget.dart';
import 'package:rick_and_morty_viewer/util/Const.dart';
import 'package:rick_and_morty_viewer/util/character_bio.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class CharacterPage extends StatefulWidget {
  static const route = "/character";
  static const CHARACTER = "character";

  @override
  _CharacterPageState createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  EpisodeBlock _block;

  @override
  Widget build(BuildContext context) {
    final character = ModalRoute.of(context).settings.arguments as Character;
    _block = EpisodeBlock.loadForCharacter(character);
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                child: Container(
                  child: Text(character.name,
                      style: Theme.of(context).appBarTheme.textTheme.bodyText1),
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 2, bottom: 2, left: 4),
                ),
              ),
              background: Image.network(character.image, fit: BoxFit.fitWidth),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,
            child: _contentCharacter(character),
          ),
        ],
      ),
    );
  }

  void _openCharactersByLocationPage(String url, String name) {
    Navigator.pushNamed(context, CharacterForSthPage.route, arguments: {
      Const.Location_KEY: name,
      Const.URL_KEY: url,
    });
  }

  Widget _contentCharacter(Character character) {
    final characterBio = CharacterBioConstructor(character);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Linkify(
              text: characterBio.bio,
              style: Theme.of(context).textTheme.subtitle2,
              onOpen: (linkifyText) => _openCharactersByLocationPage(
                  characterBio.getUrl(linkifyText.text),
                  characterBio.getClearPlace(linkifyText.text)),
            ),
          ),
          StreamBuilder(
            stream: _block.errorStream,
            builder: (ctx, snapshot) {
              if (snapshot.data == null) {
                return StreamBuilder(
                  stream: _block.episodesListStream,
                  builder: (ctx, snapshot) {
                    if (snapshot.data != null) {
                      final list = snapshot.data;
                      return _listEpisodes(list);
                    } else
                      return Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: CircularProgressIndicator(),
                      );
                  },
                );
              } else {
                return _errorBuilder();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _listEpisodes(List<Episode> list) {
    return Column(
      children: [
        ...list.map((item) => EpisodeItemWidget(ValueKey(item.id), item)),
      ],
    );
  }

  Widget _errorBuilder() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () {
          _block.getEpisodesById();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.signal_wifi_off, color: Colors.white,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                ),
                Text("Connection lost. Tap to refresh", style: Theme.of(context).textTheme.headline2,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
