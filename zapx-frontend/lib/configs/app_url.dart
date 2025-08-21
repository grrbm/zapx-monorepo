import 'package:flutter/foundation.dart';

class AppUrl {
  static var baseUrl = 'http://192.168.0.140:5003'; // Local IP for simulator testing
  static var moviesBaseUrl =
      'https://dea91516-1da3-444b-ad94-c6d0c4dfab81.mock.pstmn.io/';

  static var loginEndPint = '$baseUrl/auth/login';
  static var registerApiEndPoint = '$baseUrl/auth/signup';
  static var chooseYourServise = '$baseUrl/services';

  static var phtographyListEndPoint = '$baseUrl/services?categoryId=1';
  static var videographyListEndPoint = '$baseUrl/services?categoryId=2';
  static var profileEndPoint = '/profile';
  static var portfolioEndPoint = '/portfolio';
  static var consumerProfileEndPoint = '$baseUrl/profile/';
  static var profileImage = '/profile/image';
  static var forgotPassword = '$baseUrl/auth/forgot-password';
  static var verifyOtp = '$baseUrl/auth/verify-otp';
  static var newPassword = '$baseUrl/auth/reset-password';
  static var chatList = '$baseUrl/chat';
  static var chatMessages = '$baseUrl/chat';
  static var sendMessages = '/chat/message';
  static var serviceScheduler = '$baseUrl/service-scheduler';
  static var sellerBio = '$baseUrl/profile/bio';
  static var weeklyInsight = '$baseUrl/dashboard/insignt';
  static var discountEndPoint = '$baseUrl/discount';
  static var likeOrUnlike = '$baseUrl/like-unlike/seller/';
  static var reviewEndPoint = '$baseUrl/reviews/user';
  static var portfolioEndpointSeller = '$baseUrl/portfolio/seller';
  static var postOnMap = '$baseUrl/post';
  static var getVenue = '$baseUrl/venue';
  static var getLocation = '$baseUrl/location';
  static var peopleBookedYou = '$baseUrl/booking/people-booked-you';
  static var bankDetail = '$baseUrl/bank-detail';
  static var cardDetail = '$baseUrl/card-detail';
  static var savedSellerEndpoint = '$baseUrl/like-unlike/seller';
  static var venue = '$baseUrl/venue';
  static var location = '$baseUrl/location';
  static var createScheduler = '$baseUrl/service-scheduler';
  static var updateScheduler = '$baseUrl/service-scheduler/{schedulerId}';
  static var deleteScheduler = '$baseUrl/service-scheduler/{schedulerId}';
  static var getSchedulerBySeller = '$baseUrl/service-scheduler/{sellerId}';
  static var sellerPost = '$baseUrl/post/seller/{id}';
  static var createExternalBooking = '$baseUrl/booking/external';
  static var booking = '$baseUrl/booking';

  // Offer related endpoints
  static var createOffer = '$baseUrl/booking/offer';
  static var getOffers = '$baseUrl/booking/offers';
  static var acceptOffer = '$baseUrl/booking/confirmed/{bookingId}';
  static var declineOffer = '$baseUrl/booking/offer/declined/{bookingId}';
}
