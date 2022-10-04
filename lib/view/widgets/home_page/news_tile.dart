import 'package:flutter/material.dart';

import '../../../data/models/article.dart';

class NewsTile extends StatelessWidget {
  const NewsTile({
    Key? key,
    required this.article,
  }) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title),
      subtitle: Text(
        '${article.author} - ${article.publishedAt.day}/${article.publishedAt.month}/${article.publishedAt.year}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
