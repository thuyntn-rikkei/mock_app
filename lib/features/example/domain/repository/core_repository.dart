import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/features/example/domain/entity/player_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ExampleRepo {
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required int offset,
    required int limit,
  });
}
