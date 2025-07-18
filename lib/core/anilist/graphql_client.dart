import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AnilistClient {
  static final String _baseUrl = 'https://graphql.anilist.co';

  static GraphQLClient getClient({String? accessToken}) {
    final HttpLink httpLink = HttpLink(
      _baseUrl,
      defaultHeaders: accessToken != null && accessToken.isNotEmpty
          ? {'Authorization': 'Bearer $accessToken'}
          : {},
    ); // ✅ Don't include Authorization if null
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
      queryRequestTimeout: Duration(seconds: 15),
    );
  }
}

// A provider that builds a GraphQLClient. It's a "family" provider,
// meaning it can take an argument—in this case, the access token.
// final anilistClientProvider = Provider.family<GraphQLClient, String?>((ref, accessToken) {
//   final httpLink = HttpLink('https://graphql.anilist.co');

//   final authLink = AuthLink(
//     // Use the provided accessToken to configure the client
//     getToken: () => accessToken != null ? 'Bearer $accessToken' : null,
//   );

//   final link = authLink.concat(httpLink);

//   return GraphQLClient(
//     link: link,
//     cache: GraphQLCache(store: HiveStore()),
//   );
// });
