import 'package:zebrra_challenge_two/data/api/endpoint.dart';

class NewsEndpoint extends Endpoint {
  NewsEndpoint(super.method, super.url, [super.validStatusCode]);

  @override
  String get domainUrl => 'https://newsapi.org/v2';
}
