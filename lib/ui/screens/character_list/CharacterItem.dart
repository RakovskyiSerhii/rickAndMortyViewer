import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_viewer/models/Character.dart';
import 'package:rick_and_morty_viewer/ui/screens/character/CharacterPage.dart';

class CharacterItem extends StatelessWidget {
  final Character character;

  const CharacterItem({Key key, @required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: InkWell(
            onTap: () => {Navigator.pushNamed(context, CharacterPage.route, arguments: character)},
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    character.image,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                ListTile(
                  title: Text(character.name, style: Theme.of(context).textTheme.bodyText1,),
                  subtitle: Text("${character.gender}, ${character.status}", style: Theme.of(context).textTheme.bodyText2),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
