import '../endpoint.dart';
import 'news_endpoint.dart';

class NewsEndpoints {
  Endpoint get getEverything => NewsEndpoint('GET', '/everything');
}
