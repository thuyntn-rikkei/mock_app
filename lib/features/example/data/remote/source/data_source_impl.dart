import 'package:base_bloc_3/features/example/data/remote/service/example_service.dart';
import 'package:base_bloc_3/features/example/data/remote/source/data_source.dart';
import 'package:injectable/injectable.dart';

import '../../../../../base/network/models/base_data.dart';
import '../../model/index.dart';

@Injectable(as: DataSource)
class DataSourceImpl implements DataSource {
  DataSourceImpl(this._service);

  final ExampleService _service;

  @override
  Future<BaseListData<Player>> getData({
    required int offset,
    required int limit,
  }) {
    return _service.getData(offset: offset, limit: limit);
  }
}
