import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/favorites.dart';
import 'favorites.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List<ItemTile>.generate(
      100,
      (i) => ItemTile(i),
    );
    debugInvertOversizedImages = true;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, FavoritesPage.routeName);
            },
            icon: Icon(Icons.favorite_border),
            label: Text('Favorilerim'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        cacheExtent: 20.0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) => ItemTile(
          index,
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final int itemNo;

  const ItemTile(this.itemNo, {super.key});

  @override
  Widget build(BuildContext context) {
    var favoritesList = Provider.of<Favorites>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[itemNo % Colors.primaries.length],
        ),
        title: Text(
          'Sayı $itemNo',
          key: Key('text_$itemNo'),
        ),
        trailing: IconButton(
          key: Key('icon_$itemNo'),
          icon: favoritesList.items.contains(itemNo)
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          onPressed: () {
            !favoritesList.items.contains(itemNo)
                ? favoritesList.add(itemNo)
                : favoritesList.remove(itemNo);

            SnackBar(
              content: Text(favoritesList.items.contains(itemNo)
                  ? 'Favorilere Eklendi'
                  : 'Favorilerden Kaldırıldı'),
              duration: Duration(seconds: 1),
            );
          },
        ),
      ),
    );
  }
}
