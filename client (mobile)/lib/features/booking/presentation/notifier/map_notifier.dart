import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ump_student_grab_mobile/features/booking/domain/entity/place.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/providers.dart';

class MapState {
  final LatLng? currentPosition;
  final List<PlaceSuggestion> suggestions;
  final List<Place> searchResults;
  final List<LatLng> polylinePoints;
  final bool isSearching;

  const MapState({
    this.currentPosition,
    this.suggestions = const [],
    this.searchResults = const [],
    this.polylinePoints = const [],
    this.isSearching = false,
  });

  MapState copyWith({
    LatLng? currentPosition,
    List<PlaceSuggestion>? suggestions,
    List<Place>? searchResults,
    List<LatLng>? polylinePoints,
    bool? isSearching,
  }) {
    return MapState(
      currentPosition: currentPosition ?? this.currentPosition,
      suggestions: suggestions ?? this.suggestions,
      searchResults: searchResults ?? this.searchResults,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class MapNotifier extends Notifier<MapState> {
  @override
  MapState build() => const MapState();

  void setCurrentPosition(LatLng position) {
    state = state.copyWith(currentPosition: position);
  }

  Future<void> autocomplete(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }
    final result =
        await ref.read(bookingRepositoryProvider).autocomplete(query);
    result.fold(
      (_) => state = state.copyWith(suggestions: []),
      (suggestions) => state = state.copyWith(suggestions: suggestions),
    );
  }

  Future<void> searchByText(String query) async {
    state = state.copyWith(isSearching: true, suggestions: []);
    final result =
        await ref.read(bookingRepositoryProvider).searchByText(query);
    result.fold(
      (_) => state = state.copyWith(isSearching: false, searchResults: []),
      (places) =>
          state = state.copyWith(isSearching: false, searchResults: places),
    );
  }

  Future<void> getDirections(String origin, String destination) async {
    final result = await ref
        .read(bookingRepositoryProvider)
        .getDirections(origin, destination);
    result.fold(
      (_) => state = state.copyWith(polylinePoints: []),
      (encodedPolyline) {
        if (encodedPolyline == null || encodedPolyline.isEmpty) return;
        final decoded = PolylinePoints()
            .decodePolyline(encodedPolyline)
            .map((p) => LatLng(p.latitude, p.longitude))
            .toList();
        state = state.copyWith(polylinePoints: decoded);
      },
    );
  }

  void clearSuggestions() {
    state = state.copyWith(suggestions: []);
  }
}
