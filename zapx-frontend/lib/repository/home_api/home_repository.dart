import 'package:zapxx/model/services_model.dart';
import 'package:zapxx/model/offer_model.dart';

abstract class HomeRepository {
  Future<ServicesModel> fetchPhotographyList();
  Future<ServicesModel> fetchVideographyList();

  // Offer related methods
  Future<OfferModel> createOffer(
    Map<String, dynamic> data,
    Map<String, String>? headers,
  );
  Future<OfferModel> getOffers(Map<String, String>? headers);
  Future<void> acceptOffer(int bookingId, Map<String, String>? headers);
  Future<void> declineOffer(int bookingId, Map<String, String>? headers);
}
