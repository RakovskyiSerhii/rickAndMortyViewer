import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_viewer/models/Episode.dart';
import 'package:rick_and_morty_viewer/ui/screens/characters_for_episode/CharacterForSth.dart';

class EpisodeItemWidget extends StatelessWidget {
  final Episode _episode;

  const EpisodeItemWidget(Key key, this._episode) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      width: double.infinity,
      child: Card(
        elevation: 3,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, CharacterForSthPage.route,
              arguments: _episode),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_episode.episode}",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text("${_episode.name}",
                    style: Theme.of(context).textTheme.bodyText2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.ondemand_video,
                    ),
                    Text(" ${_episode.air_date}",
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
