import 'package:dartz/dartz.dart';

import '../../../../base/network/errors/error.dart';
import '../entity/player/player_entity.dart';

abstract class ExampleUseCase {
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required int offset,
    required int limit,
  });
}
