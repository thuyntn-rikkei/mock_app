import 'package:base_bloc_3/import.dart';

@Injectable(as: ExampleRepo)
class ExampleRepoImpl implements ExampleRepo {
  ExampleRepoImpl(this._remoteDataSource);

  final ExampleDataSource _remoteDataSource;

  @override
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required GetPlayerRequest request,
  }) async {
    try {
      final result = await _remoteDataSource.getData(
        request: request,
      );
      return right(
        (result.data ?? []).map((e) => PlayerEntity.fromModel(e)).toList(),
      );
    } on DioException catch (exception) {
      return left(exception.baseError);
    }
  }
}
