import 'package:dartz/dartz.dart';

import '../../../../base/network/errors/error.dart';
import '../../data/model/index.dart';

abstract class ExampleUseCase {
  Future<Either<BaseError, List<Player>>> getData({
    required int offset,
    required int limit,
  });
}
