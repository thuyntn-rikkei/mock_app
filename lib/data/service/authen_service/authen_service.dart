import 'package:base_bloc_3/data/model/authen/index.dart';
import 'package:base_bloc_3/import.dart';
import 'package:retrofit/retrofit.dart';

part 'authen_service.g.dart';

@RestApi()
@injectable
abstract class AuthenService {
  @factoryMethod
  factory AuthenService(Dio dio) = _AuthenService;

  @GET(ApiEndpoint.loginApi)
  Future<LoginSuccessModel> login({
    @Queries() required LoginRequest request,
  });

  @GET(ApiEndpoint.loginApi)
  Future<void> register({
    @Queries() required RegisterRequest request,
  });
}
