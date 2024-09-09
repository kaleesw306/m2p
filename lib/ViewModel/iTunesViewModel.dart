import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../Model/iTunesMedia.dart';
import '../Utilities/DioPinning.dart';

enum iTunesState { loading, success, error }

final iTunesProvider = StateNotifierProvider<iTunesViewModel, iTunesViewModelState>((ref) {
  return iTunesViewModel();
});

class iTunesViewModelState {
  final iTunesState state;
  final List<iTunesMedia> mediaList;
  final String? errorMessage;

  iTunesViewModelState({
    required this.state,
    this.mediaList = const [],
    this.errorMessage,
  });
}

class iTunesViewModel extends StateNotifier<iTunesViewModelState> {
  late final Dio _dio;

  iTunesViewModel()
      : super(iTunesViewModelState(state: iTunesState.loading)) {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    //_dio = Dio();
    _dio = await createDioWithPinning();
  }

  Future<void> fetchMedia(String searchTerm, String entity) async {
    if (_dio == null) {
     _initializeDio();

    }

      state = iTunesViewModelState(state: iTunesState.loading);

      try {
        print(
            'Fetching: https://itunes.apple.com/search?term=$searchTerm&entity=$entity');


        final response = await _dio.get(
            'https://itunes.apple.com/search?term=$searchTerm&entity=$entity');

        developer.log('Response data: ${response.data}');

        if (response.data != null) {
          var data = jsonDecode(response.data);

          final results = (data['results'] as List)
              .map((e) => iTunesMedia.fromJson(e))
              .toList();


          state = iTunesViewModelState(
              state: iTunesState.success, mediaList: results);
        } else {

          state = iTunesViewModelState(
              state: iTunesState.error,
              errorMessage: 'Unexpected response format');
          print('Unexpected response format');
        }
      } on DioException catch (dioError) {

        String errorMessage;
        if (dioError.type == DioExceptionType.connectionTimeout ||
            dioError.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Connection timed out. Please try again.';
        } else if (dioError.type == DioExceptionType.unknown &&
            dioError.error is SocketException) {
          errorMessage = 'No internet connection. Please check your network.';
        } else if (dioError.response != null) {

          errorMessage =
          'Failed to load data: ${dioError.response?.statusCode} ${dioError
              .response?.statusMessage}';
        } else {

          errorMessage = 'Something went wrong. Please try again later.';
        }


        state = iTunesViewModelState(
            state: iTunesState.error, errorMessage: errorMessage);
        print('DioError: $errorMessage');
      } catch (e) {

        state = iTunesViewModelState(
            state: iTunesState.error, errorMessage: 'Error fetching media: $e');
        print('Error: $e');
      }

  }

}
