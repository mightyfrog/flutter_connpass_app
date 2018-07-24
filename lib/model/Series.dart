import 'package:flutter/foundation.dart';

class Series {
  @required
  final int id;
  @required
  final String title;
  @required
  final String url;

  Series(this.id, this.title, this.url);

  factory Series.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return Series(json['id'], json['title'], json['url']);
  }
}
