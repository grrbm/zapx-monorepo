import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zapxx/configs/utils.dart';
import 'package:zapxx/model/location_type_model.dart';
import 'package:zapxx/model/venue_type_model.dart';
import '../configs/app_url.dart';
import '../model/post_list_model.dart';
import '../model/selected_location_model.dart';
import '../model/selected_venue_model.dart';
import 'api_services.dart';

class PostController extends GetxController {
  TextEditingController venueTypeCtrl = TextEditingController();
  TextEditingController locationTypeCtrl = TextEditingController();
  VenueTypeModel? venueTypeModel;
  Set<SelectedVenueModel> selectedVenues = {};
  Set<SelectedLocationModel> selectedLocations = {}; // Store selected IDs

  Future fetchVenueType() async {
    await ApiServices.getMethod(feedUrl: AppUrl.getVenue)
        .then((res) {
          if (res?.success == true) {
            venueTypeModel = venueTypeModelFromJson(res?.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }

  LocationTypeModel? locationTypeModel;
  Future fetchLocationType() async {
    await ApiServices.getMethod(feedUrl: AppUrl.getLocation)
        .then((res) {
          if (res?.success == true) {
            locationTypeModel = locationTypeModelFromJson(res?.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }

  String getSelectedNames() {
    List<String> venueNames =
        selectedVenues.map((venue) => venue.name).toList();
    List<String> locationNames =
        selectedLocations.map((location) => location.name).toList();

    List<String> allNames = [
      ...venueNames,
      ...locationNames,
    ]; // Merge both lists

    return allNames.isNotEmpty
        ? allNames.join(", ")
        : "Select Venue"; // Handle empty state
  }

  PostListModel? postListModel;
  Future fetchPostList() async {
    await ApiServices.getMethod(feedUrl: AppUrl.sellerPost)
        .then((res) {
          if (res == null || res.response == null) {
            return null;
          }
          if (res.success == true) {
            postListModel = postListModelFromJson(res.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }

  // In PostController
  void removePost(int postId) {
    if (postListModel != null && postListModel!.posts != null) {
      postListModel!.posts.removeWhere((post) => post.id == postId);
      update(); // Triggers UI update
    }
  }

  Future fetchSellerPosts(int sellerId) async {
    await ApiServices.getMethod(
          feedUrl: AppUrl.sellerPost.replaceAll('{id}', sellerId.toString()),
        )
        .then((res) {
          if (res == null || res.response == null) {
            return null;
          }
          if (res.success == true) {
            postListModel = postListModelFromJson(res.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }

  Future fetchPeopleWhoBookedYou() async {
    await ApiServices.getMethod(feedUrl: AppUrl.peopleBookedYou)
        .then((res) {
          if (res == null || res.response == null) {
            return null;
          }
          if (res.success == true) {
            postListModel = postListModelFromJson(res.response);
            // profileModel = profileModelFromJson(res.response);
          }
          update();
        })
        .onError((error, stackTrace) async {
          logger.e('StackTrace => $stackTrace');
          throw '$error';
        });
  }
}
