import 'package:freezed_annotation/freezed_annotation.dart';
part 'team.freezed.dart';
part 'team.g.dart';

@freezed
class Team with _$Team {
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