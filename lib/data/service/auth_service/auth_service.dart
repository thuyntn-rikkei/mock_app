import 'package:base_bloc_3/data/model/authen/auth_token.dart';
import 'package:base_bloc_3/import.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi()
@injectable
abstract class AuthService {
  @factoryMethod
  factory AuthService(Dio dio) = _AuthService;

  @POST(ApiEndpoint.refreshToken)
  @FormUrlEncoded()
  Future<BaseData<AuthToken>> refreshToken(@Field() String refreshToken);
}
