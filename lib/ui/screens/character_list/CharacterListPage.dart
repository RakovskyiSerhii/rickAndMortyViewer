import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_viewer/bloc/CharacterBlock.dart';
import 'package:rick_and_morty_viewer/core/Failure.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/resources/strings.dart';
import 'package:rick_and_morty_viewer/ui/widgets/NetworkError.dart';
import 'package:rick_and_morty_viewer/ui/widgets/ServerError.dart';
import 'package:rick_and_morty_viewer/util/progress_skeleton.dart';

import 'CharacterItem.dart';

class CharacterListPage extends StatefulWidget {
  static const route = "/character_list";

  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  CharacterBlock _block;
  bool _isDisplayedData = false;
  bool _isModalSheetShowing = false;
  final _scrollController = ScrollController();

  void _getOtherPage() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      _block.getNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    _block = Provider.of<CharacterBlock>(context);
    _block.getNextPage();

    _block.errorStream.listen((failure) {
      if (failure == null) return;
      if (failure is Failure) {
        if (!_isModalSheetShowing) {
          _isModalSheetShowing = true;
          if (failure.isNetworkError()) {
            if (_isDisplayedData) {
              showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.0),
                            topLeft: Radius.circular(16.0)),
                      ),
                      builder: (event) {
                        return ErrorStub.modalSheet(() {
                          _block.getNextPage();
                          Navigator.pop(context);
                        });
                      },
                      isDismissible: false)
                  .then((value) => _isModalSheetShowing = false);
            }
          } else {
            showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0)),
                    ),
                    builder: (event) {
                      String message = "";
                      if (failure.isServerErrorWithDescription())
                        message = failure.message;
                      return ServerError(message);
                    },
                    isDismissible: false)
                .then((value) => _isModalSheetShowing = false);
          }
        }
      }
    });
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _contentPage(),
            navigationBar: CupertinoNavigationBar(
                middle: Text(Strings.APP_TITLE,
                    style: Theme.of(context).appBarTheme.textTheme.headline1),
                backgroundColor: Theme.of(context).appBarTheme.color),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(Strings.APP_TITLE,
                  style: Theme.of(context).appBarTheme.textTheme.bodyText1),
            ),
            body: _contentPage());
  }

  Widget _contentPage() {
    return StreamBuilder(
        stream: _block.characterListStream,
        builder: (ctx, characterListSnapshot) {
          if (characterListSnapshot.data != null) {
            return _characterList(characterListSnapshot.data);
          } else
            return StreamBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.data == null && !_isDisplayedData)
                  return SingleChildScrollView(
                      child: SkeletonLoader.character());
                else
                  return ErrorStub.fullScreen(() {
                    _block.getNextPage();
                  });
              },
              stream: _block.errorStream,
            );
        });
  }

  Widget _characterList(List<Character> list) {
    _isDisplayedData = true;
    _scrollController.addListener(_getOtherPage);
    return ListView(
      controller: _scrollController,
      children: list
          .map(
            (character) => CharacterItem(
              character: character,
              key: ValueKey(character.id),
            ),
          )
          .toList(),
    );
  }
}
