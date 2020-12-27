import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rick_and_morty_viewer/util/localization/app_translator.dart';

class Strings {
  static const CHARACTER_LIVES_ON = "character_lives_on";
  static const CHARACTER_DEAD_ON = "character_dead_on";
  static const CHARACTER_LIVED_ON = "character_lived_on";
  static const CHARACTER_ALIVE_ORIGIN_EQUAL_LOCATION = "character_alive_origin_equal_location";
  static const CHARACTER_DEAD_ORIGIN_EQUAL_LOCATION = "character_dead_origin_equal_location";
  static const CHARACTER_ALIVE_ORIGIN_NOT_EQUAL_LOCATION = "character_alive_origin_not_equal_location";
  static const CHARACTER_DEAD_ORIGIN_NOT_EQUAL_LOCATION = "character_dead_origin_not_equal_location";
  static const CHARACTER_ORIGIN_UNKNOWN = "character_origin_unknown";
  static const CHARACTER_ALIVE_ORIGIN_UNKNOWN = "character_alive_origin_unknown";
  static const CHARACTER_DEAD_ORIGIN_UNKNOWN = "character_dead_origin_unknown";
  static const CHARACTER_ALIVE_LOCATION_UNKNOWN = "character_alive_location_unknown";
  static const CHARACTER_DEAD_LOCATION_UNKNOWN = "character_dead_location_unknown";
  static const CHARACTER_ORIGIN_LOCATION_UNKNOWN = "character_origin_location_unknown";
  static const HE_STRING = "he_string";
  static const SHE_STRING = "she_string";
  static const IT_STRING = "it_string";
  static const TRIPLE_DOT_SOMETHING_STRING = "triple_dot_something_string";
  static const GUY_STRING = "guy_string";
  static const WOMAN_STRING = "woman_string";
  static const MALE_STRING = "male_string";
  static const FEMALE_STRING = "female_string";
  static const UNKNOWN_STRING = "unknown_string";
  static const ALIEN_STRING = "alien_string";
  static const HUMAN_STRING = "human_string";
  static const ALIVE_STRING = "alive_string";
  static const DEAD_STRING = "dead_string";
  static const EPISODES_STRING = "episodes_string";
  static const TOOLBAR_LOCATION = "tool_bar_location";
  static const TOOLBAR_EPISODE = "tool_bar_episodes";
  static const CHARACTER_FOR = "character_for";
  static const CHARACTER_FROM = "character_from";
  static const HOME_STRING = "home_string";
  static const TYPE_LOADING_STRING = "type_loading_string";
  static const TYPE_STRING = "type_string";
  static const DIMENSION_UNKNOWN = "dimension_unknown";
  static const APP_TITLE = "app_title";
  static const BY_EPISODE = "by_episode_string";
  static const BY_LOCATION = "by_location_string";
  static const CONNECTION_LOST = "connection_lost";
  static const UPDATE_STRING = "update_string";

  static const FEMALE_KEY = "female";
  static const MALE_KEY = "male";

  static String get(BuildContext context, String key) {
    if (context != null) {
      return AppTranslations.of(context).text(key);
    } else {
      return "";
    }
  }

  static List<String> getArray(BuildContext context, String key) {
    if (context != null) {
      return AppTranslations.of(context).array(key);
    } else {
      return [];
    }
  }

  static String plural(BuildContext context, String key, {int amount = 1}) {
    final translator = AppTranslations.of(context);
    final map = translator.map(key);
    return Intl.plural(amount,
        zero: map['zero'].replaceAll("%s", amount.toString()),
        one: map['one'].replaceAll("%s", amount.toString()),
        two: map['two'].replaceAll("%s", amount.toString()),
        few: map['few'].replaceAll("%s", amount.toString()),
        other: map['other'].replaceAll("%s", amount.toString()),
        locale: translator.currentLanguage);
  }
}