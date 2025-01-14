import 'package:base_bloc_3/import.dart';

abstract class ExampleRepo {
  Future<Either<BaseError, List<ProductEntity>>> getData({
    required PagingRequest request,
  });
}
