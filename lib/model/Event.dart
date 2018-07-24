import 'package:flutter/foundation.dart';

import 'Series.dart';

class Event {
  @required
  final int eventId;
  @required
  final String title;
  @required
  final String caaatch; // catch
  @required
  final String description;
  @required
  final String eventUrl;
  @required
  final String hashTag;
  @required
  final String startedAt;
  @required
  final String endedAt;
  @required
  final int limit;
  @required
  final String eventType;
  final Series series;
  @required
  final String address;
  @required
  final String place;
  @required
  final String lat;
  @required
  final String lon;
  @required
  final int ownerId;
  @required
  final String ownerNickname;
  @required
  final String ownerDisplayName;
  @required
  final int accepted;
  @required
  final int waiting;
  @required
  final String updatedAt;

  Event(
      this.eventId,
      this.title,
      this.caaatch,
      this.description,
      this.eventUrl,
      this.hashTag,
      this.startedAt,
      this.endedAt,
      this.limit,
      this.eventType,
      this.series,
      this.address,
      this.place,
      this.lat,
      this.lon,
      this.ownerId,
      this.ownerNickname,
      this.ownerDisplayName,
      this.accepted,
      this.waiting,
      this.updatedAt);

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        json['event_id'],
        json['title'],
        json['catch'],
        json['description'],
        json['event_url'],
        json['hash_tag'],
        json['started_at'],
        json['ended_at'],
        json['limit'],
        json['event_type'],
        Series.fromJson(json['series']),
        json['address'],
        json['place'],
        json['lat'],
        json['lon'],
        json['owner_id'],
        json['owner_nickname'],
        json['owner_display_name'],
        json['accepted'],
        json['waiting'],
        json['updated_at']);
  }
}
