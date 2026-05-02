import 'package:flutter/material.dart';
import '../../data/models/news_model.dart';
import '../../data/services/api_service.dart';
import '../widgets/stock_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsArticle>>(
      future: ApiService.getMarketNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available at the moment.'));
        }

        List<NewsArticle> articles = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return StockCard(article: articles[index]);
          },
        );
      },
    );
  }
}