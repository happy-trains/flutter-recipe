import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFirst;
  final bool isLast;

  const RecipeCard(
    this.recipe, {
    Key? key,
    this.isFirst = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 5,
        top: isFirst ? 5 : 0,
        right: 5,
        bottom: isLast ? 5 : 0,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.title,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              TextButton(
                onPressed: () => _launchURL(context, recipe.link),
                child: Text(
                  'from ${recipe.authority}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                recipe.ingredientNames.join(', '),
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      if (!await launch(url)) {
        _showUnableToLaunchSnackBar(context, url);
      }
    } catch (e) {
      _showUnableToLaunchSnackBar(context, url);
    }
  }

  void _showUnableToLaunchSnackBar(BuildContext context, String url) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch \n$url')));
}
