import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';

class StockCard extends StatelessWidget {
  final NewsArticle article;

  const StockCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.article, color: Theme.of(context).colorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                article.source.toUpperCase(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                article.publishedAt,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}