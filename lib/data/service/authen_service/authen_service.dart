import 'package:base_bloc_3/data/model/authen/auth_token.dart';
import 'package:base_bloc_3/data/model/authen/index.dart';
import 'package:base_bloc_3/import.dart';
import 'package:retrofit/retrofit.dart';

part 'authen_service.g.dart';

@RestApi()
@injectable
abstract class AuthenService {
  @factoryMethod
  factory AuthenService(Dio dio) = _AuthenService;

  @POST(ApiEndpoint.loginApi)
  Future<LoginSuccessModel> login({
    @Body() LoginRequest request,
  });

  @POST(ApiEndpoint.loginApi)
  Future<void> register({
    @Body() RegisterRequest request,
  });

  @POST(ApiEndpoint.refreshToken)
  @FormUrlEncoded()
  Future<BaseData<AuthToken>> refreshToken(@Field() String refreshToken);
}
