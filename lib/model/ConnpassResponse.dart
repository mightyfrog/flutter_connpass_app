import 'Event.dart';

class ConnpassResponse {
  int resultsReturned;
  int resultsAvailable;
  int resultsStart;
  List<Event> events;

  ConnpassResponse(this.resultsReturned, this.resultsAvailable,
      this.resultsStart, this.events);

  ConnpassResponse.empty() {
    resultsReturned = 0;
    resultsAvailable = 0;
    resultsStart = 0;
    events = null;
  }

  factory ConnpassResponse.fromJson(Map<String, dynamic> json) {
    final List<Event> events = List<Event>();
    for (var e in json['events']) {
      events.add(Event.fromJson(e));
    }
    return ConnpassResponse(json['results_returned'], json['results_available'],
        json['results_start'], events);
  }
}
