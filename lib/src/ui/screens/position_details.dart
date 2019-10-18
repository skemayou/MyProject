import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import 'package:jobber/src/core/models/position.dart';
import 'package:jobber/src/core/models/saved.dart';
import 'package:jobber/src/ui/components/loading_transition.dart';

import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

/// A screen that displays a full overview of a [Position] based on a matching
/// [id].
///
/// If [showSavedToggle] is false, the action button will not be shown at the
/// bottom of the screen. This is useful if there is some other way of toggling
/// the saved state of the [Position] with the id of [id].
class PositionDetails extends StatelessWidget {
  const PositionDetails({
    Key key,
    this.title,
    @required this.id,
    this.showSavedToggle = true,
  }) : super(key: key);

  final String title;
  final String id;
  final bool showSavedToggle;

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<Position>(
      builder: (_) => Position.fromId(id),
      child: ChangeNotifierProvider<Saved>(
        builder: (_) => Saved(id),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Details de l''offre'),
          ),
          body: Consumer<Position>(
            builder: (context, model, child) => LoadingTransition(
              child: model.isLoading ? _loading() : _body(context, model),
            ),
          ),
          floatingActionButton: showSavedToggle
              ? Consumer<Saved>(
                  builder: (context, model, child) {
                    if (model.saved == null) {
                      return Container();
                    } else {
                      return FloatingActionButton(
                        child: LoadingTransition(
                          child: model.saved
                              ? Icon(Icons.bookmark, key: Key('Saved'))
                              : Icon(Icons.bookmark_border,
                                  key: Key('Not saved')),
                        ),
                        onPressed: () => model.toggleSaved(context),
                      );
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _body(BuildContext context, Position position) {
    return Center(
      key: Key('Content'),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              position.title,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            title: Text(position.company),
            subtitle: Text(position.location),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              position.type,
              style: Theme.of(context).textTheme.body2.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
            ),
          ),
          Divider(height: kToolbarHeight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Description',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 16.0,
                  ),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Html(
              data: position.description,
              onLinkTap: (url) => _launchUrl(url, context),
            ),
          ),
          Divider(height: kToolbarHeight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'How to apply',
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: 16.0,
                  ),
            ),
          ),
          SizedBox(height: 16.0),
          Card(
            elevation: 0.0,
            margin: const EdgeInsets.symmetric(horizontal: 12.0),
            color: Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: MarkdownBody(
                data: position.howToApply,
                onTapLink: (url) => _launchUrl(url, context),
              ),
            ),
          ),
          SizedBox(height: 80.0),
        ],
      ),
    );
  }

  Widget _loading() {
    return Center(
      key: Key('Loading'),
      child: CircularProgressIndicator(),
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Failed to launch url.'),
      ));
    }
  }
}
