part of 'example_bloc.dart';

@CopyWith()
class ExampleState extends BaseBlocState {
  final List<ProductEntity> products;
  final ProductEntity? productDetails;
  const ExampleState({
    required super.status,
    super.message,
    this.products = const [],
    this.productDetails,
  });

  factory ExampleState.init() {
    return const ExampleState(status: BaseStateStatus.init);
  }

  @override
  List get props => [
        status,
        message,
        products,
        productDetails,
      ];
}
