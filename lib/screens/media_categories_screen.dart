import 'package:culture_app/screens/category_screen.dart';
import 'package:flutter/material.dart';

class MediaCategoriesScreen extends StatelessWidget {
  const MediaCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView(
        children: [
          _buildCategoryItem(context, 'Theaters', Icons.theaters),
          _buildCategoryItem(context, 'Cinemas', Icons.movie),
          _buildCategoryItem(context, 'Concerts', Icons.music_note),
          _buildCategoryItem(context, 'Festivals', Icons.festival),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String title,
    IconData iconData,
  ) {
    return ListTile(
      title: Text(title),
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
