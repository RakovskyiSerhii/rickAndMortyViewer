import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_and_morty_viewer/core/ImagePathBuilder.dart';
import 'package:shimmer/shimmer.dart';

enum _SkeletonType { CHARACTER, EPISODE, LOCATION }

class SkeletonLoader extends StatelessWidget {
  final _SkeletonType _type;
  final _count;

  SkeletonLoader(this._type, this._count);

  factory SkeletonLoader.character({int count = 3}) =>
      SkeletonLoader(_SkeletonType.CHARACTER, count);

  factory SkeletonLoader.episode({int count = 3}) =>
      SkeletonLoader(_SkeletonType.EPISODE, count);

  factory SkeletonLoader.location({int count = 3}) =>
      SkeletonLoader(_SkeletonType.LOCATION, count);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Column(
        children: List.generate(_count, (_) => _getType()),
      ));

  Widget _getType() {
    var widget;
    switch (_type) {
      case _SkeletonType.LOCATION:
        {
          widget = _itemLocation();
          break;
        }

      case _SkeletonType.EPISODE:
        {
          widget = _itemEpisode();
          break;
        }
      default:
        {
          widget = _itemCharacter();
        }
    }
    return widget;
  }

  Widget _itemCharacter() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: Colors.white,
                ),
                width: double.infinity,
                height: 350.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                color: Colors.white,
                width: 200,
                height: 16.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 140.0,
                height: 12.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  Widget _itemEpisode() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2)))),
            ],
          ),
        ),
      );

  Widget _itemLocation() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ],
          ),
        ),
      );
}
