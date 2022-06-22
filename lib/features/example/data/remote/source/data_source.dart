import '../../../../../base/network/models/base_data.dart';
import '../../model/index.dart';

abstract class DataSource {
  Future<BaseListData<Player>> getData({
    required int offset,
    required int limit,
  });
}
