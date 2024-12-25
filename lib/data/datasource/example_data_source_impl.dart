import 'package:base_bloc_3/import.dart';

@Injectable(as: ExampleDataSource)
class ExampleDataSourceImpl implements ExampleDataSource {
  ExampleDataSourceImpl(this._service);

  final ExampleService _service;

  @override
  Future<BaseListData<Player>> getData({
    required GetPlayerRequest request,
  }) {
    return _service.getData(request: request);
  }
}
