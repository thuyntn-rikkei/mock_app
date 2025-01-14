part of 'example_bloc.dart';

@freezed
class ExampleEvent with _$ExampleEvent {
  const factory ExampleEvent.getProductsList(int page) = GetProductsList;
  const factory ExampleEvent.getProductDetail(ProductEntity product) =
      GetProductDetail;
}
