import 'package:logging/logging.dart';

import '../../../config/api_config.dart';
import '../../api/api.dart';
import '../../api/endpoint.dart';
import '../../models/article.dart';

final _log = Logger('news_repository');

class NewsRepository {
  static Future<List<Article>?> getEverything(
    String token, {
    required String q,
    required DateTime from,
    required DateTime to,
    required String sortBy,
    Function(String errorMessage)? onError,
  }) async {
    _log.info('NEWS Get everything');

    List<Article>? result;

    //* https://newsapi.org/v2/everything
    //?
    //* q=tesla
    //* & from=2022-08-30
    //* & to=2022-08-30
    //* & sortBy=publishedAt
    //* & apiKey=API_KEY
    final Map<String, dynamic> queryParameters = {
      'q': q,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
      'sortBy': sortBy,
      'apiKey': API_KEY,
    };

    final Endpoint endpoint = NewsApi.newsEndpoints.getEverything;
    result = await endpoint.hit<List<Article>>(
      token,
      queryParameters: queryParameters,
      map: (responseBody) => List<dynamic>.from(responseBody['articles'])
          .map((e) => Article.fromMap(e))
          .toList(),
      onError: onError,
    );

    return result;
  }
}
