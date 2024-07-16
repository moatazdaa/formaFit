import 'package:flutter/material.dart';
import 'package:formafit/provider/articleProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مقالات التغذية وكمال الأجسام'),
      ),
      body: Consumer<ArticleProvider>(
        builder: (context, articleProvider, child) {
          return FutureBuilder(
            future: articleProvider.fetchArticles(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return Center(child: Text('حدث خطأ ما!'));
              } else {
                return ListView.builder(
                  itemCount: articleProvider.articles.length,
                  itemBuilder: (ctx, index) {
                    final article = articleProvider.articles[index];
                    return Card(
                      margin: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: [
                          if (article.urlToImage.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                              child: Image.network(article.urlToImage, fit: BoxFit.cover),
                            ),
                          ListTile(
                            title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(article.description),
                            onTap: () async {
                              // ignore: deprecated_member_use
                              if (await canLaunch(article.url)) {
                                await launch(article.url);
                              } else {
                                throw 'Could not launch ${article.url}';
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
