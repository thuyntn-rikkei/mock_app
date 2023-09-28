import 'package:base_bloc_3/features/example/domain/entity/player_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player extends PlayerEntity with _$Player {
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

@freezed
class Team extends TeamEntity with _$Team {
  const factory Team({
    final int? id,
    final String? abbreviation,
    final String? city,
    final String? conference,
    final String? division,
    final String? fullName,
    final String? name,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}
