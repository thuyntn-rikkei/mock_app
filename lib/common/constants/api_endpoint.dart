class ApiEndpoint {
  static const getProducts = "/c/53f0-cfd4-4e00-8e1f";
  static const refreshToken = "/api/v1/refresh_token";
  static const loginApi = "";
  static const registerApi = "";

  static bool needAccessToken(String path) {
    List<String> excludeEndpoints = [
      ApiEndpoint.getProducts,
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
