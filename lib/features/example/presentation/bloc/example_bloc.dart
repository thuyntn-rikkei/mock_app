import 'package:base_bloc_3/import.dart';

part 'example_bloc.freezed.dart';
part 'example_bloc.g.dart';
part 'example_event.dart';
part 'example_state.dart';

@injectable
class ExampleBloc extends BaseBloc<ExampleEvent, ExampleState>
    with BaseCommonMethodMixin {
  ExampleBloc(this._repo) : super(ExampleState.init()) {
    on<ExampleEvent>((ExampleEvent event, Emitter<ExampleState> emit) async {
      await event.when(
        getProductsList: (int page) => onGetData(emit, page),
        getProductDetail: (ProductEntity product) =>
            onGetProductDetail(emit, product),
      );
    });
  }

  final ExampleRepo _repo;
  final PagingController<int, ProductEntity> pagingController =
      PagingController(firstPageKey: 0);

  Future onGetData(Emitter<ExampleState> emit, int page) async {
    final Either<BaseError, List<ProductEntity>> result =
        await _repo.getData(request: PagingRequest(page: page));
    pagingControllerOnLoad(
      page,
      pagingController,
      result,
      onSuccess: (r) {
        emit(state.copyWith(status: BaseStateStatus.success, products: r));
      },
      onError: (l) {
        emit(state.copyWith(status: BaseStateStatus.failed, message: l));
      },
    );
  }

  Future onGetProductDetail(
    Emitter<ExampleState> emit,
    ProductEntity product,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading, productDetails: null));
    await Future.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        status: BaseStateStatus.showPopUp,
        productDetails: product,
      ),
    );
  }
}
