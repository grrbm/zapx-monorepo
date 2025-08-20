abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url);

  Future<dynamic> getPostApiResponse(String url, dynamic data);
  Future<dynamic> getUpdateApiResponse(
    String url,
    dynamic data, {
    Map<String, String>? headers,
  });
  Future<dynamic> getPostApiResponseHeader(
    String url,
    dynamic data, {
    Map<String, String>? headers,
  });
  Future<dynamic> getGetApiResponseWithHeader(
    String url, {
    Map<String, String>? headers,
  });
  Future<dynamic> getDeleteApiResponse(
    String url, {
    Map<String, String>? headers,
  });
}
