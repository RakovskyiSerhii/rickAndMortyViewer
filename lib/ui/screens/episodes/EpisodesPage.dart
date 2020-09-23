import 'package:flutter/material.dart';
import 'package:rick_and_morty_viewer/bloc/EpisodeBlock.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';
import 'package:rick_and_morty_viewer/ui/widgets/EpisodeItemWidget.dart';
import 'package:rick_and_morty_viewer/util/progress_skeleton.dart';

class EpisodesPage extends StatefulWidget {
  static const route = "/character/episodes";

  @override
  _EpisodesPageState createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  EpisodeBlock _block;

  final _scrollController = ScrollController();

  void _getOtherPage() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      _block.getNextPage();
    }
  }

  @override
  void initState() {
    _block = EpisodeBlock.loadAllEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_getOtherPage);
    return Scaffold(
      appBar: AppBar(title: Text(Strings.TOOLBAR_EPISODE)),
      body: StreamBuilder(
        stream: _block.episodesListStream,
        builder: (ctx, snapshot) {
          if (snapshot.data != null) {
            final list = snapshot.data;
            return ListView.builder(
              itemBuilder: (ctx, index) =>
                  EpisodeItemWidget(ValueKey(list[index]), list[index]),
              itemCount: list.length,
            );
          } else
            return SingleChildScrollView(
              child: SkeletonLoader.episode(
                count: 8,
              ),
            );
        },
      ),
    );
  }
}
