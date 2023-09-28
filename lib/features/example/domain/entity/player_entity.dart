class PlayerEntity {
  final int? id;
  final String? firstName;
  final String? heightFeet;
  final String? heightInches;
  final String? lastName;
  final String? position;
  final TeamEntity? team;
  final String? weightPounds;

  PlayerEntity({
    this.id,
    this.firstName,
    this.heightFeet,
    this.heightInches,
    this.lastName,
    this.position,
    this.team,
    this.weightPounds,
  });
}

class TeamEntity {
  final int? id;
  final String? abbreviation;
  final String? city;
  final String? conference;
  final String? division;
  final String? fullName;
  final String? name;

  TeamEntity({
    this.id,
    this.abbreviation,
    this.city,
    this.conference,
    this.division,
    this.fullName,
    this.name,
  });
}
