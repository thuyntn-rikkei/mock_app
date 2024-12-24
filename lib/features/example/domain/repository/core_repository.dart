import 'package:base_bloc_3/import.dart';

abstract class ExampleRepo {
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required GetPlayerRequest request,
  });
}
