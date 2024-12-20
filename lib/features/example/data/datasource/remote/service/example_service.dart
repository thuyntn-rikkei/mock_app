import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:base_bloc_3/base/network/models/base_data.dart';
import 'package:base_bloc_3/features/example/data/model/player/player.dart';

part 'example_service.g.dart';

@RestApi()
@injectable
abstract class ExampleService {
  @factoryMethod
  factory ExampleService(Dio dio) = _ExampleService;

  @GET("/players")
  Future<BaseListData<Player>> getData({
    @Query('page') required int offset,
    @Query('per_page') required int limit,
  });
}
