import 'package:base_bloc_3/import.dart';

part 'get_player_request.freezed.dart';

part 'get_player_request.g.dart';

@freezed
class GetPlayerRequest with _$GetPlayerRequest {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetPlayerRequest({
    required int page,
    required int perPage,
  }) = _GetPlayerRequest;

  factory GetPlayerRequest.init() => const GetPlayerRequest(
        page: 1,
        perPage: ApiConfig.limit,
      );

  const GetPlayerRequest._();

  factory GetPlayerRequest.fromJson(Map<String, dynamic> json) =>
      _$GetPlayerRequestFromJson(json);
}
