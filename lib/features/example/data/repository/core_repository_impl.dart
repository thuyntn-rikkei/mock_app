import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/base/network/errors/extension.dart';
import 'package:base_bloc_3/features/example/data/datasource/index.dart';
import 'package:base_bloc_3/features/example/domain/entity/player_entity.dart';
import 'package:base_bloc_3/features/example/domain/repository/core_repository.dart';

@Injectable(as: ExampleRepo)
class ExampleRepoImpl implements ExampleRepo {
  ExampleRepoImpl(this._remoteDataSource);

  final DataSource _remoteDataSource;

  @override
  Future<Either<BaseError, List<PlayerEntity>>> getData({
    required int offset,
    required int limit,
  }) async {
    try {
      final result = await _remoteDataSource.getData(
        limit: limit,
        offset: offset,
      );
      return right(
        (result.data ?? []).map((e) => PlayerEntity.fromModel(e)).toList(),
      );
    } on DioException catch (exception) {
      return left(exception.baseError);
    }
  }
}
