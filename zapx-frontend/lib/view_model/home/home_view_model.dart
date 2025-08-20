import 'package:flutter/foundation.dart';
import '../../data/response/api_response.dart';
import '../../model/movie_list/movie_list_model.dart';
import '../../repository/home_api/home_repository.dart';

class HomeViewViewModel with ChangeNotifier {
  HomeRepository homeRepository;
  HomeViewViewModel({required this.homeRepository});

  ApiResponse<MovieListModel> moviesList = ApiResponse.loading();

  setMoviesList(ApiResponse<MovieListModel> response) {
    moviesList = response;
    notifyListeners();
  }

  Future<void> fetchMoviesListApi() async {
    setMoviesList(ApiResponse.loading());
  }
}
