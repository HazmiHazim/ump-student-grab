package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.response.DirectionsResponse;
import com.ump.studentgrab.application.dto.response.PlaceSearchResponse;
import com.ump.studentgrab.application.dto.response.PlaceSuggestionResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.List;
import java.util.Map;

@Service
public class PlacesService {

    private static final String PLACES_BASE_URL = "https://maps.googleapis.com/maps/api/place";
    private static final String DIRECTIONS_BASE_URL = "https://maps.googleapis.com/maps/api/directions";

    private final String apiKey;
    private final RestClient restClient;

    public PlacesService(@Value("${google.maps.api-key}") String apiKey) {
        this.apiKey = apiKey;
        this.restClient = RestClient.create();
    }

    public List<PlaceSuggestionResponse> autocomplete(String query, String region) {
        String url = UriComponentsBuilder.fromHttpUrl(PLACES_BASE_URL + "/autocomplete/json")
                .queryParam("input", query)
                .queryParam("region", region)
                .queryParam("key", apiKey)
                .toUriString();

        Map<?, ?> body = restClient.get().uri(url).retrieve().body(Map.class);
        List<?> predictions = (List<?>) body.get("predictions");

        if (predictions == null || predictions.isEmpty()) return List.of();

        return predictions.stream()
                .map(p -> (Map<?, ?>) p)
                .map(p -> new PlaceSuggestionResponse(
                        (String) p.get("description"),
                        (String) p.get("place_id")
                ))
                .toList();
    }

    public List<PlaceSearchResponse> searchByText(String query, String region) {
        String url = UriComponentsBuilder.fromHttpUrl(PLACES_BASE_URL + "/textsearch/json")
                .queryParam("query", query)
                .queryParam("region", region)
                .queryParam("key", apiKey)
                .toUriString();

        Map<?, ?> body = restClient.get().uri(url).retrieve().body(Map.class);
        List<?> results = (List<?>) body.get("results");

        if (results == null || results.isEmpty()) return List.of();

        return results.stream()
                .map(r -> (Map<?, ?>) r)
                .filter(r -> r.get("geometry") instanceof Map<?, ?> g
                        && g.get("location") instanceof Map<?, ?>)
                .map(r -> {
                    Map<?, ?> geometry = (Map<?, ?>) r.get("geometry");
                    Map<?, ?> location = (Map<?, ?>) geometry.get("location");
                    double lat = ((Number) location.get("lat")).doubleValue();
                    double lng = ((Number) location.get("lng")).doubleValue();
                    return new PlaceSearchResponse(
                            (String) r.get("name"),
                            (String) r.get("place_id"),
                            lat,
                            lng
                    );
                })
                .toList();
    }

    public DirectionsResponse getDirections(String origin, String destination) {
        String url = UriComponentsBuilder.fromHttpUrl(DIRECTIONS_BASE_URL + "/json")
                .queryParam("origin", origin)
                .queryParam("destination", destination)
                .queryParam("key", apiKey)
                .toUriString();

        Map<?, ?> body = restClient.get().uri(url).retrieve().body(Map.class);
        List<?> routes = (List<?>) body.get("routes");

        if (routes == null || routes.isEmpty()) {
            throw new ResourceNotFoundException("No route found between the given locations");
        }

        Map<?, ?> route = (Map<?, ?>) routes.get(0);
        Map<?, ?> overviewPolyline = route.get("overview_polyline") instanceof Map<?, ?> p ? p : null;

        if (overviewPolyline == null || overviewPolyline.get("points") == null) {
            throw new ResourceNotFoundException("Route found but polyline data is missing");
        }

        String encodedPolyline = (String) overviewPolyline.get("points");
        return new DirectionsResponse(encodedPolyline);
    }
}
