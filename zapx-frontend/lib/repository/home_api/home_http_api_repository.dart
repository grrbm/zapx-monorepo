import 'dart:convert';

import 'package:zapxx/configs/app_url.dart';
import 'package:zapxx/data/network/network_api_services.dart';
import 'package:zapxx/model/services_model.dart';
import 'package:zapxx/model/user/consumer_model.dart';
import 'package:zapxx/model/user/seller_model.dart';
import 'package:zapxx/model/user/seller_review_model.dart';
import 'package:zapxx/view/home/model_insight.dart';
import 'package:zapxx/view/nav_bar/user/booking/booking_model.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/location_model.dart';
import 'package:zapxx/view/nav_bar/user/home/filter/venue_model.dart';
import 'package:zapxx/model/post_list_model.dart' as post_list;
import 'package:zapxx/view/nav_bar/user/home/home_screen/post_model.dart';
import 'package:zapxx/view/nav_bar/user/home/services/services_scheduler.dart';
import 'package:zapxx/view/nav_bar/user/home/services/widgets/scheduler_type_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat/messages_model.dart';
import 'package:zapxx/view/nav_bar/user/message/chat_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer/gigs/portfolio_subtab/portfolio_model.dart';
import 'package:zapxx/view/nav_bar/user/profile/current_user/saved_photographer_model.dart';
import 'package:zapxx/model/offer_model.dart';
import 'home_repository.dart';
import 'package:intl/intl.dart';

class HomeHttpApiRepository implements HomeRepository {
  final _apiServices = NetworkApiService();

  @override
  Future<ServicesModel> fetchPhotographyList() async {
    dynamic response = await _apiServices.getGetApiResponse(
      AppUrl.phtographyListEndPoint,
    );
    return response = ServicesModel.fromJson(response);
  }

  @override
  Future<ServicesModel> fetchVideographyList() async {
    dynamic response = await _apiServices.getGetApiResponse(
      AppUrl.videographyListEndPoint,
    );
    return response = ServicesModel.fromJson(response);
  }

  Future<VenueResponse> fetchVenueList(Map<String, String>? headers) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.venue,
      headers: headers,
    );
    return response = VenueResponse.fromJson(response);
  }

  Future<LocationModel> fetchLocationList(Map<String, String>? headers) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.location,
      headers: headers,
    );
    return response = LocationModel.fromJson(response);
  }

  Future<UserConsumer> fetchConsumerData(Map<String, String>? headers) async {
    try {
      print('🔍 Fetching consumer data from: ${AppUrl.consumerProfileEndPoint}');
      print('🔍 Headers: $headers');
      
      dynamic response = await _apiServices.getGetApiResponseWithHeader(
        AppUrl.consumerProfileEndPoint,
        headers: headers,
      );
      
      print('📄 Raw consumer response: $response');
      
      if (response == null) {
        print('⚠️ Warning: API returned null response for consumer data');
        throw Exception('No response from server');
      }
      
      if (!response.containsKey('User')) {
        print('⚠️ Warning: API response missing "User" field');
        print('⚠️ Available fields: ${response.keys.toList()}');
        throw Exception('Invalid response structure - missing User field');
      }
      
      print('✅ Successfully parsed consumer response');
      return UserConsumer.fromJson(response['User']);
    } catch (e) {
      print('❌ Error in fetchConsumerData: $e');
      rethrow;
    }
  }

  Future<ChatModel> fetchChatList(Map<String, String>? headers) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.chatList,
      headers: headers,
    );
    return response = ChatModel.fromJson(response);
  }

  Future<SavedPhotographerModel> fetchSavedSeller(
    Map<String, String>? headers,
  ) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.savedSellerEndpoint,
      headers: headers,
    );
    return response = SavedPhotographerModel.fromJson(response);
  }

  Future<ChatMessages> fetchChatMessages(
    Map<String, String>? headers,
    String id,
  ) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseWithHeader(
        '${AppUrl.chatList}/$id',
        headers: headers,
      );

      // Handle null or empty response
      if (response == null) {
        throw Exception('No response from server');
      }

      // Check if the response has the expected structure
      if (response['chat'] == null) {
        throw Exception('Invalid chat data structure');
      }

      return ChatMessages.fromJson(response);
    } catch (e) {
      print('Error fetching chat messages: $e');
      rethrow;
    }
  }

  Future<ApiResponseScheduler> fetchServiceScheduler({
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      print('🔍 Fetching service scheduler from: ${AppUrl.serviceScheduler}');
      print('🔍 Headers: $headers');
      print('🔍 Query params: $queryParams');

      dynamic response = await _apiServices.getGetApiResponseWithHeaderDio(
        AppUrl.serviceScheduler,
        headers: headers,
        queryParameters: queryParams,
      );

      print('📄 Raw service scheduler response: $response');
      print('📄 Response type: ${response.runtimeType}');

      // Check if response is null
      if (response == null) {
        print('⚠️ Warning: API returned null response for service scheduler');
        throw Exception('No response from server');
      }

      // Check if response is a Map
      if (response is! Map<String, dynamic>) {
        print(
          '⚠️ Warning: API returned unexpected response type: ${response.runtimeType}',
        );
        print('⚠️ Response value: $response');
        throw Exception('Invalid response format');
      }

      // Check if response has the expected structure
      if (!response.containsKey('serviceScheduler')) {
        print('⚠️ Warning: API response missing "serviceScheduler" field');
        print('⚠️ Available fields: ${response.keys.toList()}');
        print('⚠️ Full response: $response');
        throw Exception(
          'Invalid response structure - missing serviceScheduler field',
        );
      }

      print('✅ Successfully parsed service scheduler response');
      return ApiResponseScheduler.fromJson(response);
    } catch (e) {
      print('❌ Error in fetchServiceScheduler: $e');
      print('❌ Error stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<PostModel> fetchPosts({
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      print('🔍 Fetching posts from: ${AppUrl.postOnMap}');
      print('🔍 Headers: $headers');
      print('🔍 Query params: $queryParams');

      dynamic response = await _apiServices.getGetApiResponseWithHeaderDio(
        AppUrl.postOnMap,
        headers: headers,
        queryParameters: queryParams,
      );

      print('📄 Raw API response: $response');
      print('📄 Response type: ${response.runtimeType}');

      // Check if response is null
      if (response == null) {
        print('⚠️ Warning: API returned null response for posts');
        return PostModel(posts: [], count: 0, nextFrom: null);
      }

      // Check if response is a Map
      if (response is! Map<String, dynamic>) {
        print(
          '⚠️ Warning: API returned unexpected response type: ${response.runtimeType}',
        );
        print('⚠️ Response value: $response');
        return PostModel(posts: [], count: 0, nextFrom: null);
      }

      // Check if response has required fields
      if (!response.containsKey('posts')) {
        print('⚠️ Warning: API response missing "posts" field');
        print('⚠️ Available fields: ${response.keys.toList()}');
        print('⚠️ Full response: $response');
        return PostModel(posts: [], count: 0, nextFrom: null);
      }

      print(
        '✅ Successfully parsed response with ${response['posts']?.length ?? 0} posts',
      );

      // Try to parse each post individually to identify which one is causing issues
      try {
        return PostModel.fromJson(response);
      } catch (e) {
        print('❌ Error parsing PostModel: $e');

        // Try to parse posts individually to find the problematic one
        if (response['posts'] != null && response['posts'] is List) {
          List posts = response['posts'];
          for (int i = 0; i < posts.length; i++) {
            try {
              print('🔍 Testing post $i: ${posts[i]}');
              // This will help identify which post is causing the issue
              Post.fromJson(posts[i]);
              print('✅ Post $i parsed successfully');
            } catch (postError) {
              print('❌ Error parsing post $i: $postError');
              print('❌ Post $i data: ${posts[i]}');
            }
          }
        }

        // Return empty model on error
        return PostModel(posts: [], count: 0, nextFrom: null);
      }
    } catch (e) {
      print('❌ Error in fetchPosts: $e');
      print('❌ Error stack trace: ${StackTrace.current}');
      return PostModel(posts: [], count: 0, nextFrom: null);
    }
  }

  Future<post_list.PostListModel> fetchSellerPosts({
    required int sellerId,
    Map<String, String>? headers,
  }) async {
    try {
      print(
        '🔍 Fetching seller posts from: ${AppUrl.sellerPost.replaceAll('{id}', sellerId.toString())}',
      );
      print('🔍 Headers: $headers');

      dynamic response = await _apiServices.getGetApiResponseWithHeaderDio(
        AppUrl.sellerPost.replaceAll('{id}', sellerId.toString()),
        headers: headers,
      );

      print('📄 Raw seller posts response: $response');
      print('📄 Response type: ${response.runtimeType}');

      // Check if response is null
      if (response == null) {
        print('⚠️ Warning: API returned null response for seller posts');
        return post_list.PostListModel(posts: [], count: 0, nextFrom: null);
      }

      // Check if response is a Map
      if (response is! Map<String, dynamic>) {
        print(
          '⚠️ Warning: API returned unexpected response type: ${response.runtimeType}',
        );
        print('⚠️ Response value: $response');
        return post_list.PostListModel(posts: [], count: 0, nextFrom: null);
      }

      // Check if response has required fields
      if (!response.containsKey('posts')) {
        print('⚠️ Warning: API response missing "posts" field');
        print('⚠️ Available fields: ${response.keys.toList()}');
        print('⚠️ Full response: $response');
        return post_list.PostListModel(posts: [], count: 0, nextFrom: null);
      }

      print(
        '✅ Successfully parsed seller posts response with ${response['posts']?.length ?? 0} posts',
      );

      try {
        return post_list.PostListModel.fromJson(response);
      } catch (e) {
        print('❌ Error parsing PostListModel for seller posts: $e');
        return post_list.PostListModel(posts: [], count: 0, nextFrom: null);
      }
    } catch (e) {
      print('❌ Error in fetchSellerPosts: $e');
      print('❌ Error stack trace: ${StackTrace.current}');
      return post_list.PostListModel(posts: [], count: 0, nextFrom: null);
    }
  }

  Future<ServiceSchedulerType> getSchedulerDetails({
    required int schedulerId,
    required String viewType,
    Map<String, String>? headers,
  }) async {
    final response = await _apiServices.getGetApiResponseWithHeaderDio(
      '${AppUrl.serviceScheduler}/consumer/$schedulerId',
      headers: headers,
      queryParameters: {'viewType': viewType},
    );
    return ServiceSchedulerType.fromJson(response['serviceScheduler']);
  }

  Future<void> toggleSellerLike({
    required int sellerId,
    required bool isSaved,
    Map<String, String>? headers,
  }) async {
    try {
      await _apiServices.getPostApiResponseHeader(
        '${AppUrl.baseUrl}/Like-unlike/seller/$sellerId',
        headers: headers,
        jsonEncode({'isSaved': isSaved}),
      );
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  Future<BookingResponse> getBookings({
    required DateTime startDate,
    required DateTime endDate,
    Map<String, String>? headers,
  }) async {
    final response = await _apiServices.getGetApiResponseWithHeaderDio(
      '${AppUrl.baseUrl}/booking',
      headers: headers,
      queryParameters: {
        'startDate': DateFormat('yyyy-MM-dd').format(startDate),
        'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      },
    );
    return BookingResponse.fromJson(response);
  }

  Future<PortfolioResponse> getPortfolio(Map<String, String>? headers) async {
    print("-----------------getPortfolio${AppUrl.portfolioEndpointSeller}");
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.portfolioEndpointSeller,
      headers: headers,
    );
    return response = PortfolioResponse.fromJson(response);
  }

  Future<UserResponse> fetchSeller(Map<String, String>? headers) async {
    try {
      print('🔍 Fetching seller from: ${AppUrl.sellerBio}');
      print('🔍 Headers: $headers');

      dynamic response = await _apiServices.getGetApiResponseWithHeader(
        AppUrl.sellerBio,
        headers: headers,
      );

      print('📄 Raw seller response: $response');
      print('📄 Response type: ${response.runtimeType}');

      // Check if response is null
      if (response == null) {
        print('⚠️ Warning: API returned null response for seller');
        throw Exception('No response from server');
      }

      // Check if response is a Map
      if (response is! Map<String, dynamic>) {
        print(
          '⚠️ Warning: API returned unexpected response type: ${response.runtimeType}',
        );
        print('⚠️ Response value: $response');
        throw Exception('Invalid response format');
      }

      // Check if response has the expected structure
      if (!response.containsKey('User')) {
        print('⚠️ Warning: API response missing "User" field');
        print('⚠️ Available fields: ${response.keys.toList()}');
        print('⚠️ Full response: $response');
        throw Exception('Invalid response structure - missing User field');
      }

      print('✅ Successfully parsed seller response');
      return UserResponse.fromJson(response);
    } catch (e) {
      print('❌ Error in fetchSeller: $e');
      print('❌ Error stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<SellerReviewModel> fetchSellerReview(
    Map<String, String>? headers,
    int id,
  ) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.reviewEndPoint + '/$id',
      headers: headers,
    );
    return response = SellerReviewModel.fromJson(response);
  }

  Future<Insight> fetchWeeklyInsights(Map<String, String>? headers) async {
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      AppUrl.weeklyInsight,
      headers: headers,
    );
    return response = Insight.fromJson(response);
  }

  Future<Map<String, dynamic>> createScheduler(
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    dynamic response = await _apiServices.getPostApiResponseHeader(
      AppUrl.createScheduler,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> getSchedulerBySellerId(
    int sellerId, {
    Map<String, String>? headers,
  }) async {
    final url = AppUrl.getSchedulerBySeller.replaceAll(
      '{sellerId}',
      sellerId.toString(),
    );
    dynamic response = await _apiServices.getGetApiResponseWithHeader(
      url,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> updateScheduler(
    int schedulerId,
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    final url = AppUrl.updateScheduler.replaceAll(
      '{schedulerId}',
      schedulerId.toString(),
    );
    dynamic response = await _apiServices.getUpdateApiResponse(
      url,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> deleteScheduler(
    int schedulerId, {
    Map<String, String>? headers,
  }) async {
    final url = AppUrl.deleteScheduler.replaceAll(
      '{schedulerId}',
      schedulerId.toString(),
    );
    dynamic response = await _apiServices.getDeleteApiResponse(
      url,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<Map<String, dynamic>> createexternalBooking(
    dynamic data, {
    Map<String, String>? headers,
  }) async {
    dynamic response = await _apiServices.getPostApiResponseHeader(
      AppUrl.createExternalBooking,
      data,
      headers: headers,
    );
    if (response is Map<String, dynamic>) {
      return response; // Return the parsed JSON response
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<void> updateServiceSchedulerRate({
    required int rate,
    Map<String, String>? headers,
  }) async {
    final url = '${AppUrl.serviceScheduler}';
    final body = jsonEncode({"rate": rate});
    await _apiServices.getUpdateApiResponse(url, body, headers: headers);
  }

  // Offer related methods
  @override
  Future<OfferModel> createOffer(
    Map<String, dynamic> data,
    Map<String, String>? headers,
  ) async {
    dynamic response = await _apiServices.getPostApiResponseHeader(
      AppUrl.createOffer,
      data,
      headers: headers,
    );
    return OfferModel.fromJson(response);
  }

  @override
  Future<OfferModel> getOffers(Map<String, String>? headers) async {
    print('🔍 Attempting to fetch offers...');
    print('🔍 Headers: $headers');
    print('🔍 Full URL: ${AppUrl.getOffers}');

    try {
      // Try with minimal parameters first

      // Build minimal query parameters

      dynamic response = await _apiServices.getGetApiResponseWithHeaderDio(
        AppUrl.getOffers,
        headers: headers,
      );

      print('📄 Raw API response (minimal params): $response');

      // Check if response has the expected structure
      if (response is Map<String, dynamic> && response.containsKey('offers')) {
        return OfferModel.fromJson(response);
      } else {
        print('⚠️ Unexpected response structure: $response');
        // Return empty offers if structure is unexpected
        return OfferModel(offers: []);
      }
    } catch (e) {
      print('❌ Error in getOffers: $e');

      // If that fails, try without any parameters
      try {
        print('🔍 Trying without any parameters...');
        dynamic response = await _apiServices.getGetApiResponseWithHeader(
          AppUrl.getOffers,
          headers: headers,
        );

        print('📄 Raw API response (no params): $response');

        if (response is Map<String, dynamic> &&
            response.containsKey('offers')) {
          return OfferModel.fromJson(response);
        } else {
          print('⚠️ Still unexpected response structure: $response');
          return OfferModel(offers: []);
        }
      } catch (e2) {
        print('❌ Error in getOffers (no params): $e2');
        rethrow;
      }
    }
  }

  @override
  Future<void> acceptOffer(int bookingId, Map<String, String>? headers) async {
    final url = AppUrl.acceptOffer.replaceAll(
      '{bookingId}',
      bookingId.toString(),
    );
    print('✅ Accepting offer with URL: $url');

    try {
      await _apiServices.getPostApiResponseHeader(url, {}, headers: headers);
      print('✅ Offer accepted successfully');
    } catch (e) {
      print('❌ Error accepting offer: $e');
      rethrow;
    }
  }

  @override
  Future<void> declineOffer(int bookingId, Map<String, String>? headers) async {
    final url = AppUrl.declineOffer.replaceAll(
      '{bookingId}',
      bookingId.toString(),
    );
    print('❌ Declining offer with URL: $url');

    try {
      await _apiServices.getPostApiResponseHeader(url, {}, headers: headers);
      print('✅ Offer declined successfully');
    } catch (e) {
      print('❌ Error declining offer: $e');
      rethrow;
    }
  }
}
