import 'package:base_bloc_3/import.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    final int? id,
    final String? firstName,
    final String? heightFeet,
    final String? heightInches,
    final String? lastName,
    final String? position,
    final Team? team,
    final String? weightPounds,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
