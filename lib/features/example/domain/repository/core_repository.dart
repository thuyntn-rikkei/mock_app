import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:dartz/dartz.dart';

import '../../data/model/player/player.dart';

abstract class ExampleRepo {
  Future<Either<BaseError, List<Player>>> getData({
    required int offset,
    required int limit,
  });
}
