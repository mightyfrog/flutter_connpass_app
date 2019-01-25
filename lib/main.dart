import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'model/ConnpassResponse.dart';
import 'model/Event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Connpass API Demo'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ConnpassResponse _connpassResponse = ConnpassResponse.empty();
  bool _isComposing = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MainBody());
}

class MainBody extends StatefulWidget {
  @override
  State createState() => MainBodyState();
}

class MainBodyState extends State<MainBody> {
  final TextEditingController _textController = TextEditingController();
  ConnpassResponse _connpassResponse = ConnpassResponse.empty();
  bool _isComposing = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
      child: _buildBody());

  Widget _buildBody() {
    if (_isSearching) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  itemCount: _connpassResponse.resultsReturned,
                  itemBuilder: (context, i) {
                    return _ListItem((_connpassResponse).events[i]);
                  })),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildSearchField(),
          ),
        ],
      );
    }
  }

  Widget _buildSearchField() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _search,
                decoration: InputDecoration.collapsed(hintText: "Search"),
              ),
            ),
            IconTheme(
              data: IconThemeData(color: Theme.of(context).accentColor),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed:
                    _isComposing ? () => _search(_textController.text) : null,
              ),
            ),
          ],
        ),
      );

  void _search(String keyword) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final res = await http.get(
          "https://connpass.com/api/v1/event/?count=100&order=2&keyword=$keyword");
      setState(() {
        _connpassResponse = ConnpassResponse.fromJson(json.decode(res.body));
        _isSearching = false;
      });
    } catch (e) {
      _snackbar(e.toString());

      setState(() {
        _isSearching = false;
      });
    }
  }

  void _snackbar(String msg, [int length = 4]) =>
      Scaffold.of(context).showSnackBar(new SnackBar(
            duration: Duration(seconds: length),
            content: new Text(msg),
          ));
}

class _ListItem extends StatelessWidget {
  final primaryTextStyle = TextStyle(fontWeight: FontWeight.bold);
  final secondaryTextStyle = TextStyle(fontSize: 14.0);
  final Event event;

  _ListItem(this.event);

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.parse(event.startedAt);
    final month = dt.month;
    final day = dt.day;
    final hour = dt.hour + dt.timeZoneOffset.inHours;
    final minute = (dt.minute == 0) ? "00" : dt.minute.toString();
    final startedAt = "日時: $month/$day $hour:$minute";
    final address = "場所: ${event.place}";
    return Card(
      child: ListTile(
        onTap: () {
          _openEventUrl(event);
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: primaryTextStyle),
              Text(startedAt,
                  overflow: TextOverflow.ellipsis, style: secondaryTextStyle),
              Text(address,
                  overflow: TextOverflow.ellipsis, style: secondaryTextStyle),
            ],
          ),
        ),
      ),
    );
  }

  void _openEventUrl(Event event) async {
    if (await canLaunch(event.eventUrl)) {
      await launch(event.eventUrl);
    } else {
      throw "Could not launch ${event.eventUrl}";
    }
  }
}
