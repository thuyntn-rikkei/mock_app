class ApiEndpoint {
  static const getPlayer = "/api/v1/players";

  static bool needAccessToken(String path) {
    List<String> excludeEndpoints = [
      ApiEndpoint.getPlayer,
    ];
    for (String endpoint in excludeEndpoints) {
      if (checkPathMatch(pathPattern: endpoint, urlPath: path)) {
        return true;
      }
    }
    return false;
  }

  static bool checkPathMatch({
    required String pathPattern,
    required String urlPath,
  }) {
    final pathSplit = pathPattern.split('/');
    final urlPathSplit = urlPath.split('/');

    if (pathSplit.length != urlPathSplit.length) {
      return false;
    }

    for (int i = 0; i < pathSplit.length; i++) {
      final pathItem = pathSplit[i];
      final urlPathItem = urlPathSplit[i];

      if (pathItem != urlPathItem) {
        if (!pathItem.startsWith('{') || !pathItem.endsWith('}')) {
          return false;
        }
      }
    }
    return true;
  }
}
