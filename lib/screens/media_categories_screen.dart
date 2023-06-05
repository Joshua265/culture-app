import 'package:culture_app/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MediaCategoriesScreen extends StatelessWidget {
  const MediaCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.categories,
        ),
      ),
      body: ListView(
        children: [
          _buildCategoryItem(context, 'theater', Icons.theaters),
          _buildCategoryItem(context, 'movie', Icons.movie),
          _buildCategoryItem(context, 'concert', Icons.music_note),
          _buildCategoryItem(context, 'festival', Icons.festival),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData iconData,
  ) {
    var titleLabel = '';
    switch (title) {
      case 'theater':
        titleLabel = AppLocalizations.of(context)!.theater;
        break;
      case 'movie':
        titleLabel = AppLocalizations.of(context)!.movie;
        break;
      case 'concert':
        titleLabel = AppLocalizations.of(context)!.concert;
        break;
      case 'festival':
        titleLabel = AppLocalizations.of(context)!.festival;
        break;
    }
    return ListTile(
      title: Text(titleLabel),
      leading: Icon(iconData),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(category: title),
          ),
        );
      },
    );
  }
}
