import 'package:base_bloc_3/import.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState
    extends BaseState<ExamplePage, ExampleEvent, ExampleState, ExampleBloc>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    bloc.pagingController.addPageRequestListener(
      (page) => bloc.add(ExampleEvent.getProductsList(page)),
    );
  }

  @override
  void listener(BuildContext context, ExampleState state) {
    super.listener(context, state);
    if (state.status == BaseStateStatus.showPopUp) {
      DialogUtils.showCustomDialog(
        child: _productDetailsDialog(state.productDetails),
      );
    }
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: "Example Page",
      ),
      body: CustomListViewSeparated(
        controller: bloc.pagingController,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        builder: (context, product, index) => ProductItem(
          product: product,
          onTap: () {
            bloc.add(ExampleEvent.getProductDetail(product));
          },
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
      ),
    );
  }

  Widget _productDetailsDialog(ProductEntity? product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: blocBuilder(
        (context, state) {
          if (product == null) {
            return const Center(child: LoadingWidget());
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                style: AppStyles.s20w700,
              ),
              CachedImageWidget(
                url: product.thumbnail,
                height: 200.h,
                fit: BoxFit.contain,
              ),
              Text(
                product.description,
                style: AppStyles.s16w400,
              ),
            ],
          );
        },
      ),
    );
  }
}
