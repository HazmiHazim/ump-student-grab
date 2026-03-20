package com.ump.studentgrab.presentation.controller;

import com.ump.studentgrab.application.dto.response.DirectionsResponse;
import com.ump.studentgrab.application.dto.response.PlaceSearchResponse;
import com.ump.studentgrab.application.dto.response.PlaceSuggestionResponse;
import com.ump.studentgrab.application.service.PlacesService;
import com.ump.studentgrab.presentation.response.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/places")
@RequiredArgsConstructor
public class PlacesController {

    private final PlacesService placesService;

    @GetMapping("/autocomplete")
    public ResponseEntity<ApiResponse<List<PlaceSuggestionResponse>>> autocomplete(
            @RequestParam String query,
            @RequestParam(defaultValue = "MY") String region) {
        return ResponseEntity.ok(ApiResponse.success(placesService.autocomplete(query, region)));
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<PlaceSearchResponse>>> search(
            @RequestParam String query,
            @RequestParam(defaultValue = "MY") String region) {
        return ResponseEntity.ok(ApiResponse.success(placesService.searchByText(query, region)));
    }

    @GetMapping("/directions")
    public ResponseEntity<ApiResponse<DirectionsResponse>> directions(
            @RequestParam String origin,
            @RequestParam String destination) {
        return ResponseEntity.ok(ApiResponse.success(placesService.getDirections(origin, destination)));
    }
}
