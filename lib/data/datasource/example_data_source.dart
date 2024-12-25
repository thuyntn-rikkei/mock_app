import 'package:base_bloc_3/import.dart';

abstract class ExampleDataSource {
  Future<BaseListData<Player>> getData({
    required GetPlayerRequest request,
  });
}
