import 'package:base_bloc_3/import.dart';

@Injectable(as: ExampleRepo)
class ExampleRepoImpl implements ExampleRepo {
  ExampleRepoImpl(this._exampleService);

  final ExampleService _exampleService;

  @override
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required GetPlayerRequest request,
  }) async {
    try {
      final result = await _exampleService.getData(
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
