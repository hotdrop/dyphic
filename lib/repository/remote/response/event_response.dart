import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_response.freezed.dart';
part 'event_response.g.dart';

@freezed
class EventsResponse with _$EventsResponse {
  factory EventsResponse({
    @JsonKey(name: 'events') required List<EventResponse> events,
  }) = _EventsResponse;

  factory EventsResponse.fromJson(Map<String, dynamic> json) => _$EventsResponseFromJson(json);
}

@freezed
class EventResponse with _$EventResponse {
  factory EventResponse({
    @JsonKey(name: 'date') required int id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'type') required int typeIdx,
  }) = _EventResponse;

  factory EventResponse.fromJson(Map<String, dynamic> json) => _$EventResponseFromJson(json);
}
