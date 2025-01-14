import 'package:base_bloc_3/import.dart';
import 'package:retrofit/retrofit.dart';

part 'example_service.g.dart';

@RestApi()
@injectable
abstract class ExampleService {
  @factoryMethod
  factory ExampleService(Dio dio) = _ExampleService;

  @GET(ApiEndpoint.getProducts)
  Future<BaseListData<ProductModel>> getData({
    required PagingRequest request,
  });
}
