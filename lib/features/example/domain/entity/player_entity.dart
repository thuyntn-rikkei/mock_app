import 'package:base_bloc_3/features/example/data/index.dart';
import 'package:base_bloc_3/features/example/domain/entity/team_entity.dart';

class PlayerEntity {
  final int id;
  final String firstName;
  final String heightFeet;
  final String heightInches;
  final String lastName;
  final String position;
  final TeamEntity? team;
  final String weightPounds;

  PlayerEntity({
    required this.id,
    required this.firstName,
    required this.heightFeet,
    required this.heightInches,
    required this.lastName,
    required this.position,
    this.team,
    required this.weightPounds,
  });

  factory PlayerEntity.fromModel(Player model) {
    return PlayerEntity(
      id: model.id ?? 0,
      firstName: model.firstName ?? '',
      heightFeet: model.heightFeet ?? '',
      heightInches: model.heightInches ?? '',
      lastName: model.lastName ?? '',
      position: model.position ?? '',
      team: TeamEntity.fromModel(model.team),
      weightPounds: model.weightPounds ?? '',
    );
  }
}
