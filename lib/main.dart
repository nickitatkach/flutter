import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Startup Name Generator',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        // ),
        home: RandowWords());
  }
}

class RandowWords extends StatefulWidget {
  const RandowWords({Key? key}) : super(key: key);

  @override
  State<RandowWords> createState() => _RandowWordsState();
}

class _RandowWordsState extends State<RandowWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _favourites = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FLAME'),
          actions: [
            IconButton(
                onPressed: _pushSaved,
                icon: const Icon(Icons.favorite, color: Colors.white),
                tooltip: 'Saved Suggestions')
          ],
        ),
        body: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return const Divider();

              final index = i ~/ 2;

              if (index >= _suggestions.length) {
                _suggestions.addAll(generateWordPairs().take(10));
              }

              final isFavourite = _favourites.contains(_suggestions[index]);

              return ListTile(
                title:
                    Text(_suggestions[index].asPascalCase, style: _biggerFont),
                trailing: Icon(
                    isFavourite ? Icons.favorite : Icons.favorite_border,
                    color: isFavourite ? Colors.red : null,
                    semanticLabel: isFavourite ? 'Remove from saved' : 'Save'),
                onTap: () {
                  setState(() {
                    if (isFavourite) {
                      _favourites.remove(_suggestions[index]);
                    } else {
                      _favourites.add(_suggestions[index]);
                    }
                  });
                },
              );
            }));
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        final tiles = _favourites.map(
          (pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
              trailing: const Icon(Icons.remove_circle, color: Colors.red),
              onTap: () {
                setState(() {
                  _favourites.remove(pair);
                });
              },
            );
          },
        );
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }
}

class RandomFavoriteWords extends StatefulWidget {
  const RandomFavoriteWords({Key? key}) : super(key: key);

  @override
  State<RandomFavoriteWords> createState() => _RandomFavoriteWordsState();
}

class _RandomFavoriteWordsState extends State<RandomFavoriteWords> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
