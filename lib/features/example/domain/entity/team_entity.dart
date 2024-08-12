import 'package:base_bloc_3/features/example/data/model/team/team.dart';

class TeamEntity {
  final int id;
  final String abbreviation;
  final String city;
  final String conference;
  final String division;
  final String fullName;
  final String name;

  TeamEntity({
    required this.id,
    required this.abbreviation,
    required this.city,
    required this.conference,
    required this.division,
    required this.fullName,
    required this.name,
  });

  factory TeamEntity.fromModel(Team? model) {
    return TeamEntity(
      id: model?.id ?? 0,
      abbreviation: model?.abbreviation ?? '',
      city: model?.city ?? '',
      conference: model?.conference ?? '',
      division: model?.division ?? '',
      fullName: model?.fullName ?? '',
      name: model?.name ?? '',
    );
  }
}